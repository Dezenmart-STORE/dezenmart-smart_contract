// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DezenMartLogistics is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;
    
    // Constants
    uint256 public constant ESCROW_FEE_PERCENT = 250; // 2.5% (in basis points, 10000 = 100%)
    uint256 public constant BASIS_POINTS = 10000;

    // Roles
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
        bool deliveredAndConfirmed; // Combined delivery and confirmation status
        bool disputed;
        address chosenLogisticsProvider;
        uint256 logisticsCost;
        bool settled; // Track if payments have been settled
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
        address tokenAddress; // Token address for payment
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
    event TradeCreated(uint256 indexed tradeId, address indexed seller, uint256 productCost, uint256 totalQuantity, address tokenAddress);
    event PurchaseCreated(uint256 indexed purchaseId, uint256 indexed tradeId, address indexed buyer, uint256 quantity);
    event LogisticsSelected(uint256 indexed purchaseId, address logisticsProvider, uint256 logisticsCost);
    event PaymentHeld(uint256 indexed purchaseId, uint256 totalAmount);
    event PurchaseCompletedAndConfirmed(uint256 indexed purchaseId); // Combined event
    event PaymentSettled(uint256 indexed purchaseId, uint256 sellerAmount, uint256 logisticsAmount);
    event DisputeRaised(uint256 indexed purchaseId, address initiator);
    event DisputeResolved(uint256 indexed purchaseId, address winner);
    event LogisticsProviderRegistered(address indexed provider);
    event TradeStatusUpdated(uint256 indexed tradeId, string status);
    event TradeDeactivated(uint256 indexed tradeId);

    // Errors
    error InsufficientTokenAllowance(uint256 needed, uint256 allowance);
    error InsufficientTokenBalance(uint256 needed, uint256 balance);
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
    error AlreadySettled(uint256 purchaseId);
    error InvalidTokenAddress(address tokenAddress);
    error InvalidSellerAddress(address seller);

    // Modifier for purchase participants
    modifier onlyPurchaseParticipant(uint256 purchaseId) {
        Purchase memory purchase = purchases[purchaseId];
        Trade memory trade = trades[purchase.tradeId];
        bool isParticipant = msg.sender == purchase.buyer || msg.sender == trade.seller;
        isParticipant = isParticipant || msg.sender == purchase.chosenLogisticsProvider;
        require(isParticipant, "Not a purchase participant");
        _;
    }

    constructor() Ownable(msg.sender) {}

    // Register logistics provider
    function registerLogisticsProvider(address provider) external {
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
    function registerSeller(address seller) external onlyOwner {
        require(seller != address(0), "Invalid seller address");
        sellers[seller] = true;
    }

    // Owner creates a trade with specified seller
    function createTrade(
        address seller,
        uint256 productCost,
        address[] memory logisticsProvidersList,
        uint256[] memory logisticsCosts,
        uint256 totalQuantity,
        address tokenAddress
    ) external onlyOwner returns (uint256) {
        if (seller == address(0)) revert InvalidSellerAddress(seller);
        if (totalQuantity == 0) revert InvalidQuantity(totalQuantity);
        if (logisticsProvidersList.length != logisticsCosts.length) revert MismatchedArrays(logisticsProvidersList.length, logisticsCosts.length);
        if (logisticsProvidersList.length == 0) revert NoLogisticsProviders();
        if (tokenAddress == address(0)) revert InvalidTokenAddress(tokenAddress);

        // Register seller if not already registered
        if (!sellers[seller]) {
            sellers[seller] = true;
        }

        for (uint256 i = 0; i < logisticsProvidersList.length; i++) {
            if (logisticsProvidersList[i] == address(0) || !logisticsProviders[logisticsProvidersList[i]]) 
                revert InvalidLogisticsProvider(logisticsProvidersList[i]);
            if (logisticsCosts[i] == 0) revert InvalidQuantity(logisticsCosts[i]);
        }

        uint256 productEscrowFee = (productCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;

        tradeCounter++;
        uint256 tradeId = tradeCounter;

        trades[tradeId] = Trade({
            seller: seller,
            logisticsProviders: logisticsProvidersList,
            logisticsCosts: logisticsCosts,
            productCost: productCost,
            escrowFee: productEscrowFee,
            totalQuantity: totalQuantity,
            remainingQuantity: totalQuantity,
            active: true,
            purchaseIds: new uint256[](0),
            tokenAddress: tokenAddress
        });

        sellerTradeIds[seller].push(tradeId);
        emit TradeCreated(tradeId, seller, productCost, totalQuantity, tokenAddress);
        return tradeId;
    }

    // Buyer purchases a trade
    function buyTrade(uint256 tradeId, uint256 quantity, address logisticsProvider) external nonReentrant returns (uint256) {
        registerBuyer();
        Trade storage trade = trades[tradeId];
        if (!trade.active) revert InvalidTradeId(tradeId);
        if (trade.remainingQuantity < quantity) revert InsufficientQuantity(quantity, trade.remainingQuantity);
        if (quantity == 0) revert InvalidQuantity(quantity);
        if (msg.sender == trade.seller) revert BuyerIsSeller();
        if (msg.sender == owner()) revert NotAuthorized(msg.sender, "admin as buyer");

        // Validate logistics provider and get cost
        uint256 chosenLogisticsCost = _findLogisticsCost(trade, logisticsProvider);

        // Calculate costs
        (uint256 totalLogisticsCost, uint256 totalAmount) = _calculateTradeCosts(trade, quantity, chosenLogisticsCost);

        // Validate and transfer token
        _validateAndTransferToken(trade.tokenAddress, totalAmount);

        // Update state first (checks-effects-interactions pattern)
        purchaseCounter++;
        uint256 purchaseId = purchaseCounter;

        purchases[purchaseId] = Purchase({
            purchaseId: purchaseId,
            tradeId: tradeId,
            buyer: msg.sender,
            quantity: quantity,
            totalAmount: totalAmount,
            deliveredAndConfirmed: false, // Combined status
            disputed: false,
            chosenLogisticsProvider: logisticsProvider,
            logisticsCost: totalLogisticsCost,
            settled: false
        });

        // Update trade state
        trade.purchaseIds.push(purchaseId);
        trade.remainingQuantity -= quantity;
        
        // Check if trade should be deactivated
        if (trade.remainingQuantity == 0) {
            trade.active = false;
            emit TradeDeactivated(tradeId);
        }
        
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

    // Helper function to calculate trade costs
    function _calculateTradeCosts(Trade storage trade, uint256 quantity, uint256 chosenLogisticsCost)
        internal view returns (uint256 totalLogisticsCost, uint256 totalAmount) {
        uint256 totalProductCost = trade.productCost * quantity;
        totalLogisticsCost = chosenLogisticsCost * quantity;
        totalAmount = totalProductCost + totalLogisticsCost;
    }

    // Helper function to validate and transfer token
    function _validateAndTransferToken(address tokenAddress, uint256 totalAmount) internal {
        IERC20 token = IERC20(tokenAddress);
        uint256 allowance = token.allowance(msg.sender, address(this));
        if (allowance < totalAmount) revert InsufficientTokenAllowance(totalAmount, allowance);

        uint256 balance = token.balanceOf(msg.sender);
        if (balance < totalAmount) revert InsufficientTokenBalance(totalAmount, balance);

        token.safeTransferFrom(msg.sender, address(this), totalAmount);
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

    // Combined confirm delivery and purchase (replaces both previous functions)
    function confirmDeliveryAndPurchase(uint256 purchaseId) external nonReentrant {
        Purchase storage purchase = purchases[purchaseId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (msg.sender != purchase.buyer) revert NotAuthorized(msg.sender, "buyer");
        if (purchase.deliveredAndConfirmed) revert InvalidPurchaseState(purchaseId, "already confirmed");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "disputed");
        if (purchase.settled) revert AlreadySettled(purchaseId);

        // Update confirmed state
        purchase.deliveredAndConfirmed = true;
        
        // Settle payments
        _settlePayments(purchaseId);
        
        // Update settled state after successful payment
        purchase.settled = true;
        
        emit PurchaseCompletedAndConfirmed(purchaseId);
    }

    // Settle payments
    function _settlePayments(uint256 purchaseId) internal {
        Purchase storage purchase = purchases[purchaseId];
        Trade storage trade = trades[purchase.tradeId];
        
        IERC20 token = IERC20(trade.tokenAddress);
        uint256 productEscrowFee = (trade.productCost * ESCROW_FEE_PERCENT * purchase.quantity) / BASIS_POINTS;
        uint256 sellerAmount = (trade.productCost * purchase.quantity) - productEscrowFee;
        
        // Use SafeERC20 for secure transfers
        token.safeTransfer(trade.seller, sellerAmount);

        uint256 logisticsAmount = 0;
        if (purchase.chosenLogisticsProvider != address(0)) {
            uint256 logisticsEscrowFee = (purchase.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
            logisticsAmount = purchase.logisticsCost - logisticsEscrowFee;
            token.safeTransfer(purchase.chosenLogisticsProvider, logisticsAmount);
        }

        emit PaymentSettled(purchaseId, sellerAmount, logisticsAmount);
    }

    // Raise dispute
    function raiseDispute(uint256 purchaseId) external onlyPurchaseParticipant(purchaseId) {
        Purchase storage purchase = purchases[purchaseId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (purchase.deliveredAndConfirmed) revert InvalidPurchaseState(purchaseId, "already confirmed");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "already disputed");

        purchase.disputed = true;
        emit DisputeRaised(purchaseId, msg.sender);
    }

    // Resolve dispute
    function resolveDispute(uint256 purchaseId, address winner) external onlyOwner nonReentrant {
        Purchase storage purchase = purchases[purchaseId];
        Trade storage trade = trades[purchase.tradeId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (!purchase.disputed) revert InvalidPurchaseState(purchaseId, "not disputed");
        if (disputesResolved[purchaseId]) revert InvalidPurchaseState(purchaseId, "already resolved");
        if (purchase.settled) revert AlreadySettled(purchaseId);

        bool validWinner = winner == purchase.buyer || winner == trade.seller || winner == purchase.chosenLogisticsProvider;
        if (!validWinner) revert NotAuthorized(winner, "trade participant");

        // Update state before external calls
        disputesResolved[purchaseId] = true;
        purchase.deliveredAndConfirmed = true;
        purchase.settled = true;

        IERC20 token = IERC20(trade.tokenAddress);
        if (winner == purchase.buyer) {
            // Refund buyer
            token.safeTransfer(purchase.buyer, purchase.totalAmount);
            // Restore quantity to trade since buyer gets refund
            trade.remainingQuantity += purchase.quantity;
            if (!trade.active && trade.remainingQuantity > 0) {
                trade.active = true;
            }
        } else {
            // Pay seller and logistics provider
            uint256 productEscrowFee = (trade.productCost * ESCROW_FEE_PERCENT * purchase.quantity) / BASIS_POINTS;
            uint256 sellerAmount = (trade.productCost * purchase.quantity) - productEscrowFee;
            token.safeTransfer(trade.seller, sellerAmount);

            if (purchase.chosenLogisticsProvider != address(0)) {
                uint256 logisticsEscrowFee = (purchase.logisticsCost * ESCROW_FEE_PERCENT) / BASIS_POINTS;
                uint256 logisticsPayout = purchase.logisticsCost - logisticsEscrowFee;
                token.safeTransfer(purchase.chosenLogisticsProvider, logisticsPayout);
            }
        }

        emit DisputeResolved(purchaseId, winner);
    }

    // Cancel purchase
    function cancelPurchase(uint256 purchaseId) external nonReentrant {
        Purchase storage purchase = purchases[purchaseId];
        Trade storage trade = trades[purchase.tradeId];
        if (purchase.tradeId == 0) revert PurchaseNotFound(purchaseId);
        if (msg.sender != purchase.buyer) revert NotAuthorized(msg.sender, "buyer");
        if (purchase.deliveredAndConfirmed) revert InvalidPurchaseState(purchaseId, "already confirmed");
        if (purchase.disputed) revert InvalidPurchaseState(purchaseId, "disputed");
        if (purchase.settled) revert AlreadySettled(purchaseId);

        // Update state before external calls
        purchase.deliveredAndConfirmed = true;
        purchase.settled = true;
        trade.remainingQuantity += purchase.quantity;
        
        // Reactivate trade if it was deactivated
        if (!trade.active && trade.remainingQuantity > 0) {
            trade.active = true;
        }
        
        IERC20 token = IERC20(trade.tokenAddress);
        token.safeTransfer(purchase.buyer, purchase.totalAmount);
    }

    // Admin withdraw escrow fees
    function withdrawEscrowFees(address tokenAddress) external onlyOwner nonReentrant {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No token fees to withdraw");
        token.safeTransfer(owner(), balance);
    }
}
