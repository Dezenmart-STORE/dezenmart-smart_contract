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
        address buyer; // Set when buyer purchases the trade
        address seller; // Set when seller creates the trade
        address[] logisticsProviders; // List of available logistics providers
        uint256[] logisticsCosts; // Corresponding costs for each provider
        address chosenLogisticsProvider; // Provider selected by buyer
        uint256 productCost; // In smallest unit (micro-USDT for USDT, wei for ETH)
        uint256 logisticsCost; // Cost of chosen provider, set by buyer
        uint256 escrowFee; // 2.5% of productCost + 2.5% of logisticsCost
        uint256 totalAmount; // productCost + logisticsCost
        uint256 totalQuantity; // Total number of goods purchased in this trade
        uint256 remainingQuantity; // Remaining goods available (for seller trades)
        bool logisticsSelected; // True if buyer selects a provider
        bool delivered; // True if delivery is confirmed
        bool completed; // True if trade is settled or canceled
        bool disputed; // True if dispute is raised
        bool isUSDT; // True for USDT, false for ETH
        uint256 parentTradeId; // Links to original trade ID (0 for seller trades)
    }

    // State variables
    mapping(uint256 => Trade) public trades;
    uint256 public tradeCounter;
    mapping(uint256 => bool) public disputesResolved;
    mapping(address => uint256[]) public buyerTrades; // Tracks trade IDs per buyer
    mapping(address => uint256[]) public sellerTrades; // Tracks original trade IDs per seller

    // Events
    event TradeCreated(uint256 indexed tradeId, address indexed seller, address[] logisticsProviders, uint256 productCost, uint256[] logisticsCosts, uint256 totalQuantity, bool isUSDT);
    event TradePurchased(uint256 indexed tradeId, uint256 indexed parentTradeId, address indexed buyer, uint256 totalAmount, uint256 quantity, address chosenLogisticsProvider, bool isUSDT);
    event LogisticsSelected(uint256 indexed tradeId, address logisticsProvider, uint256 logisticsCost);
    event PaymentHeld(uint256 indexed tradeId, uint256 totalAmount, bool isUSDT);
    event DeliveryConfirmed(uint256 indexed tradeId);
    event PaymentSettled(uint256 indexed tradeId, uint256 sellerAmount, uint256 logisticsAmount, bool isUSDT);
    event DisputeRaised(uint256 indexed tradeId, address initiator);
    event DisputeResolved(uint256 indexed tradeId, address winner, bool isUSDT);

    // Errors
    error InsufficientUSDTAllowance(uint256 needed, uint256 allowance);
    error InvalidTradeId(uint256 tradeId);
    error BuyerIsSeller();
    error InsufficientQuantity(uint256 requested, uint256 available);
    error InvalidQuantity(uint256 quantity);
    error InvalidLogisticsProvider(uint256 index);
    error MismatchedArrays(uint256 providersLength, uint256 costsLength);
    error NoLogisticsProviders();

    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier onlyTradeParticipant(uint256 tradeId) {
        Trade memory trade = trades[tradeId];
        bool isParticipant = msg.sender == trade.buyer || msg.sender == trade.seller;
        if (trade.logisticsSelected) {
            isParticipant = isParticipant || msg.sender == trade.chosenLogisticsProvider;
        }
        require(isParticipant, "Not a trade participant");
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
    function registerSeller() public {
        sellers[msg.sender] = true;
    }

    // Seller creates a trade with multiple goods and logistics options
    function createTrade(
    uint256 productCost,
    address[] memory logisticsProvidersList, // Renamed to avoid shadowing
    uint256[] memory logisticsCosts,
    bool useUSDT,
    uint256 totalQuantity
) external returns (uint256) {
    // Register the caller as a seller
    registerSeller();

    require(totalQuantity > 0, "Quantity must be greater than zero");
    require(logisticsProvidersList.length == logisticsCosts.length, "Mismatched providers and costs");
    require(logisticsProvidersList.length > 0, "At least one logistics provider required");

    // Validate logistics providers and costs
    bool logisticsSelected = false;
    for (uint256 i = 0; i < logisticsProvidersList.length; i++) {
        require(logisticsProvidersList[i] != address(0), "Invalid logistics provider");
        require(logisticsProviders[logisticsProvidersList[i]], "Unregistered logistics provider"); // Use state variable
        require(logisticsCosts[i] > 0, "Invalid logistics cost");
        logisticsSelected = true;
    }

    // Calculate escrow fee based on product cost only (logistics cost set by buyer)
    uint256 productEscrowFee = (productCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
    uint256 totalAmount = productCost;

    tradeCounter++;
    uint256 tradeId = tradeCounter;

    trades[tradeId] = Trade({
        buyer: address(0),
        seller: msg.sender,
        logisticsProviders: logisticsProvidersList, // Use renamed parameter
        logisticsCosts: logisticsCosts,
        chosenLogisticsProvider: address(0),
        productCost: productCost,
        logisticsCost: 0, // Set by buyer
        escrowFee: productEscrowFee,
        totalAmount: totalAmount,
        totalQuantity: totalQuantity,
        remainingQuantity: totalQuantity,
        logisticsSelected: logisticsSelected,
        delivered: false,
        completed: false,
        disputed: false,
        isUSDT: useUSDT,
        parentTradeId: 0
    });

    // Track trade ID for seller
    sellerTrades[msg.sender].push(tradeId);

    emit TradeCreated(tradeId, msg.sender, logisticsProvidersList, productCost, logisticsCosts, totalQuantity, useUSDT);
    if (logisticsSelected) {
        for (uint256 i = 0; i < logisticsProvidersList.length; i++) {
            emit LogisticsSelected(tradeId, logisticsProvidersList[i], logisticsCosts[i]);
        }
    }

    return tradeId;
}

    // Buyer purchases a trade with specified quantity and logistics provider
    function buyTrade(uint256 tradeId, uint256 quantity, uint256 logisticsProviderIndex) external payable returns (uint256) {
        Trade storage originalTrade = trades[tradeId];
        require(originalTrade.seller != address(0), "Invalid trade ID");
        require(originalTrade.remainingQuantity >= quantity, "Insufficient quantity available");
        require(quantity > 0, "Quantity must be greater than zero");
        require(msg.sender != originalTrade.seller, "Buyer cannot be the seller");
        require(msg.sender != admin, "Admin cannot be a buyer");
        require(logisticsProviderIndex < originalTrade.logisticsProviders.length, "Invalid logistics provider index");

        // Get chosen logistics provider and cost
        address chosenProvider = originalTrade.logisticsProviders[logisticsProviderIndex];
        uint256 chosenLogisticsCost = originalTrade.logisticsCosts[logisticsProviderIndex];

        // Calculate total cost
        uint256 totalProductCost = originalTrade.productCost * quantity;
        uint256 totalLogisticsCost = chosenLogisticsCost * quantity;
        uint256 productEscrowFee = originalTrade.escrowFee * quantity;
        uint256 logisticsEscrowFee = (chosenLogisticsCost * ESCROW_FEE_PERCENT * quantity) / BASIS_POINTS;
        uint256 totalEscrowFee = productEscrowFee + logisticsEscrowFee;
        uint256 totalAmount = totalProductCost + totalLogisticsCost;

        if (originalTrade.isUSDT) {
            require(msg.value == 0, "ETH sent for USDT payment");
            uint256 allowance = usdt.allowance(msg.sender, address(this));
            if (allowance < totalAmount) revert InsufficientUSDTAllowance(totalAmount, allowance);
            require(usdt.transferFrom(msg.sender, address(this), totalAmount), "USDT transfer failed");
        } else {
            require(msg.value == totalAmount, "Incorrect ETH amount");
        }

        // Create a new trade record for this purchase
        tradeCounter++;
        uint256 newTradeId = tradeCounter;

        trades[newTradeId] = Trade({
            buyer: msg.sender,
            seller: originalTrade.seller,
            logisticsProviders: originalTrade.logisticsProviders,
            logisticsCosts: originalTrade.logisticsCosts,
            chosenLogisticsProvider: chosenProvider,
            productCost: totalProductCost,
            logisticsCost: totalLogisticsCost,
            escrowFee: totalEscrowFee,
            totalAmount: totalAmount,
            totalQuantity: quantity,
            remainingQuantity: 0,
            logisticsSelected: true,
            delivered: false,
            completed: false,
            disputed: false,
            isUSDT: originalTrade.isUSDT,
            parentTradeId: tradeId
        });

        // Track trade ID for buyer
        buyerTrades[msg.sender].push(newTradeId);

        // Update remaining quantity
        originalTrade.remainingQuantity -= quantity;

        emit TradePurchased(newTradeId, tradeId, msg.sender, totalAmount, quantity, chosenProvider, originalTrade.isUSDT);
        emit PaymentHeld(newTradeId, totalAmount, originalTrade.isUSDT);
        emit LogisticsSelected(newTradeId, chosenProvider, totalLogisticsCost);

        return newTradeId;
    }

    // Get all trade details for the caller (buyer)
    function getTradesByBuyer() external view returns (Trade[] memory) {
        uint256[] memory tradeIds = buyerTrades[msg.sender];
        Trade[] memory buyerTradeDetails = new Trade[](tradeIds.length);

        for (uint256 i = 0; i < tradeIds.length; i++) {
            buyerTradeDetails[i] = trades[tradeIds[i]];
        }

        return buyerTradeDetails;
    }

    // Get all trade details for the caller (seller)
    function getTradesBySeller() external view returns (Trade[] memory) {
        uint256[] memory tradeIds = sellerTrades[msg.sender];
        Trade[] memory sellerTradeDetails = new Trade[](tradeIds.length);

        for (uint256 i = 0; i < tradeIds.length; i++) {
            sellerTradeDetails[i] = trades[tradeIds[i]];
        }

        return sellerTradeDetails;
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

        // Seller receives product cost minus 2.5% escrow fee
        uint256 productEscrowFee = (trade.productCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
        uint256 sellerAmount = trade.productCost - productEscrowFee;
        if (trade.isUSDT) {
            require(usdt.transfer(trade.seller, sellerAmount), "USDT transfer to seller failed");
        } else {
            payable(trade.seller).transfer(sellerAmount);
        }

        // Logistics provider receives logistics cost minus 2.5% escrow fee
        uint256 logisticsAmount = 0;
        if (trade.logisticsSelected) {
            uint256 logisticsEscrowFee = (trade.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
            logisticsAmount = trade.logisticsCost - logisticsEscrowFee;
            if (trade.isUSDT) {
                require(usdt.transfer(trade.chosenLogisticsProvider, logisticsAmount), "USDT transfer to logistics failed");
            } else {
                payable(trade.chosenLogisticsProvider).transfer(logisticsAmount);
            }
        }

        // Escrow fee remains in contract
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
            winner == trade.buyer || winner == trade.seller || winner == trade.chosenLogisticsProvider,
            "Invalid winner"
        );

        disputesResolved[tradeId] = true;
        trade.completed = true;

        // Refund or distribute funds
        if (winner == trade.buyer) {
            // Refund full amount
            if (trade.isUSDT) {
                require(usdt.transfer(trade.buyer, trade.totalAmount), "USDT refund failed");
            } else {
                payable(trade.buyer).transfer(trade.totalAmount);
            }
        } else {
            // Seller gets product cost minus 2.5% escrow fee
            uint256 productEscrowFee = (trade.productCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
            uint256 sellerAmount = trade.productCost - productEscrowFee;
            if (trade.isUSDT) {
                require(usdt.transfer(trade.seller, sellerAmount), "USDT transfer to seller failed");
            } else {
                payable(trade.seller).transfer(sellerAmount);
            }
            // Logistics provider gets logistics cost minus 2.5% escrow fee
            if (trade.logisticsSelected) {
                uint256 logisticsEscrowFee = (trade.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
                uint256 logisticsPayout = trade.logisticsCost - logisticsEscrowFee;
                if (trade.isUSDT) {
                    require(usdt.transfer(trade.chosenLogisticsProvider, logisticsPayout), "USDT transfer to logistics failed");
                } else {
                    payable(trade.chosenLogisticsProvider).transfer(logisticsPayout);
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
        // Refund full amount
        if (trade.isUSDT) {
            require(usdt.transfer(trade.buyer, trade.totalAmount), "USDT refund failed");
        } else {
            payable(trade.buyer).transfer(trade.totalAmount);
        }
    }
}