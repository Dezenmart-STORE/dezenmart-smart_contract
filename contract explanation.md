# ABI AND CONTRACT ADDRESSES
## Logistic [0xD2570DD7bdf47B381d11859efB739595f583CAaB]
[{"inputs":[{"internalType":"address","name":"_usdtAddress","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"uint256","name":"needed","type":"uint256"},{"internalType":"uint256","name":"allowance","type":"uint256"}],"name":"InsufficientUSDTAllowance","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"DeliveryConfirmed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"address","name":"initiator","type":"address"}],"name":"DisputeRaised","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"address","name":"winner","type":"address"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"DisputeResolved","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"address","name":"logisticsProvider","type":"address"},{"indexed":false,"internalType":"uint256","name":"logisticsCost","type":"uint256"}],"name":"LogisticsSelected","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"totalAmount","type":"uint256"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"PaymentHeld","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"sellerAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"logisticsAmount","type":"uint256"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"PaymentSettled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":true,"internalType":"address","name":"buyer","type":"address"},{"indexed":false,"internalType":"address","name":"seller","type":"address"},{"indexed":false,"internalType":"address","name":"logisticsProvider","type":"address"},{"indexed":false,"internalType":"uint256","name":"totalAmount","type":"uint256"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"TradeCreated","type":"event"},{"inputs":[],"name":"BASIS_POINTS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ESCROW_FEE_PERCENT","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"admin","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"buyerTrades","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"cancelTrade","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"confirmDelivery","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"seller","type":"address"},{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"address","name":"logisticsProvider","type":"address"},{"internalType":"uint256","name":"logisticsCost","type":"uint256"},{"internalType":"bool","name":"useUSDT","type":"bool"}],"name":"createTrade","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"disputesResolved","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTradesByBuyer","outputs":[{"components":[{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"address","name":"logisticsProvider","type":"address"},{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"uint256","name":"logisticsCost","type":"uint256"},{"internalType":"uint256","name":"escrowFee","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"},{"internalType":"bool","name":"logisticsSelected","type":"bool"},{"internalType":"bool","name":"delivered","type":"bool"},{"internalType":"bool","name":"completed","type":"bool"},{"internalType":"bool","name":"disputed","type":"bool"},{"internalType":"bool","name":"isUSDT","type":"bool"}],"internalType":"struct DezenMartLogistics.Trade[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"logisticsProviders","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"raiseDispute","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"provider","type":"address"}],"name":"registerLogisticsProvider","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"registerSeller","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"},{"internalType":"address","name":"winner","type":"address"}],"name":"resolveDispute","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"sellers","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"tradeCounter","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"trades","outputs":[{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"address","name":"logisticsProvider","type":"address"},{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"uint256","name":"logisticsCost","type":"uint256"},{"internalType":"uint256","name":"escrowFee","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"},{"internalType":"bool","name":"logisticsSelected","type":"bool"},{"internalType":"bool","name":"delivered","type":"bool"},{"internalType":"bool","name":"completed","type":"bool"},{"internalType":"bool","name":"disputed","type":"bool"},{"internalType":"bool","name":"isUSDT","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"usdt","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"withdrawEscrowFeesETH","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdrawEscrowFeesUSDT","outputs":[],"stateMutability":"nonpayable","type":"function"}]


## USDT [0x9b4eB82CB4A5617B7fdb92CD066c5CA5eD699C55]
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"allowance","type":"uint256"},{"internalType":"uint256","name":"needed","type":"uint256"}],"name":"ERC20InsufficientAllowance","type":"error"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"uint256","name":"balance","type":"uint256"},{"internalType":"uint256","name":"needed","type":"uint256"}],"name":"ERC20InsufficientBalance","type":"error"},{"inputs":[{"internalType":"address","name":"approver","type":"address"}],"name":"ERC20InvalidApprover","type":"error"},{"inputs":[{"internalType":"address","name":"receiver","type":"address"}],"name":"ERC20InvalidReceiver","type":"error"},{"inputs":[{"internalType":"address","name":"sender","type":"address"}],"name":"ERC20InvalidSender","type":"error"},{"inputs":[{"internalType":"address","name":"spender","type":"address"}],"name":"ERC20InvalidSpender","type":"error"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"OwnableInvalidOwner","type":"error"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"OwnableUnauthorizedAccount","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]




# DezenMartLogistics Smart Contract Documentation

## Overview
The `DezenMartLogistics` smart contract facilitates e-commerce trades with escrow, supporting payments in **ETH** or **USDT**. It manages trades between buyers, sellers, and optional logistics providers, deducting a **2.5% escrow fee** from both product and logistics costs upon settlement. The contract integrates with a USDT ERC20 token contract for USDT payments, requiring proper balance and allowance management.

This documentation covers:
- Contract purpose and architecture.
- Key functions, events, and state variables.
- Integration guidance for backend and frontend developers.
- USDT contract interactions for balance checking and approvals.
- Example workflows and code snippets.

---

## Contract Details

### Purpose
`DezenMartLogistics` enables secure, trustless trades by:
- Holding funds (ETH or USDT) in escrow until delivery or dispute resolution.
- Supporting trades with or without logistics providers.
- Deducting a 2.5% escrow fee from `productCost` and `logisticsCost`, retained by the admin.
- Allowing buyers to confirm delivery, cancel trades, or raise disputes.
- Enabling admin to resolve disputes and withdraw fees.

### USDT Integration
The contract uses a standard ERC20 USDT contract for USDT payments, requiring:
- Buyers to approve the contract to spend USDT.
- Balance and allowance checks before trade creation.

### Key Features
- **Trade Creation**: Buyers initiate trades, locking funds in escrow.
- **Delivery Confirmation**: Buyers confirm delivery, triggering payments (minus fees).
- **Dispute Resolution**: Participants can raise disputes; admin resolves them.
- **Trade Querying**: Buyers can retrieve all trade details.
- **Fee Management**: Admin withdraws accumulated escrow fees in ETH or USDT.

### Contract Address
- Deployed at: `[Insert deployed address]`
- USDT Address: `[Insert USDT contract address, provided during deployment]`

### ABI
The Application Binary Interface (ABI) defines the contract’s interface. See the provided ABIs for `DezenMartLogistics` and USDT.

---

## Architecture

### Roles
- **Admin**: The contract deployer, who can register logistics providers, resolve disputes, and withdraw fees.
- **Buyers**: Initiate trades, confirm deliveries, cancel trades, or raise disputes.
- **Sellers**: Registered participants who receive `productCost` minus 2.5% fee upon settlement.
- **Logistics Providers**: Optional, registered participants who receive `logisticsCost` minus 2.5% fee.

### Trade Structure
The `Trade` struct stores trade details:
```solidity
struct Trade {
    address buyer;              // Buyer’s address
    address seller;             // Seller’s address
    address logisticsProvider;  // Logistics provider’s address (0x0 if none)
    uint256 productCost;        // Product cost (micro-USDT or wei)
    uint256 logisticsCost;      // Logistics cost (0 if no provider)
    uint256 escrowFee;          // 2.5% of productCost + 2.5% of logisticsCost
    uint256 totalAmount;        // productCost + logisticsCost
    bool logisticsSelected;     // True if logistics provider is used
    bool delivered;             // True if buyer confirmed delivery
    bool completed;             // True if payments settled or trade canceled
    bool disputed;              // True if dispute raised
    bool isUSDT;                // True for USDT, false for ETH
}
```

### Fee Calculation
- **Escrow Fee**: 2.5% of `productCost` and `logisticsCost`.
- **Calculation**: `(amount * ESCROW_FEE_PERCENT) / BASIS_POINTS`
  - `ESCROW_FEE_PERCENT = 250` (2.5%)
  - `BASIS_POINTS = 10000` (100%)
- Example: For `productCost = 3000000` micro-USDT ($3):
  - Fee = `(3000000 * 250) / 10000 = 75000` ($0.075)

---

## Key Functions

### State Variables (View Functions)
These functions query the contract’s state without gas costs (when called off-chain).

| Function | Description | Returns | Use Case |
|----------|-------------|---------|----------|
| `admin()` | Returns the admin’s address | `address` | Verify admin actions or restrict UI/API |
| `usdt()` | Returns the USDT contract address | `address` | Interact with USDT contract (e.g., approvals) |
| `BASIS_POINTS()` | Returns `10000` (for fee calculations) | `uint256` | Verify fee logic |
| `ESCROW_FEE_PERCENT()` | Returns `250` (2.5% fee) | `uint256` | Calculate/display fees |
| `buyerTrades(address, uint256)` | Returns trade ID at index for a buyer | `uint256` | Track trades (less common, use `getTradesByBuyer`) |
| `trades(uint256)` | Returns `Trade` struct for a trade ID | `Trade` | Fetch trade details |
| `getTradesByBuyer()` | Returns array of `Trade` structs for `msg.sender` | `Trade[]` | Display buyer’s trade history |
| `tradeCounter()` | Returns total number of trades | `uint256` | Track trade volume |
| `disputesResolved(uint256)` | Returns `true` if dispute resolved | `bool` | Check dispute status |
| `sellers(address)` | Returns `true` if address is a seller | `bool` | Validate seller status |
| `logisticsProviders(address)` | Returns `true` if address is a logistics provider | `bool` | Validate provider status |

**Example: Query Trades**
```javascript
const contract = new web3.eth.Contract(DezenMartLogistics_ABI, contractAddress);
const trades = await contract.methods.getTradesByBuyer().call({ from: buyerAddress });
trades.forEach(trade => {
    console.log(`Trade: Product Cost=${trade.productCost / 1e6} USDT, Delivered=${trade.delivered}`);
});
```

### State-Changing Functions
These functions modify the contract state and require transactions (gas).

| Function | Parameters | Description | Returns | Restrictions |
|----------|------------|-------------|---------|--------------|
| `createTrade` | `seller (address)`, `productCost (uint256)`, `logisticsProvider (address)`, `logisticsCost (uint256)`, `useUSDT (bool)` | Initiates a trade, locking funds | `uint256` (tradeId) | Buyer only, seller must be registered |
| `confirmDelivery` | `tradeId (uint256)` | Confirms delivery, settles payments | - | Buyer only, trade not delivered/disputed |
| `cancelTrade` | `tradeId (uint256)` | Cancels trade, refunds buyer | - | Buyer only, trade not delivered/disputed |
| `raiseDispute` | `tradeId (uint256)` | Raises a dispute | - | Trade participants only, trade not completed |
| `resolveDispute` | `tradeId (uint256)`, `winner (address)` | Resolves dispute, refunds or pays out | - | Admin only, active dispute |
| `registerSeller` | - | Registers `msg.sender` as a seller | - | None |
| `registerLogisticsProvider` | `provider (address)` | Registers a logistics provider | - | Admin only |
| `withdrawEscrowFeesETH` | - | Withdraws ETH fees | - | Admin only |
| `withdrawEscrowFeesUSDT` | - | Withdraws USDT fees | - | Admin only |

**Example: Create Trade**
```javascript
// Approve USDT
const usdtContract = new web3.eth.Contract(USDT_ABI, usdtAddress);
await usdtContract.methods.approve(contractAddress, "4000000").send({ from: buyerAddress });

// Create trade
const tradeId = await contract.methods.createTrade(
    sellerAddress,
    "3000000", // $3 in micro-USDT
    logisticsProviderAddress,
    "1000000", // $1
    true
).send({ from: buyerAddress });
```

### Events
Events are emitted for state changes, enabling real-time updates.

| Event | Parameters | Description | Use Case |
|-------|------------|-------------|----------|
| `TradeCreated` | `tradeId (indexed uint256)`, `buyer (indexed address)`, `seller (address)`, `logisticsProvider (address)`, `totalAmount (uint256)`, `isUSDT (bool)` | Emitted when a trade is created | Track new trades |
| `DeliveryConfirmed` | `tradeId (indexed uint256)` | Emitted when delivery is confirmed | Update trade status |
| `PaymentSettled` | `tradeId (indexed uint256)`, `sellerAmount (uint256)`, `logisticsAmount (uint256)`, `isUSDT (bool)` | Emitted when payments are settled | Log payouts |
| `LogisticsSelected` | `tradeId (indexed uint256)`, `logisticsProvider (address)`, `logisticsCost (uint256)` | Emitted when logistics is selected | Track logistics |
| `PaymentHeld` | `tradeId (indexed uint256)`, `totalAmount (uint256)`, `isUSDT (bool)` | Emitted when funds are locked | Confirm escrow |
| `DisputeRaised` | `tradeId (indexed uint256)`, `initiator (address)` | Emitted when a dispute is raised | Notify admin |
| `DisputeResolved` | `tradeId (indexed uint256)`, `winner (address)`, `isUSDT (bool)` | Emitted when a dispute is resolved | Update trade status |

**Example: Listen to TradeCreated**
```javascript
contract.events.TradeCreated({ filter: { buyer: buyerAddress } })
    .on('data', event => {
        console.log(`New Trade: ID=${event.returnValues.tradeId}, Total=${event.returnValues.totalAmount / 1e6} USDT`);
    });
```

### Errors
| Error | Parameters | Description | Handling |
|-------|------------|-------------|----------|
| `InsufficientUSDTAllowance` | `needed (uint256)`, `allowance (uint256)` | Thrown when USDT allowance is insufficient | Prompt user to approve USDT |

---

## USDT ERC20 Contract

### Purpose
The USDT contract is a standard ERC20 token used for USDT payments in `DezenMartLogistics`. It supports balance checking, transfers, and approvals.

### Key Functions
| Function | Parameters | Description | Returns | Use Case |
|----------|------------|-------------|---------|----------|
| `balanceOf` | `account (address)` | Returns USDT balance (micro-USDT) | `uint256` | Check user funds |
| `allowance` | `owner (address)`, `spender (address)` | Returns approved amount for spender | `uint256` | Verify approval |
| `approve` | `spender (address)`, `value (uint256)` | Approves spender to spend USDT | `bool` | Enable trade payments |
| `transfer` | `to (address)`, `value (uint256)` | Transfers USDT | `bool` | (Internal use) |
| `transferFrom` | `from (address)`, `to (address)`, `value (uint256)` | Transfers approved USDT | `bool` | (Internal use) |
| `decimals` | - | Returns 6 (USDT decimals) | `uint8` | Scale amounts |

**Example: Check Balance**
```javascript
const balance = await usdtContract.methods.balanceOf(buyerAddress).call();
console.log("Balance:", balance / 1e6, "USDT");
```

### Events
| Event | Parameters | Description | Use Case |
|-------|------------|-------------|----------|
| `Approval` | `owner (indexed address)`, `spender (indexed address)`, `value (uint256)` | Emitted on approval | Confirm approval |
| `Transfer` | `from (indexed address)`, `to (indexed address)`, `value (uint256)` | Emitted on transfer | Track payments |

---

## Integration Guide

### Backend Integration
The backend manages contract deployment, trade logic, event monitoring, and API services.

#### Deployment
1. **Deploy `DezenMartLogistics`**:
   ```javascript
   const DezenMartLogistics = new web3.eth.Contract(DezenMartLogistics_ABI);
   const contract = await DezenMartLogistics.deploy({
       data: DezenMartLogistics_BYTECODE,
       arguments: [usdtAddress]
   }).send({ from: adminAddress });
   console.log("Deployed at:", contract.options.address);
   ```

2. **Configure USDT Contract**:
   ```javascript
   const usdtContract = new web3.eth.Contract(USDT_ABI, usdtAddress);
   ```

#### API Endpoints
1. **Create Trade**:
   ```javascript
   app.post('/trade', async (req, res) => {
       const { seller, productCost, logisticsProvider, logisticsCost, useUSDT, buyer } = req.body;
       const totalAmount = (parseFloat(productCost) + parseFloat(logisticsCost)) * 1e6;
       const allowance = await usdtContract.methods.allowance(buyer, contract.options.address).call();
       if (useUSDT && allowance < totalAmount) {
           return res.status(400).json({ error: "Insufficient USDT allowance" });
       }
       const tradeId = await contract.methods.createTrade(
           seller,
           (productCost * 1e6).toString(),
           logisticsProvider || "0x0000000000000000000000000000000000000000",
           (logisticsCost * 1e6).toString(),
           useUSDT
       ).send({ from: buyer });
       res.json({ tradeId });
   });
   ```

2. **Get Trades**:
   ```javascript
   app.get('/trades/:buyer', async (req, res) => {
       const trades = await contract.methods.getTradesByBuyer().call({ from: req.params.buyer });
       res.json(trades.map(trade => ({
           tradeId: trade.tradeId,
           productCost: trade.productCost / 1e6,
           status: trade.delivered ? 'Delivered' : trade.disputed ? 'Disputed' : 'Pending'
       })));
   });
   ```

3. **Monitor Events**:
   ```javascript
   contract.events.allEvents()
       .on('data', event => {
           if (event.event === 'TradeCreated') {
               db.trades.insert({
                   tradeId: event.returnValues.tradeId,
                   buyer: event.returnValues.buyer,
                   totalAmount: event.returnValues.totalAmount / 1e6
               });
           }
       });
   ```

#### Considerations
- **Database**: Store trade IDs, statuses, and user details (e.g., MongoDB, PostgreSQL).
- **Event Indexing**: Use The Graph for efficient event querying.
- **Error Handling**: Catch `InsufficientUSDTAllowance` and prompt approvals.
- **Security**: Validate inputs to prevent errors or exploits.

### Frontend Integration
The frontend provides a user interface, interacting with the contract via a wallet (e.g., MetaMask).

#### Setup
1. **Connect Wallet**:
   ```javascript
   import Web3 from 'web3';
   const web3 = new Web3(window.ethereum);
   await window.ethereum.request({ method: 'eth_requestAccounts' });
   const accounts = await web3.eth.getAccounts();
   const account = accounts[0];
   ```

2. **Initialize Contracts**:
   ```javascript
   const contract = new web3.eth.Contract(DezenMartLogistics_ABI, contractAddress);
   const usdtContract = new web3.eth.Contract(USDT_ABI, usdtAddress);
   ```

#### UI Components
1. **Balance Display**:
   ```javascript
   const balance = await usdtContract.methods.balanceOf(account).call();
   setBalance(balance / 1e6);
   ```

2. **Trade Creation Form**:
   ```javascript
   const handleCreateTrade = async () => {
       const productCost = (parseFloat(form.productCost) * 1e6).toString();
       const logisticsCost = (parseFloat(form.logisticsCost) * 1e6).toString();
       const totalAmount = (parseFloat(form.productCost) + parseFloat(form.logisticsCost)) * 1e6;
       const allowance = await usdtContract.methods.allowance(account, contractAddress).call();
       if (form.useUSDT && allowance < totalAmount) {
           await usdtContract.methods.approve(contractAddress, totalAmount.toString()).send({ from: account });
       }
       await contract.methods.createTrade(
           form.sellerAddress,
           productCost,
           form.logisticsProvider || "0x0000000000000000000000000000000000000000",
           logisticsCost,
           form.useUSDT
       ).send({ from: account });
       setTrades([...trades, { productCost: form.productCost }]);
   };
   ```

3. **Trade History**:
   ```javascript
   const trades = await contract.methods.getTradesByBuyer().call({ from: account });
   setTrades(trades.map(trade => ({
       id: trade.tradeId,
       productCost: trade.productCost / 1e6,
       status: trade.delivered ? 'Delivered' : trade.disputed ? 'Disputed' : 'Pending'
   })));
   ```

4. **Trade Actions**:
   ```javascript
   const handleConfirmDelivery = async (tradeId) => {
       await contract.methods.confirmDelivery(tradeId).send({ from: account });
   };
   ```

#### Considerations
- **User Experience**: Guide users through USDT approvals with clear prompts.
- **Decimals**: Convert micro-USDT to USDT (e.g., `3 * 1e18 = 3 USDT`).
- **Error Handling**: Display errors like `InsufficientUSDTAllowance` with actionable steps.
- **Pagination**: Handle large trade lists with lazy loading.

---

## Balance Checking and Necessary Actions

### Balance Checking
1. **USDT Balance**:
   ```javascript
   const balance = await usdtContract.methods.balanceOf(account).call();
   if (balance < totalAmount) {
       alert("Insufficient USDT balance");
   }
   ```

2. **ETH Balance** (for ETH trades):
   ```javascript
   const ethBalance = await web3.eth.getBalance(account);
   if (ethBalance < totalAmount) {
       alert("Insufficient ETH balance");
   }
   ```

### Necessary Actions
1. **USDT Approval**:
   - Check allowance and prompt approval if needed:
     ```javascript
     const allowance = await usdtContract.methods.allowance(account, contractAddress).call();
     if (allowance < totalAmount) {
         await usdtContract.methods.approve(contractAddress, totalAmount.toString()).send({ from: account });
     }
     ```

2. **Trade Creation**:
   - Validate inputs (e.g., registered seller, scaled amounts).
   - Call `createTrade` after approval.

3. **Trade Monitoring**:
   - Use `getTradesByBuyer` for trade history.
   - Listen to events for real-time updates.

4. **Error Handling**:
   - Handle `InsufficientUSDTAllowance` by prompting approval.
   - Catch transaction failures (e.g., insufficient gas).

---

## Example Workflow

### Buyer Creates a Trade
1. **Frontend**:
   - User inputs: Product cost ($3), logistics cost ($1), seller address, logistics provider, USDT payment.
   - Converts to micro-USDT: `productCost = 3000000`, `logisticsCost = 1000000`.
   - Checks balance and allowance, prompts approval:
     ```javascript
     await usdtContract.methods.approve(contractAddress, "4000000").send({ from: account });
     ```
   - Calls `createTrade`:
     ```javascript
     await contract.methods.createTrade(sellerAddress, "3000000", logisticsProviderAddress, "1000000", true).send({ from: account });
     ```

2. **Backend**:
   - Listens to `TradeCreated`:
     ```javascript
     db.trades.insert({
         tradeId: event.returnValues.tradeId,
         buyer: event.returnValues.buyer,
         totalAmount: event.returnValues.totalAmount / 1e6
     });
     ```

### Buyer Confirms Delivery
1. **Frontend**:
   - Shows “Confirm Delivery” button for trade ID 1.
   - Calls:
     ```javascript
     await contract.methods.confirmDelivery(1).send({ from: account });
     ```

2. **Backend**:
   - Updates database on `DeliveryConfirmed` and `PaymentSettled`.

---

## Additional Considerations
- **Decimals**: USDT uses 6 decimals (1 USDT = 1,000,000 micro-USDT).
- **Gas Costs**: `getTradesByBuyer` may be costly for many trades; consider pagination:
  ```solidity
  function getTradesByBuyer(uint256 start, uint256 limit) external view returns (Trade[] memory)
  ```
- **Security**: Validate inputs and use try-catch for transactions.
- **Testing**: Use a testnet (e.g., Sepolia) with a USDT faucet.

---

## Support
For issues or enhancements:
- **Contact**: [Insert team contact]
- **Issues**: Check for `InsufficientUSDTAllowance` or input scaling errors.
- **Further Features**: Pagination, trade filtering, or notifications can be added.

This documentation provides a complete guide for integrating `DezenMartLogistics` and USDT contracts. Let me know if you need specific code, deployment scripts, or additional features!