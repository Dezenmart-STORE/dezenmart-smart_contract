# ABI AND CONTRACT ADDRESSES
## Logistic [0xF122b07B2730c6056114a5507FA1A776808Bf0A4]
[{"inputs":[{"internalType":"address","name":"_usdtAddress","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"BuyerIsSeller","type":"error"},{"inputs":[{"internalType":"uint256","name":"requested","type":"uint256"},{"internalType":"uint256","name":"available","type":"uint256"}],"name":"InsufficientQuantity","type":"error"},{"inputs":[{"internalType":"uint256","name":"needed","type":"uint256"},{"internalType":"uint256","name":"allowance","type":"uint256"}],"name":"InsufficientUSDTAllowance","type":"error"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"InvalidLogisticsProvider","type":"error"},{"inputs":[{"internalType":"uint256","name":"quantity","type":"uint256"}],"name":"InvalidQuantity","type":"error"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"InvalidTradeId","type":"error"},{"inputs":[{"internalType":"uint256","name":"providersLength","type":"uint256"},{"internalType":"uint256","name":"costsLength","type":"uint256"}],"name":"MismatchedArrays","type":"error"},{"inputs":[],"name":"NoLogisticsProviders","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"DeliveryConfirmed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"address","name":"initiator","type":"address"}],"name":"DisputeRaised","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"address","name":"winner","type":"address"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"DisputeResolved","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"address","name":"logisticsProvider","type":"address"},{"indexed":false,"internalType":"uint256","name":"logisticsCost","type":"uint256"}],"name":"LogisticsSelected","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"totalAmount","type":"uint256"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"PaymentHeld","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"sellerAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"logisticsAmount","type":"uint256"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"PaymentSettled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":true,"internalType":"address","name":"seller","type":"address"},{"indexed":false,"internalType":"address[]","name":"logisticsProviders","type":"address[]"},{"indexed":false,"internalType":"uint256","name":"productCost","type":"uint256"},{"indexed":false,"internalType":"uint256[]","name":"logisticsCosts","type":"uint256[]"},{"indexed":false,"internalType":"uint256","name":"totalQuantity","type":"uint256"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"TradeCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"tradeId","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"parentTradeId","type":"uint256"},{"indexed":true,"internalType":"address","name":"buyer","type":"address"},{"indexed":false,"internalType":"uint256","name":"totalAmount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"quantity","type":"uint256"},{"indexed":false,"internalType":"address","name":"chosenLogisticsProvider","type":"address"},{"indexed":false,"internalType":"bool","name":"isUSDT","type":"bool"}],"name":"TradePurchased","type":"event"},{"inputs":[],"name":"BASIS_POINTS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ESCROW_FEE_PERCENT","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"admin","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"},{"internalType":"uint256","name":"quantity","type":"uint256"},{"internalType":"uint256","name":"logisticsProviderIndex","type":"uint256"}],"name":"buyTrade","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"buyerTrades","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"cancelTrade","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"confirmDelivery","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"address[]","name":"logisticsProvidersList","type":"address[]"},{"internalType":"uint256[]","name":"logisticsCosts","type":"uint256[]"},{"internalType":"bool","name":"useUSDT","type":"bool"},{"internalType":"uint256","name":"totalQuantity","type":"uint256"}],"name":"createTrade","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"disputesResolved","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTradesByBuyer","outputs":[{"components":[{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"address[]","name":"logisticsProviders","type":"address[]"},{"internalType":"uint256[]","name":"logisticsCosts","type":"uint256[]"},{"internalType":"address","name":"chosenLogisticsProvider","type":"address"},{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"uint256","name":"logisticsCost","type":"uint256"},{"internalType":"uint256","name":"escrowFee","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"},{"internalType":"uint256","name":"totalQuantity","type":"uint256"},{"internalType":"uint256","name":"remainingQuantity","type":"uint256"},{"internalType":"bool","name":"logisticsSelected","type":"bool"},{"internalType":"bool","name":"delivered","type":"bool"},{"internalType":"bool","name":"completed","type":"bool"},{"internalType":"bool","name":"disputed","type":"bool"},{"internalType":"bool","name":"isUSDT","type":"bool"},{"internalType":"uint256","name":"parentTradeId","type":"uint256"}],"internalType":"struct DezenMartLogistics.Trade[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTradesBySeller","outputs":[{"components":[{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"address[]","name":"logisticsProviders","type":"address[]"},{"internalType":"uint256[]","name":"logisticsCosts","type":"uint256[]"},{"internalType":"address","name":"chosenLogisticsProvider","type":"address"},{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"uint256","name":"logisticsCost","type":"uint256"},{"internalType":"uint256","name":"escrowFee","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"},{"internalType":"uint256","name":"totalQuantity","type":"uint256"},{"internalType":"uint256","name":"remainingQuantity","type":"uint256"},{"internalType":"bool","name":"logisticsSelected","type":"bool"},{"internalType":"bool","name":"delivered","type":"bool"},{"internalType":"bool","name":"completed","type":"bool"},{"internalType":"bool","name":"disputed","type":"bool"},{"internalType":"bool","name":"isUSDT","type":"bool"},{"internalType":"uint256","name":"parentTradeId","type":"uint256"}],"internalType":"struct DezenMartLogistics.Trade[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"logisticsProviders","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"}],"name":"raiseDispute","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"provider","type":"address"}],"name":"registerLogisticsProvider","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"registerSeller","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tradeId","type":"uint256"},{"internalType":"address","name":"winner","type":"address"}],"name":"resolveDispute","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"sellerTrades","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"sellers","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"tradeCounter","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"trades","outputs":[{"internalType":"address","name":"buyer","type":"address"},{"internalType":"address","name":"seller","type":"address"},{"internalType":"address","name":"chosenLogisticsProvider","type":"address"},{"internalType":"uint256","name":"productCost","type":"uint256"},{"internalType":"uint256","name":"logisticsCost","type":"uint256"},{"internalType":"uint256","name":"escrowFee","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"},{"internalType":"uint256","name":"totalQuantity","type":"uint256"},{"internalType":"uint256","name":"remainingQuantity","type":"uint256"},{"internalType":"bool","name":"logisticsSelected","type":"bool"},{"internalType":"bool","name":"delivered","type":"bool"},{"internalType":"bool","name":"completed","type":"bool"},{"internalType":"bool","name":"disputed","type":"bool"},{"internalType":"bool","name":"isUSDT","type":"bool"},{"internalType":"uint256","name":"parentTradeId","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"usdt","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"withdrawEscrowFeesETH","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdrawEscrowFeesUSDT","outputs":[],"stateMutability":"nonpayable","type":"function"}]


## USDT [0x3D6D20896b945E947b962a8c043E09c522504079]
[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"allowance","type":"uint256"},{"internalType":"uint256","name":"needed","type":"uint256"}],"name":"ERC20InsufficientAllowance","type":"error"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"uint256","name":"balance","type":"uint256"},{"internalType":"uint256","name":"needed","type":"uint256"}],"name":"ERC20InsufficientBalance","type":"error"},{"inputs":[{"internalType":"address","name":"approver","type":"address"}],"name":"ERC20InvalidApprover","type":"error"},{"inputs":[{"internalType":"address","name":"receiver","type":"address"}],"name":"ERC20InvalidReceiver","type":"error"},{"inputs":[{"internalType":"address","name":"sender","type":"address"}],"name":"ERC20InvalidSender","type":"error"},{"inputs":[{"internalType":"address","name":"spender","type":"address"}],"name":"ERC20InvalidSpender","type":"error"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"OwnableInvalidOwner","type":"error"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"OwnableUnauthorizedAccount","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]

# DezenMartLogistics Smart Contract Documentation

## Overview

The `DezenMartLogistics` smart contract facilitates e-commerce trades with escrow, supporting payments in **ETH** or **USDT**. It manages trades between **buyers**, **sellers**, and multiple **logistics providers**, deducting a **2.5% escrow fee** from both product and logistics costs upon settlement. The contract integrates with a USDT ERC20 token contract, requiring proper balance and allowance management.

### Documentation Covers:

- Contract purpose and architecture.
- Key functions, events, and state variables.
- Integration guidance for backend and frontend developers.
- USDT contract interactions for balance checking and approvals.
- Example workflows and code snippets.

---

## Contract Details

### Purpose

The `DezenMartLogistics` contract enables secure, trustless trades by:

- Allowing sellers to create trades with multiple logistics providers and quantities.
- Holding funds (ETH or USDT) in escrow until delivery or dispute resolution.
- Deducting a 2.5% escrow fee from product and logistics costs, retained by the admin.
- Supporting buyer-selected logistics providers.
- Enabling buyers to confirm delivery, cancel trades, or raise disputes.
- Allowing admin to resolve disputes and withdraw accumulated fees.

### USDT Integration

For USDT-based trades:

- Buyers must approve the contract to spend USDT on their behalf.
- Contract verifies balance and allowance before trade execution.

### Key Features

- **Trade Creation:** Sellers specify costs, quantities, and multiple logistics options.
- **Purchase:** Buyers select a trade and logistics provider and make a payment.
- **Delivery Confirmation:** Buyers confirm deliveries to release funds.
- **Disputes:** Buyers or sellers may raise disputes; the admin resolves them.
- **Fee Management:** Admin can withdraw collected fees (ETH/USDT).
- **Trade History:** Traders can retrieve historical transactions.

---

## Deployment Addresses

- **Contract Address:** [0xF122b07B2730c6056114a5507FA1A776808Bf0A4]
- **USDT Token Address:** [0x3D6D20896b945E947b962a8c043E09c522504079]

---

## ABI

Refer to the ABI files for:

- DezenMartLogistics
- USDT ERC20

---

## Architecture

### Roles

| Role              | Permissions                                                                 |
|-------------------|------------------------------------------------------------------------------|
| Admin             | Deploys contract, registers logistics providers, resolves disputes, withdraws fees |
| Sellers           | Create trades, receive payments minus fees                                   |
| Buyers            | Buy trades, confirm deliveries, raise/cancel disputes                        |
| Logistics Providers | Registered by admin, deliver goods, receive payments minus fees             |

---

## Trade Structure

```solidity
struct Trade {
    address buyer;
    address seller;
    address[] logisticsProviders;
    uint256[] logisticsCosts;
    address chosenLogisticsProvider;
    uint256 productCost;
    uint256 logisticsCost;
    uint256 escrowFee;
    uint256 totalAmount;
    uint256 totalQuantity;
    uint256 remainingQuantity;
    bool logisticsSelected;
    bool delivered;
    bool completed;
    bool disputed;
    bool isUSDT;
    uint256 parentTradeId;
}
````

---

## Fee Calculation

* **Escrow Fee:** 2.5% of productCost and logisticsCost.
* **Formula:**
  `(amount * ESCROW_FEE_PERCENT) / BASIS_POINTS`

  * `ESCROW_FEE_PERCENT = 250`
  * `BASIS_POINTS = 10000`

**Example:**

* productCost = 3 USDT (3\_000\_000 micro-USDT)
* logisticsCost = 1 USDT (1\_000\_000 micro-USDT)

```text
Product Fee = 75,000 micro-USDT = $0.075  
Logistics Fee = 25,000 micro-USDT = $0.025  
Total Fee = 100,000 micro-USDT = $0.10
```

---

## Key Functions

### View Functions

| Function                      | Returns    | Purpose                       |
| ----------------------------- | ---------- | ----------------------------- |
| `admin()`                     | address    | Returns admin address         |
| `usdt()`                      | address    | Returns USDT contract address |
| `BASIS_POINTS()`              | uint256    | Returns 10000                 |
| `ESCROW_FEE_PERCENT()`        | uint256    | Returns 250                   |
| `buyerTrades(address)`        | uint256\[] | Trade IDs for a buyer         |
| `sellerTrades(address)`       | uint256\[] | Trade IDs for a seller        |
| `trades(uint256)`             | Trade      | Fetch trade by ID             |
| `getTradesByBuyer()`          | Trade\[]   | All trades by `msg.sender`    |
| `getTradesBySeller()`         | Trade\[]   | All trades by `msg.sender`    |
| `tradeCounter()`              | uint256    | Total trades                  |
| `disputesResolved(uint256)`   | bool       | Dispute status                |
| `sellers(address)`            | bool       | Check seller status           |
| `logisticsProviders(address)` | bool       | Check logistics status        |

**Example:**

```javascript
const trades = await contract.methods.getTradesByBuyer().call({ from: buyerAddress });
trades.forEach(trade => console.log(`Trade: $${trade.productCost / 1e6}, Delivered: ${trade.delivered}`));
```

---

### State-Changing Functions

| Function                                                                               | Description              | Restrictions    |
| -------------------------------------------------------------------------------------- | ------------------------ | --------------- |
| `createTrade(productCost, logisticsProviders, logisticsCosts, useUSDT, totalQuantity)` | Seller creates a trade   | Only seller     |
| `buyTrade(tradeId, quantity, logisticsProviderIndex)`                                  | Buyer purchases a trade  | Only buyer      |
| `confirmDelivery(tradeId)`                                                             | Buyer confirms delivery  | Buyer only      |
| `cancelTrade(tradeId)`                                                                 | Buyer cancels a trade    | Buyer only      |
| `raiseDispute(tradeId)`                                                                | Raise a dispute          | Buyer or Seller |
| `resolveDispute(tradeId, winner)`                                                      | Admin resolves dispute   | Admin only      |
| `registerSeller()`                                                                     | Register as seller       | Anyone          |
| `registerLogisticsProvider(provider)`                                                  | Admin registers provider | Admin only      |
| `withdrawEscrowFeesETH()`                                                              | Withdraw ETH fees        | Admin only      |
| `withdrawEscrowFeesUSDT()`                                                             | Withdraw USDT fees       | Admin only      |

---

## Events

| Event                                                            | Description        |
| ---------------------------------------------------------------- | ------------------ |
| `TradeCreated(tradeId, seller, logisticsProviders, ...)`         | New trade created  |
| `TradePurchased(tradeId, parentTradeId, buyer, ...)`             | Trade bought       |
| `LogisticsSelected(tradeId, logisticsProvider, ...)`             | Logistics selected |
| `PaymentHeld(tradeId, totalAmount, isUSDT)`                      | Funds held         |
| `DeliveryConfirmed(tradeId)`                                     | Delivery confirmed |
| `PaymentSettled(tradeId, sellerAmount, logisticsAmount, isUSDT)` | Funds released     |
| `DisputeRaised(tradeId, initiator)`                              | Dispute initiated  |
| `DisputeResolved(tradeId, winner, isUSDT)`                       | Dispute resolved   |

---

## Errors

| Error                                            | Description           |
| ------------------------------------------------ | --------------------- |
| `InsufficientUSDTAllowance(needed, allowance)`   | Prompt approval       |
| `InvalidTradeId(tradeId)`                        | Invalid ID            |
| `BuyerIsSeller()`                                | Prevent self-purchase |
| `InsufficientQuantity(requested, available)`     | Out-of-stock          |
| `InvalidQuantity(quantity)`                      | Must be positive      |
| `InvalidLogisticsProvider(index)`                | Index error           |
| `MismatchedArrays(providersLength, costsLength)` | List mismatch         |
| `NoLogisticsProviders()`                         | At least one required |

---

## USDT Contract

### Key Functions

| Function                        | Returns | Description        |
| ------------------------------- | ------- | ------------------ |
| `balanceOf(account)`            | uint256 | Get balance        |
| `allowance(owner, spender)`     | uint256 | Approved amount    |
| `approve(spender, value)`       | bool    | Approve spending   |
| `transfer(to, value)`           | bool    | Send USDT          |
| `transferFrom(from, to, value)` | bool    | Transfer on behalf |
| `decimals()`                    | uint8   | Should return 6    |

---

## Integration Guide

### Backend

#### Deployment

```js
const DezenMartLogistics = new web3.eth.Contract(ABI);
const contract = await DezenMartLogistics.deploy({
  data: BYTECODE,
  arguments: [usdtAddress]
}).send({ from: adminAddress });
```

#### API Routes

* `/trade` - Create trade
* `/buy-trade` - Buy trade
* `/trades/:buyer` - Get buyer trades

#### Event Listening

```js
contract.events.allEvents().on('data', event => {
  console.log(event);
});
```

---

### Frontend

#### Wallet Setup

```js
const web3 = new Web3(window.ethereum);
await window.ethereum.request({ method: 'eth_requestAccounts' });
```

#### Create Trade

```js
await contract.methods.createTrade(
  "3000000",
  ["0xProvider1", "0xProvider2"],
  ["1000000", "1200000"],
  true,
  100
).send({ from: seller });
```

#### Buy Trade

```js
await usdtContract.methods.approve(contractAddress, totalAmount).send({ from: buyer });
await contract.methods.buyTrade(tradeId, quantity, index).send({ from: buyer });
```

---

## Example Workflow

### Seller Creates a Trade

1. Convert prices to micro-USDT
2. Call `createTrade`

### Buyer Purchases

1. Approve USDT if needed
2. Call `buyTrade`

### Buyer Confirms Delivery

Call `confirmDelivery(tradeId)`

---

## Additional Considerations

* **Decimals:** USDT uses 6 decimals (1 USDT = 1,000,000,000,000,000,000 micro-USDT).
* **Pagination:** For large trade lists, implement pagination in `getTradesByBuyer(start, limit)`.
* **Security:** Validate user inputs and handle failed transactions.
* **Testing:** Use Sepolia testnet with faucet for trial.

