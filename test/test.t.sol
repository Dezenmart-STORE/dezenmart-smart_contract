// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DezenMartLogistics} from "../src/logistic.sol";
import {Tether} from "../src/token.sol";

contract DezenMartLogisticsTest is Test {
    DezenMartLogistics public logistics;
    Tether public usdt;

    address public admin = address(0x1);
    address public buyer = address(0x2);
    address public seller = address(0x3);
    address public logisticsProvider = address(0x4);

    uint256 public constant PRODUCT_COST = 3_000_000; // $3 in micro-USDT
    uint256 public constant LOGISTICS_COST = 1_000_000; // $1 in micro-USDT
    uint256 public constant TOTAL_AMOUNT = PRODUCT_COST + LOGISTICS_COST;
    uint256 public constant ESCROW_FEE_PERCENT = 250; // 2.5%
    uint256 public constant BASIS_POINTS = 10_000;

    function setUp() public {
        // Deploy Tether and mint tokens to buyer
        vm.startPrank(admin);
        usdt = new Tether();
        usdt.mint(buyer, 1_000_000_000_000); // 1M USDT
        vm.stopPrank();

        // Deploy DezenMartLogistics
        vm.prank(admin);
        logistics = new DezenMartLogistics(address(usdt));

        // Register seller and logistics provider
        vm.prank(seller);
        logistics.registerSeller();
        vm.prank(admin);
        logistics.registerLogisticsProvider(logisticsProvider);

        // Approve USDT for buyer
        vm.prank(buyer);
        usdt.approve(address(logistics), TOTAL_AMOUNT);
    }

    function testCreateTradeWithUSDT() public {
        vm.prank(buyer);
        uint256 tradeId = logistics.createTrade(seller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true);

        // Access trades mapping correctly
        DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
        assertEq(trade.buyer, buyer, "Incorrect buyer");
        assertEq(trade.seller, seller, "Incorrect seller");
        assertEq(trade.logisticsProvider, logisticsProvider, "Incorrect logistics provider");
        assertEq(trade.productCost, PRODUCT_COST, "Incorrect product cost");
        assertEq(trade.logisticsCost, LOGISTICS_COST, "Incorrect logistics cost");
        assertEq(trade.totalAmount, TOTAL_AMOUNT, "Incorrect total amount");
        assertEq(
            trade.escrowFee,
            (PRODUCT_COST * ESCROW_FEE_PERCENT) / BASIS_POINTS + (LOGISTICS_COST * ESCROW_FEE_PERCENT) / BASIS_POINTS,
            "Incorrect escrow fee"
        );
        assertTrue(trade.logisticsSelected, "Logistics not selected");
        assertFalse(trade.delivered, "Trade should not be delivered");
        assertFalse(trade.completed, "Trade should not be completed");
        assertFalse(trade.disputed, "Trade should not be disputed");
        assertTrue(trade.isUSDT, "Trade should use USDT");

        // Access buyerTrades mapping correctly
        uint256[] memory buyerTrades = logistics.buyerTrades(buyer);
        assertEq(buyerTrades.length, 1, "Incorrect number of buyer trades");
        assertEq(buyerTrades[0], tradeId, "Incorrect trade ID in buyerTrades");
    }

    function testCreateTradeWithETH() public {
        vm.deal(buyer, TOTAL_AMOUNT);
        vm.prank(buyer);
        uint256 tradeId = logistics.createTrade{value: TOTAL_AMOUNT}(seller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, false);

        DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
        assertEq(trade.totalAmount, TOTAL_AMOUNT, "Incorrect total amount");
        assertFalse(trade.isUSDT, "Trade should use ETH");
    }

    function testConfirmDeliveryUSDT() public {
        vm.prank(buyer);
        uint256 tradeId = logistics.createTrade(seller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true);

        uint256 sellerBalanceBefore = usdt.balanceOf(seller);
        uint256 providerBalanceBefore = usdt.balanceOf(logisticsProvider);
        uint256 contractBalanceBefore = usdt.balanceOf(address(logistics));

        vm.prank(buyer);
        logistics.confirmDelivery(tradeId);

        DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
        assertTrue(trade.delivered, "Trade not marked as delivered");
        assertTrue(trade.completed, "Trade not marked as completed");

        uint256 productEscrowFee = (PRODUCT_COST * ESCROW_FEE_PERCENT) / BASIS_POINTS;
        uint256 logisticsEscrowFee = (LOGISTICS_COST * ESCROW_FEE_PERCENT) / BASIS_POINTS;
        uint256 sellerAmount = PRODUCT_COST - productEscrowFee;
        uint256 logisticsAmount = LOGISTICS_COST - logisticsEscrowFee;

        assertEq(usdt.balanceOf(seller), sellerBalanceBefore + sellerAmount, "Incorrect seller balance");
        assertEq(usdt.balanceOf(logisticsProvider), providerBalanceBefore + logisticsAmount, "Incorrect provider balance");
        assertEq(
            usdt.balanceOf(address(logistics)),
            contractBalanceBefore - sellerAmount - logisticsAmount,
            "Incorrect contract balance"
        );
    }

    function testRaiseAndResolveDispute() public {
        vm.prank(buyer);
        uint256 tradeId = logistics.createTrade(seller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true);

        vm.prank(buyer);
        logistics.raiseDispute(tradeId);

        DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
        assertTrue(trade.disputed, "Trade not marked as disputed");

        uint256 buyerBalanceBefore = usdt.balanceOf(buyer);
        vm.prank(admin);
        logistics.resolveDispute(tradeId, buyer);

        trade = logistics.trades(tradeId);
        assertTrue(trade.completed, "Trade not marked as completed");
        assertTrue(logistics.disputesResolved(tradeId), "Dispute not marked as resolved");
        assertEq(usdt.balanceOf(buyer), buyerBalanceBefore + TOTAL_AMOUNT, "Buyer not refunded");
    }

    function testWithdrawEscrowFeesUSDT() public {
        vm.prank(buyer);
        uint256 tradeId = logistics.createTrade(seller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true);

        vm.prank(buyer);
        logistics.confirmDelivery(tradeId);

        uint256 adminBalanceBefore = usdt.balanceOf(admin);
        uint256 contractBalanceBefore = usdt.balanceOf(address(logistics));

        vm.prank(admin);
        logistics.withdrawEscrowFeesUSDT();

        assertEq(
            usdt.balanceOf(admin),
            adminBalanceBefore + contractBalanceBefore,
            "Admin did not receive correct USDT fees"
        );
        assertEq(usdt.balanceOf(address(logistics)), 0, "Contract USDT balance not zero");
    }

    function testFailInsufficientUSDTAllowance() public {
        vm.prank(buyer);
        usdt.approve(address(logistics), 0); // Revoke allowance

        vm.prank(buyer);
        vm.expectRevert(abi.encodeWithSelector(DezenMartLogistics.InsufficientUSDTAllowance.selector, TOTAL_AMOUNT, 0));
        logistics.createTrade(seller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true);
    }

    function testFailInvalidSeller() public {
        address invalidSeller = address(0x5);
        vm.prank(buyer);
        vm.expectRevert("Invalid seller");
        logistics.createTrade(invalidSeller, PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true);
    }
}