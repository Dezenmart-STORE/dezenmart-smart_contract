// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import "../src/logistic.sol";
// import "../src/token.sol";

// contract DezenMartLogisticsTest is Test {
//     DezenMartLogistics logistics;
//     Tether usdt;
//     address admin = address(0x1);
//     address seller = address(0x2);
//     address buyer = address(0x3);
//     address logisticsProvider = address(0x4);
//     address invalidSeller = address(0x5);

//     uint256 constant PRODUCT_COST = 1000 * 10 ** 6; // 1000 USDT (6 decimals)
//     uint256 constant LOGISTICS_COST = 100 * 10 ** 6; // 100 USDT
//     uint256 constant TOTAL_QUANTITY = 10; // 10 units available
//     uint256 constant TOTAL_AMOUNT = (PRODUCT_COST + LOGISTICS_COST) * TOTAL_QUANTITY;

//     function setUp() public {
//         // Deploy mock USDT contract
//         vm.prank(admin);
//         usdt = new Tether();

//         // Deploy DezenMartLogistics contract
//         vm.prank(admin);
//         logistics = new DezenMartLogistics(address(usdt));

//         // Register logistics provider
//         vm.prank(admin);
//         logistics.registerLogisticsProvider(logisticsProvider);

//         // Mint USDT to buyer for testing
//         vm.prank(admin);
//         usdt.transfer(buyer, TOTAL_AMOUNT);

//         // Approve logistics contract to spend buyer's USDT
//         vm.prank(buyer);
//         usdt.approve(address(logistics), TOTAL_AMOUNT);
//     }

//     function testCreateTradeWithUSDT() public {
//         vm.prank(seller);
//         uint256 tradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true, TOTAL_QUANTITY);

//         // Access specific fields to reduce stack usage
//         DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
//         assertEq(trade.seller, seller);
//         assertEq(trade.productCost, PRODUCT_COST);
//         assertEq(trade.logisticsCost, LOGISTICS_COST);
//         assertEq(trade.totalQuantity, TOTAL_QUANTITY);
//         assertEq(trade.remainingQuantity, TOTAL_QUANTITY);
//         assertEq(trade.logisticsProvider, logisticsProvider);
//         assertEq(trade.isUSDT, true);
//         assertEq(trade.buyer, address(0));
//     }

//     function testBuyTradeWithUSDTMultipleQuantities() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 parentTradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true, TOTAL_QUANTITY);

//         // Buyer purchases 5 units in one transaction
//         uint256 quantity = 5;
//         vm.prank(buyer);
//         uint256 tradeId = logistics.buyTrade(parentTradeId, quantity);

//         // Check buyer's trade
//         DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
//         assertEq(trade.buyer, buyer);
//         assertEq(trade.seller, seller);
//         assertEq(trade.productCost, PRODUCT_COST * quantity);
//         assertEq(trade.logisticsCost, LOGISTICS_COST * quantity);
//         assertEq(trade.totalQuantity, quantity);
//         assertEq(trade.remainingQuantity, 0);
//         assertEq(trade.parentTradeId, parentTradeId);

//         // Check original trade's remaining quantity
//         DezenMartLogistics.Trade memory parentTrade = logistics.trades(parentTradeId);
//         assertEq(parentTrade.remainingQuantity, TOTAL_QUANTITY - quantity);

//         // Check buyer's trade list
//         uint256[] memory buyerTradesList = logistics.buyerTrades(buyer);
//         assertEq(buyerTradesList.length, 1);
//         assertEq(buyerTradesList[0], tradeId);
//     }

//     function testBuyTradeWithUSDTMultipleTransactions() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 parentTradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true, TOTAL_QUANTITY);

//         // Buyer purchases 2 units
//         uint256 quantity1 = 2;
//         vm.prank(buyer);
//         uint256 tradeId1 = logistics.buyTrade(parentTradeId, quantity1);

//         // Buyer purchases 3 more units in a separate transaction
//         uint256 quantity2 = 3;
//         vm.prank(buyer);
//         uint256 tradeId2 = logistics.buyTrade(parentTradeId, quantity2);

//         // Verify different trade IDs
//         assertTrue(tradeId1 != tradeId2, "Trade IDs should be different");

//         // Check first trade
//         DezenMartLogistics.Trade memory trade1 = logistics.trades(tradeId1);
//         assertEq(trade1.buyer, buyer);
//         assertEq(trade1.seller, seller);
//         assertEq(trade1.productCost, PRODUCT_COST * quantity1);
//         assertEq(trade1.logisticsCost, LOGISTICS_COST * quantity1);
//         assertEq(trade1.totalQuantity, quantity1);
//         assertEq(trade1.parentTradeId, parentTradeId);

//         // Check second trade
//         DezenMartLogistics.Trade memory trade2 = logistics.trades(tradeId2);
//         assertEq(trade2.buyer, buyer);
//         assertEq(trade2.seller, seller);
//         assertEq(trade2.productCost, PRODUCT_COST * quantity2);
//         assertEq(trade2.logisticsCost, LOGISTICS_COST * quantity2);
//         assertEq(trade2.totalQuantity, quantity2);
//         assertEq(trade2.parentTradeId, parentTradeId);

//         // Check original trade's remaining quantity
//         DezenMartLogistics.Trade memory parentTrade = logistics.trades(parentTradeId);
//         assertEq(parentTrade.remainingQuantity, TOTAL_QUANTITY - (quantity1 + quantity2));

//         // Check buyer's trade list
//         uint256[] memory buyerTradesList = logistics.buyerTrades(buyer);
//         assertEq(buyerTradesList.length, 2);
//         assertEq(buyerTradesList[0], tradeId1);
//         assertEq(buyerTradesList[1], tradeId2);
//     }

//     function testBuyTradeWithUSDTAfterCompletedTrade() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 parentTradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true, TOTAL_QUANTITY);

//         // Buyer purchases 2 units
//         uint256 quantity1 = 2;
//         vm.prank(buyer);
//         uint256 tradeId1 = logistics.buyTrade(parentTradeId, quantity1);

//         // Buyer confirms delivery to complete the trade
//         vm.prank(buyer);
//         logistics.confirmDelivery(tradeId1);

//         // Buyer purchases 3 more units
//         uint256 quantity2 = 3;
//         vm.prank(buyer);
//         uint256 tradeId2 = logistics.buyTrade(parentTradeId, quantity2);

//         // Verify different trade IDs
//         assertTrue(tradeId1 != tradeId2, "Trade IDs should be different");

//         // Check second trade
//         DezenMartLogistics.Trade memory trade2 = logistics.trades(tradeId2);
//         assertEq(trade2.buyer, buyer);
//         assertEq(trade2.seller, seller);
//         assertEq(trade2.productCost, PRODUCT_COST * quantity2);
//         assertEq(trade2.logisticsCost, LOGISTICS_COST * quantity2);
//         assertEq(trade2.totalQuantity, quantity2);
//         assertEq(trade2.parentTradeId, parentTradeId);

//         // Check original trade's remaining quantity
//         DezenMartLogistics.Trade memory parentTrade = logistics.trades(parentTradeId);
//         assertEq(parentTrade.remainingQuantity, TOTAL_QUANTITY - (quantity1 + quantity2));
//     }

//     function testCreateTradeWithETH() public {
//         vm.prank(seller);
//         uint256 tradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, false, TOTAL_QUANTITY);

//         // Access specific fields to reduce stack usage
//         DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
//         assertEq(trade.seller, seller);
//         assertEq(trade.productCost, PRODUCT_COST);
//         assertEq(trade.logisticsCost, LOGISTICS_COST);
//         assertEq(trade.totalQuantity, TOTAL_QUANTITY);
//         assertEq(trade.remainingQuantity, TOTAL_QUANTITY);
//         assertEq(trade.logisticsProvider, logisticsProvider);
//         assertEq(trade.isUSDT, false);
//         assertEq(trade.buyer, address(0));
//     }

//     function testBuyTradeWithETHMultipleQuantities() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 parentTradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, false, TOTAL_QUANTITY);

//         // Buyer purchases 5 units
//         uint256 quantity = 5;
//         uint256 totalAmount = (PRODUCT_COST + LOGISTICS_COST) * quantity;
//         vm.deal(buyer, totalAmount);
//         vm.prank(buyer);
//         uint256 tradeId = logistics.buyTrade{value: totalAmount}(parentTradeId, quantity);

//         // Check buyer's trade
//         DezenMartLogistics.Trade memory trade = logistics.trades(tradeId);
//         assertEq(trade.buyer, buyer);
//         assertEq(trade.seller, seller);
//         assertEq(trade.productCost, PRODUCT_COST * quantity);
//         assertEq(trade.logisticsCost, LOGISTICS_COST * quantity);
//         assertEq(trade.totalQuantity, quantity);
//         assertEq(trade.remainingQuantity, 0);
//         assertEq(trade.parentTradeId, parentTradeId);

//         // Check original trade's remaining quantity
//         DezenMartLogistics.Trade memory parentTrade = logistics.trades(parentTradeId);
//         assertEq(parentTrade.remainingQuantity, TOTAL_QUANTITY - quantity);
//     }

//     function testBuyTradeWithETHMultipleTransactions() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 parentTradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, false, TOTAL_QUANTITY);

//         // Buyer purchases 2 units
//         uint256 quantity1 = 2;
//         uint256 totalAmount1 = (PRODUCT_COST + LOGISTICS_COST) * quantity1;
//         vm.deal(buyer, totalAmount1);
//         vm.prank(buyer);
//         uint256 tradeId1 = logistics.buyTrade{value: totalAmount1}(parentTradeId, quantity1);

//         // Buyer purchases 3 more units
//         uint256 quantity2 = 3;
//         uint256 totalAmount2 = (PRODUCT_COST + LOGISTICS_COST) * quantity2;
//         vm.deal(buyer, totalAmount2);
//         vm.prank(buyer);
//         uint256 tradeId2 = logistics.buyTrade{value: totalAmount2}(parentTradeId, quantity2);

//         // Verify different trade IDs
//         assertTrue(tradeId1 != tradeId2, "Trade IDs should be different");

//         // Check first trade
//         DezenMartLogistics.Trade memory trade1 = logistics.trades(tradeId1);
//         assertEq(trade1.buyer, buyer);
//         assertEq(trade1.seller, seller);
//         assertEq(trade1.productCost, PRODUCT_COST * quantity1);
//         assertEq(trade1.logisticsCost, LOGISTICS_COST * quantity1);
//         assertEq(trade1.totalQuantity, quantity1);
//         assertEq(trade1.parentTradeId, parentTradeId);

//         // Check second trade
//         DezenMartLogistics.Trade memory trade2 = logistics.trades(tradeId2);
//         assertEq(trade2.buyer, buyer);
//         assertEq(trade2.seller, seller);
//         assertEq(trade2.productCost, PRODUCT_COST * quantity2);
//         assertEq(trade2.logisticsCost, LOGISTICS_COST * quantity2);
//         assertEq(trade2.totalQuantity, quantity2);
//         assertEq(trade2.parentTradeId, parentTradeId);

//         // Check original trade's remaining quantity
//         DezenMartLogistics.Trade memory parentTrade = logistics.trades(parentTradeId);
//         assertEq(parentTrade.remainingQuantity, TOTAL_QUANTITY - (quantity1 + quantity2));
//     }

//     function testFailBuyTradeBySeller() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 tradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true, TOTAL_QUANTITY);

//         // Seller tries to buy (should fail)
//         vm.prank(seller);
//         vm.expectRevert("Buyer cannot be the seller");
//         logistics.buyTrade(tradeId, 1);
//     }

//     function testFailBuyTradeWithInsufficientQuantity() public {
//         // Seller creates trade
//         vm.prank(seller);
//         uint256 tradeId = logistics.createTrade(PRODUCT_COST, logisticsProvider, LOGISTICS_COST, true, TOTAL_QUANTITY);

//         // Buyer tries to buy more than available
//         vm.prank(buyer);
//         vm.expectRevert("Insufficient quantity available");
//         logistics.buyTrade(tradeId, TOTAL_QUANTITY + 1);
//     }
// }