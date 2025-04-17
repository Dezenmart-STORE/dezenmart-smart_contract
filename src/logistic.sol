// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DezenMartLogistics {
    // Constants
    uint256 public constant ESCROW_FEE_PERCENT = 250; // 2.5% (in basis points, 10000 = 100%)
    uint256 public constant BASIS_POINTS = 10000;

    // Roles
    address public admin;
    IERC20 public usdt; // USDT contract address
    mapping(address => bool) public logisticsProviders;
    mapping(address => bool) public sellers;

    // Trade structure
    struct Trade {
        address buyer;
        address seller;
        address logisticsProvider; // Zero address if no logistics
        uint256 productCost;
        uint256 logisticsCost;
        uint256 escrowFee;
        uint256 totalAmount;
        bool logisticsSelected;
        bool delivered;
        bool completed;
        bool disputed;
        bool isUSDT; // True for USDT, false for ETH
    }

    // State variables
    mapping(uint256 => Trade) public trades;
    uint256 public tradeCounter;
    mapping(uint256 => bool) public disputesResolved;

    // Events
    event TradeCreated(uint256 tradeId, address buyer, address seller, address logisticsProvider, uint256 totalAmount, bool isUSDT);
    event LogisticsSelected(uint256 tradeId, address logisticsProvider, uint256 logisticsCost);
    event PaymentHeld(uint256 tradeId, uint256 totalAmount, bool isUSDT);
    event DeliveryConfirmed(uint256 tradeId);
    event PaymentSettled(uint256 tradeId, uint256 sellerAmount, uint256 logisticsAmount, bool isUSDT);
    event DisputeRaised(uint256 tradeId, address initiator);
    event DisputeResolved(uint256 tradeId, address winner, bool isUSDT);

    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier onlyTradeParticipant(uint256 tradeId) {
        Trade memory trade = trades[tradeId];
        require(
            msg.sender == trade.buyer || msg.sender == trade.seller || msg.sender == trade.logisticsProvider,
            "Not a trade participant"
        );
        _;
    }

    constructor(address _usdtAddress) {
        admin = msg.sender;
        usdt = IERC20(_usdtAddress);
    }

    // Register logistics provider
    function registerLogisticsProvider(address provider) external onlyAdmin {
        logisticsProviders[provider] = true;
    }

    // Register seller
    function registerSeller() external {
        sellers[msg.sender] = true;
    }

    // Create trade (buyer initiates)
    function createTrade(
        address seller,
        uint256 productCost,
        address logisticsProvider,
        uint256 logisticsCost,
        bool useUSDT
    ) external payable returns (uint256) {
        require(sellers[seller], "Invalid seller");
        require(logisticsProvider == address(0) || logisticsProviders[logisticsProvider], "Invalid logistics provider");

        bool logisticsSelected = logisticsProvider != address(0);
        uint256 totalCost = productCost + (logisticsSelected ? logisticsCost : 0);
        uint256 escrowFee = (totalCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
        uint256 totalAmount = totalCost + escrowFee;

        // Handle payment based on useUSDT flag
        if (useUSDT) {
            require(msg.value == 0, "ETH sent for USDT payment");
            require(usdt.transferFrom(msg.sender, address(this), totalAmount), "USDT transfer failed");
        } else {
            require(msg.value == totalAmount, "Incorrect ETH amount");
        }

        tradeCounter++;
        uint256 tradeId = tradeCounter;

        trades[tradeId] = Trade({
            buyer: msg.sender,
            seller: seller,
            logisticsProvider: logisticsProvider,
            productCost: productCost,
            logisticsCost: logisticsCost,
            escrowFee: escrowFee,
            totalAmount: totalAmount,
            logisticsSelected: logisticsSelected,
            delivered: false,
            completed: false,
            disputed: false,
            isUSDT: useUSDT
        });

        emit TradeCreated(tradeId, msg.sender, seller, logisticsProvider, totalAmount, useUSDT);
        if (logisticsSelected) {
            emit LogisticsSelected(tradeId, logisticsProvider, logisticsCost);
        }
        emit PaymentHeld(tradeId, totalAmount, useUSDT);

        return tradeId;
    }

    // Confirm delivery (buyer)
    function confirmDelivery(uint256 tradeId) external {
        Trade storage trade = trades[tradeId];
        require(msg.sender == trade.buyer, "Only buyer can confirm delivery");
        require(!trade.delivered, "Already delivered");
        require(!trade.disputed, "Trade in dispute");
        require(!trade.completed, "Trade already completed");

        trade.delivered = true;
        emit DeliveryConfirmed(tradeId);

        // Settle payments automatically upon delivery
        settlePayments(tradeId);
    }

    // Settle payments to seller and logistics provider
    function settlePayments(uint256 tradeId) internal {
        Trade storage trade = trades[tradeId];
        require(trade.delivered, "Delivery not confirmed");
        require(!trade.completed, "Payments already settled");

        trade.completed = true;

        // Seller receives full product cost
        uint256 sellerAmount = trade.productCost;
        if (trade.isUSDT) {
            require(usdt.transfer(trade.seller, sellerAmount), "USDT transfer to seller failed");
        } else {
            payable(trade.seller).transfer(sellerAmount);
        }

        // Logistics provider receives logistics cost minus 2.5% escrow fee
        uint256 logisticsAmount = 0;
        if (trade.logisticsSelected) {
            uint256 logisticsFee = (trade.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
            logisticsAmount = trade.logisticsCost - logisticsFee;
            if (trade.isUSDT) {
                require(usdt.transfer(trade.logisticsProvider, logisticsAmount), "USDT transfer to logistics failed");
            } else {
                payable(trade.logisticsProvider).transfer(logisticsAmount);
            }
        }

        // Escrow fee remains in contract (admin can withdraw separately)
        emit PaymentSettled(tradeId, sellerAmount, logisticsAmount, trade.isUSDT);
    }

    // Raise dispute
    function raiseDispute(uint256 tradeId) external onlyTradeParticipant(tradeId) {
        Trade storage trade = trades[tradeId];
        require(!trade.completed, "Trade already completed");
        require(!trade.disputed, "Dispute already raised");

        trade.disputed = true;
        emit DisputeRaised(tradeId, msg.sender);
    }

    // Resolve dispute (admin)
    function resolveDispute(uint256 tradeId, address winner) external onlyAdmin {
        Trade storage trade = trades[tradeId];
        require(trade.disputed, "No active dispute");
        require(!disputesResolved[tradeId], "Dispute already resolved");
        require(
            winner == trade.buyer || winner == trade.seller || winner == trade.logisticsProvider,
            "Invalid winner"
        );

        disputesResolved[tradeId] = true;
        trade.completed = true;

        // Refund or distribute funds based on admin decision
        if (winner == trade.buyer) {
            if (trade.isUSDT) {
                require(usdt.transfer(trade.buyer, trade.totalAmount), "USDT refund failed");
            } else {
                payable(trade.buyer).transfer(trade.totalAmount);
            }
        } else {
            // Seller gets product cost
            if (trade.isUSDT) {
                require(usdt.transfer(trade.seller, trade.productCost), "USDT transfer to seller failed");
            } else {
                payable(trade.seller).transfer(trade.productCost);
            }
            // Logistics provider gets logistics cost minus escrow fee
            if (trade.logisticsSelected) {
                uint256 logisticsFee = (trade.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
                if (trade.isUSDT) {
                    require(usdt.transfer(trade.logisticsProvider, trade.logisticsCost - logisticsFee), "USDT transfer to logistics failed");
                } else {
                    payable(trade.logisticsProvider).transfer(trade.logisticsCost - logisticsFee);
                }
            }
        }

        emit DisputeResolved(tradeId, winner, trade.isUSDT);
    }

    // Admin withdraw escrow fees (ETH)
    function withdrawEscrowFeesETH() external onlyAdmin {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH fees to withdraw");
        payable(admin).transfer(balance);
    }

    // Admin withdraw escrow fees (USDT)
    function withdrawEscrowFeesUSDT() external onlyAdmin {
        uint256 balance = usdt.balanceOf(address(this));
        require(balance > 0, "No USDT fees to withdraw");
        require(usdt.transfer(admin, balance), "USDT withdrawal failed");
    }

    // Refund if trade canceled (before delivery)
    function cancelTrade(uint256 tradeId) external {
        Trade storage trade = trades[tradeId];
        require(msg.sender == trade.buyer, "Only buyer can cancel");
        require(!trade.delivered, "Delivery already confirmed");
        require(!trade.disputed, "Trade in dispute");
        require(!trade.completed, "Trade already completed");

        trade.completed = true;
        if (trade.isUSDT) {
            require(usdt.transfer(trade.buyer, trade.totalAmount), "USDT refund failed");
        } else {
            payable(trade.buyer).transfer(trade.totalAmount);
        }
    }
}