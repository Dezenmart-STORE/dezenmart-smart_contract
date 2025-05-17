// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract DezenMartLogistics is Ownable {
    // Constants
    uint256 public constant ESCROW_FEE_PERCENT = 250; // 2.5% (in basis points, 10000 = 100%)
    uint256 public constant BASIS_POINTS = 10000;

    // Roles
    IERC20 public immutable usdt;
    mapping(address => bool) public logisticsProviders;
    mapping(address => bool) public sellers;
    mapping(address => bool) public buyers; // Track registered buyers
    address[] public registeredProviders;

    // Purchase structure for individual buyer purchases
    struct Purchase {
        uint256 purchaseId;
        uint256 tradeId;
        address buyer;
        uint256 quantity;
        uint256 totalAmount;
        bool delivered;
        bool confirmed;
        bool disputed;
        address chosenLogisticsProvider;
        uint256 logisticsCost;
    }

    // Trade structure
    struct Trade {
        address seller;
        address[] logisticsProviders;
        uint256[] logisticsCosts;
        uint256 productCost;
        uint256 escrowFee;
        uint256 totalQuantity;
        uint256 remainingQuantity;
        bool active;
        uint256[] purchaseIds; // Array of associated purchase IDs
    }

    // State variables
    mapping(uint256 => Trade) public trades;
    mapping(uint256 => Purchase) public purchases;
    uint256 public tradeCounter;
    uint256 public purchaseCounter;
    mapping(uint256 => bool) public disputesResolved;
    mapping(address => uint256[]) public buyerPurchaseIds; // Buyer's purchase IDs
    mapping(address => uint256[]) public sellerTradeIds; // Seller's trade IDs
    mapping(address => uint256[]) public providerTradeIds; // Logistics provider's trade IDs

    // Events
    event TradeCreated(uint256 indexed tradeId, address indexed seller, uint256 productCost, uint256 totalQuantity);
    event PurchaseCreated(uint256 indexed purchaseId, uint256 indexed tradeId, address indexed buyer, uint256 quantity);
    event LogisticsSelected(uint256 indexed purchaseId, address logisticsProvider, uint256 logisticsCost);
    event PaymentHeld(uint256 indexed purchaseId, uint256 totalAmount);
    event DeliveryConfirmed(uint256 indexed purchaseId);
    event PurchaseConfirmed(uint256 indexed purchaseId);
    event PaymentSettled(uint256 indexed purchaseId, uint256 sellerAmount, uint256 logisticsAmount);
    event DisputeRaised(uint256 indexed purchaseId, address initiator);
    event DisputeResolved(uint256 indexed purchaseId, address winner);
    event LogisticsProviderRegistered(address indexed provider);
    event TradeStatusUpdated(uint256 indexed tradeId, string status);

    // Errors
    error InsufficientUSDTAllowance(uint256 needed, uint256 allowance);
    error InsufficientUSDTBalance(uint256 needed, uint256 balance);
    error InvalidTradeId(uint256 tradeId);
    error InvalidPurchaseId(uint256 purchaseId);
    error BuyerIsSeller();
    error InsufficientQuantity(uint256 requested, uint256 available);
    error InvalidQuantity(uint256 quantity);
    error InvalidLogisticsProvider(address provider);
    error MismatchedArrays(uint256 providersLength, uint256 costsLength);
    error NoLogisticsProviders();
    error TradeNotFound(uint256 tradeId);
    error PurchaseNotFound(uint256 purchaseId);
    error NotAuthorized(address caller, string role);
    error InvalidTradeState(uint256 tradeId, string expectedState);
    error InvalidPurchaseState(uint256 purchaseId, string expectedState);

    // Modifier for purchase participants
    modifier onlyPurchaseParticipant(uint256 purchaseId) {
        Purchase memory purchase = purchases[purchaseId];
        Trade memory trade = trades[purchase.tradeId];
        bool isParticipant = msg.sender == purchase.buyer || msg.sender == trade.seller;
        isParticipant = isParticipant || msg.sender == purchase.chosenLogisticsProvider;
        require(isParticipant, "Not a purchase participant");
        _;
    }

    constructor(address _usdtAddress) Ownable(msg.sender) {
        require(_usdtAddress != address(0), "Invalid USDT address");
        usdt = IERC20(_usdtAddress);
    }

    // Register logistics provider
    function registerLogisticsProvider(address provider) external  {
        require(provider != address(0), "Invalid provider address");
        require(!logisticsProviders[provider], "Provider already registered");
        logisticsProviders[provider] = true;
        registeredProviders.push(provider);
        emit LogisticsProviderRegistered(provider);
    }

    // Get all registered logistics providers
    function getLogisticsProviders() external view returns (address[] memory) {
        return registeredProviders;
    }

    // Register buyer
    function registerBuyer() public {
        buyers[msg.sender] = true;
    }

    // Register seller
    function registerSeller() public {
        sellers[msg.sender] = true;
    }

    // Seller creates a trade
    function createTrade(
        uint256 productCost,
        address[] memory logisticsProvidersList,
        uint256[] memory logisticsCosts,
        uint256 totalQuantity
    ) external returns (uint256) {
        registerSeller();
        if (totalQuantity == 0) revert InvalidQuantity(totalQuantity);
        if (logisticsProvidersList.length != logisticsCosts.length) revert MismatchedArrays(logisticsProvidersList.length, logisticsCosts.length);
        if (logisticsProvidersList.length == 0) revert NoLogisticsProviders();

        for (uint256 i = 0; i < logisticsProvidersList.length; i++) {
            if (logisticsProvidersList[i] == address(0) || !logisticsProviders[logisticsProvidersList[i]]) 
                revert InvalidLogisticsProvider(logisticsProvidersList[i]);
            if (logisticsCosts[i] == 0) revert InvalidQuantity(logisticsCosts[i]);
        }

        uint256 productEscrowFee = (productCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;

        tradeCounter++;
        uint256 tradeId = tradeCounter;

        trades[tradeId] = Trade({
            seller: msg.sender,
            logisticsProviders: logisticsProvidersList,
            logisticsCosts: logisticsCosts,
            productCost: productCost,
            escrowFee: productEscrowFee,
            totalQuantity: totalQuantity,
            remainingQuantity: totalQuantity,
            active: true,
            purchaseIds: new uint256[](0)
        });

        sellerTradeIds[msg.sender].push(tradeId);
        emit TradeCreated(tradeId, msg.sender, productCost, totalQuantity);
        return tradeId;
    }

    // Buyer purchases a trade
    function buyTrade(uint256 tradeId, uint256 quantity, address logisticsProvider) external returns (uint256) {
        registerBuyer();
        Trade storage trade = trades[tradeId];
        if (!trade.active) revert InvalidTradeId(tradeId);
        if (trade.remainingQuantity < quantity) revert InsufficientQuantity(quantity, trade.remainingQuantity);
        if (quantity == 0) revert InvalidQuantity(quantity);
        if (msg.sender == trade.seller) revert BuyerIsSeller();
        if (msg.sender == owner()) revert NotAuthorized(msg.sender, "admin as buyer");

        // Validate logistics provider and get cost
        uint256 chosenLogisticsCost = _findLogisticsCost(trade, logisticsProvider);

        // Calculate costs (only return needed values)
        (uint256 totalLogisticsCost, uint256 totalAmount) = _calculateTradeCosts(trade, quantity, chosenLogisticsCost);

        // Validate and transfer USDT
        _validateAndTransferUSDT(totalAmount);

        // Create new purchase
        purchaseCounter++;
        uint256 purchaseId = purchaseCounter;

        purchases[purchaseId] = Purchase({
            purchaseId: purchaseId,
            tradeId: tradeId,
            buyer: msg.sender,
            quantity: quantity,
            totalAmount: totalAmount,
            delivered: false,
            confirmed: false,
            disputed: false,
            chosenLogisticsProvider: logisticsProvider,
            logisticsCost: totalLogisticsCost
        });

        // Update state
        trade.purchaseIds.push(purchaseId);
        trade.remainingQuantity -= quantity;
        buyerPurchaseIds[msg.sender].push(purchaseId);
        providerTradeIds[logisticsProvider].push(purchaseId);

        // Emit events
        emit PurchaseCreated(purchaseId, tradeId, msg.sender, quantity);
        emit PaymentHeld(purchaseId, totalAmount);
        emit LogisticsSelected(purchaseId, logisticsProvider, totalLogisticsCost);

        return purchaseId;
    }

    // Helper function to find logistics cost
    function _findLogisticsCost(Trade storage trade, address logisticsProvider) 
        internal view returns (uint256) {
        for (uint256 i = 0; i < trade.logisticsProviders.length; i++) {
            if (trade.logisticsProviders[i] == logisticsProvider) {
                return trade.logisticsCosts[i];
            }
        }
        revert InvalidLogisticsProvider(logisticsProvider);
    }

    // Helper function to calculate trade costs (modified to return only needed values)
    function _calculateTradeCosts(Trade storage trade, uint256 quantity, uint256 chosenLogisticsCost)
        internal view returns (uint256 totalLogisticsCost, uint256 totalAmount) {
        uint256 totalProductCost = trade.productCost * quantity;
        totalLogisticsCost = chosenLogisticsCost * quantity;
        totalAmount = totalProductCost + totalLogisticsCost;
    }

    // Helper function to validate and transfer USDT
    function _validateAndTransferUSDT(uint256 totalAmount) internal {
        uint256 allowance = usdt.allowance(msg.sender, address(this));
        if (allowance < totalAmount) revert InsufficientUSDTAllowance(totalAmount, allowance);

        uint256 balance = usdt.balanceOf(msg.sender);
        if (balance < totalAmount) revert InsufficientUSDTBalance(totalAmount, balance);

        require(usdt.transferFrom(msg.sender, address(this), totalAmount), "USDT transfer failed");
    }

    // Get purchase details
    function getPurchase(uint256 purchaseId) external view returns (Purchase memory) {
        if (purchases[purchaseId].tradeId == 0) revert PurchaseNotFound(purchaseId);
        return purchases[purchaseId];
    }

    // Get trade details
    function getTrade(uint256 tradeId) external view returns (Trade memory) {
        if (trades[tradeId].seller == address(0)) revert TradeNotFound(tradeId);
        return trades[tradeId];
    }

    // Get buyer's purchases
    function getBuyerPurchases() external view returns (Purchase[] memory) {
        uint256[] memory purchaseIds = buyerPurchaseIds[msg.sender];
        Purchase[] memory buyerPurchases = new Purchase[](purchaseIds.length);
        for (uint256 i = 0; i < purchaseIds.length; i++) {
            buyerPurchases[i] = purchases[purchaseIds[i]];
        }
        return buyerPurchases;
    }

    // Get seller's trades
    function getSellerTrades() external view returns (Trade[] memory) {
        uint256[] memory tradeIds = sellerTradeIds[msg.sender];
        Trade[] memory sellerTrades = new Trade[](tradeIds.length);
        for (uint256 i = 0; i < tradeIds.length; i++) {
            sellerTrades[i] = trades[tradeIds[i]];
        }
        return sellerTrades;
    }

    // Get provider's trades
    function getProviderTrades() external view returns (Purchase[] memory) {
        uint256[] memory purchaseIds = providerTradeIds[msg.sender];
        Purchase[] memory providerTrades = new Purchase[](purchaseIds.length);
        for (uint256 i = 0; i < purchaseIds.length; i++) {
            providerTrades[i] = purchases[purchaseIds[i]];
        }
        return providerTrades;
    }

    // Confirm delivery
    function confirmDelivery(uint256 purchaseId) external {
        Purchase storage purchase = purchases[purchaseId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (msg.sender != purchase.buyer) revert NotAuthorized(msg.sender, "buyer");
        if (purchase.delivered) revert InvalidPurchaseState(purchaseId, "not delivered");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "not disputed");
        if (purchase.confirmed) revert InvalidPurchaseState(purchaseId, "not confirmed");

        purchase.delivered = true;
        emit DeliveryConfirmed(purchaseId);
    }

    // Confirm purchase (after delivery)
    function confirmPurchase(uint256 purchaseId) external {
        Purchase storage purchase = purchases[purchaseId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (msg.sender != purchase.buyer) revert NotAuthorized(msg.sender, "buyer");
        if (!purchase.delivered) revert InvalidPurchaseState(purchaseId, "delivered");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "not disputed");
        if (purchase.confirmed) revert InvalidPurchaseState(purchaseId, "not confirmed");

        purchase.confirmed = true;
        emit PurchaseConfirmed(purchaseId);
        _settlePayments(purchaseId);
    }

    // Settle payments
    function _settlePayments(uint256 purchaseId) internal {
        Purchase storage purchase = purchases[purchaseId];
        Trade storage trade = trades[purchase.tradeId];
        
        if (!purchase.confirmed) revert InvalidPurchaseState(purchaseId, "confirmed");

        uint256 productEscrowFee = (trade.productCost * ESCROW_FEE_PERCENT * purchase.quantity) / BASIS_POINTS;
        uint256 sellerAmount = (trade.productCost * purchase.quantity) - productEscrowFee;
        require(usdt.transfer(trade.seller, sellerAmount), "USDT transfer to seller failed");

        uint256 logisticsAmount = 0;
        if (purchase.chosenLogisticsProvider != address(0)) {
            uint256 logisticsEscrowFee = (purchase.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
            logisticsAmount = purchase.logisticsCost - logisticsEscrowFee;
            require(usdt.transfer(purchase.chosenLogisticsProvider, logisticsAmount), "USDT transfer to logistics failed");
        }

        emit PaymentSettled(purchaseId, sellerAmount, logisticsAmount);
    }

    // Raise dispute
    function raiseDispute(uint256 purchaseId) external onlyPurchaseParticipant(purchaseId) {
        Purchase storage purchase = purchases[purchaseId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (purchase.confirmed) revert InvalidPurchaseState(purchaseId, "not confirmed");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "not disputed");

        purchase.disputed = true;
        emit DisputeRaised(purchaseId, msg.sender);
    }

    // Resolve dispute
    function resolveDispute(uint256 purchaseId, address winner) external onlyOwner {
        Purchase storage purchase = purchases[purchaseId];
        Trade storage trade = trades[purchase.tradeId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (!purchase.disputed) revert InvalidPurchaseState(purchaseId, "disputed");
        if (disputesResolved[purchaseId]) revert InvalidPurchaseState(purchaseId, "not resolved");

        bool validWinner = winner == purchase.buyer || winner == trade.seller || winner == purchase.chosenLogisticsProvider;
        if (!validWinner) revert NotAuthorized(winner, "trade participant");

        disputesResolved[purchaseId] = true;
        purchase.confirmed = true;

        if (winner == purchase.buyer) {
            require(usdt.transfer(purchase.buyer, purchase.totalAmount), "USDT refund failed");
        } else {
            uint256 productEscrowFee = (trade.productCost * ESCROW_FEE_PERCENT * purchase.quantity) / BASIS_POINTS;
            uint256 sellerAmount = (trade.productCost * purchase.quantity) - productEscrowFee;
            require(usdt.transfer(trade.seller, sellerAmount), "USDT transfer to seller failed");

            if (purchase.chosenLogisticsProvider != address(0)) {
                uint256 logisticsEscrowFee = (purchase.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
                uint256 logisticsPayout = purchase.logisticsCost - logisticsEscrowFee;
                require(usdt.transfer(purchase.chosenLogisticsProvider, logisticsPayout), "USDT transfer to logistics failed");
            }
        }

        emit DisputeResolved(purchaseId, winner);
    }

    // Cancel purchase
    function cancelPurchase(uint256 purchaseId) external {
        Purchase storage purchase = purchases[purchaseId];
        Trade storage trade = trades[purchase.tradeId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (msg.sender != purchase.buyer) revert NotAuthorized(msg.sender, "buyer");
        if (purchase.delivered) revert InvalidPurchaseState(purchaseId, "not delivered");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "not disputed");
        if (purchase.confirmed) revert InvalidPurchaseState(purchaseId, "not confirmed");

        purchase.confirmed = true;
        trade.remainingQuantity += purchase.quantity;
        require(usdt.transfer(purchase.buyer, purchase.totalAmount), "USDT refund failed");
    }

    // Admin withdraw escrow fees
    function withdrawEscrowFees() external onlyOwner {
        uint256 balance = usdt.balanceOf(address(this));
        if (balance == 0) revert("No USDT fees to withdraw");
        require(usdt.transfer(owner(), balance), "USDT withdrawal failed");
    }
}