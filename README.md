
# DezenMartLogistics

**DezenMartLogistics** is a decentralized logistics and escrow system designed to facilitate secure, trustless marketplace transactions with optional logistics provider integration. Built with **Solidity** and **Foundry**, the contract ensures robust fund handling, supports payments in **ETH** and **USDT**, and provides admin-managed dispute resolution. A **2.5% platform fee** is charged on both product and logistics costs, ensuring minimal costs while maintaining security and transparency.

This project is ideal for developers building decentralized e-commerce platforms, marketplaces, or logistics solutions. It leverages Ethereum’s blockchain for transparency and immutability, with events emitted for all major actions to enable real-time tracking.

---

## 🔍 Features

- **🔐 Secure Escrow Mechanism**: Funds (ETH or USDT) are locked in escrow until the buyer confirms delivery or a dispute is resolved, ensuring trustless transactions.
- **💱 Dual Payment Support**: Supports payments in **ETH** (in wei) or **USDT** (in micro-USDT, 6 decimals), providing flexibility for users.
- **🚚 Optional Logistics Integration**: Buyers can include a registered logistics provider or opt for no logistics, with costs handled transparently.
- **⚖️ Dispute Resolution**: Buyers, sellers, or logistics providers can raise disputes, which are resolved by the admin with clear event logging.
- **🧾 Event Transparency**: Comprehensive events (`TradeCreated`, `DeliveryConfirmed`, etc.) are emitted for all actions, enabling real-time tracking and auditing.
- **💰 Platform Fee**: A **2.5% fee** is deducted from both `productCost` and `logisticsCost` upon settlement, retained by the admin for platform maintenance.
- **🔍 Trade Querying**: Buyers can retrieve all their trade details via `getTradesByBuyer`, supporting seamless front-end integration.
- **🔐 Admin Controls**: Admin can whitelist logistics providers, resolve disputes, and withdraw accumulated fees.

---

## 🛠 Prerequisites

To work with `DezenMartLogistics`, ensure you have the following installed:

- **[Foundry](https://book.getfoundry.sh/getting-started/installation)**: A blazing-fast Ethereum development toolkit for compiling, testing, and deploying smart contracts.
- **[Node.js](https://nodejs.org/)** (v16+): Required for JavaScript-based interactions (e.g., deployment scripts or front-end integration).
- **Ethereum Wallet**: A wallet like **[MetaMask](https://metamask.io/)** for interacting with the blockchain.
- **RPC URL**: Access to an Ethereum network (e.g., Alfajores Testnet, Sepolia, or mainnet) via providers like Infura, Alchemy, or a local node.
- **USDT Contract Address**: The address of a deployed USDT ERC20 contract (mainnet or testnet) for USDT payments.

Optional:
- **[Yarn](https://yarnpkg.com/)** or **[npm](https://www.npmjs.com/)**: For managing dependencies in front-end or scripting projects.
- **Block Explorer API Key**: For verifying contracts on explorers like Blockscout or Etherscan.

---

## ⚙️ Setup

Follow these steps to set up the project locally:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Dezenmart-STORE/dezenmart-smart_contract.git
   cd dezenmart-smart_contract
   ```

2. **Install Dependencies**:
   Install Foundry’s dependencies (e.g., OpenZeppelin contracts):
   ```bash
   forge install
   ```
   This installs libraries specified in `foundry.toml` (e.g., `@openzeppelin/contracts` for IERC20).

3. **Configure Environment**:
   Create a `.env` file in the project root for sensitive data:
   ```bash
   touch .env
   ```
   Add the following:
   ```env
   RPC_URL=https://public-node.testnet.co
   PRIVATE_KEY=your_private_key
   BLOCKSCOUT_API_KEY=your_api_key
   ```
   - `RPC_URL`: Your Ethereum node URL (e.g., Alfajores Testnet).
   - `PRIVATE_KEY`: Your wallet’s private key (never commit to version control).
   - `BLOCKSCOUT_API_KEY`: API key for Blockscout (can be any non-empty string for Foundry).

4. **Verify `foundry.toml`**:
   Ensure the `foundry.toml` file is configured for your network:
   ```toml
   [profile.default]
   src = "src"
   out = "out"
   libs = ["lib"]
   solc_version = "0.8.20"
   evm_version = "paris"

   [rpc_endpoints]
   alfajores = "https://public-node.testnet.co"

   [etherscan]
   alfajores = { key = "${BLOCKSCOUT_API_KEY}", url = "https://testnet.blockscout.com/api" }

   [fmt]
   line_length = 100
   ```
   - Update `rpc_endpoints` and `etherscan` for your target network (e.g., Sepolia, mainnet).
   - Replace `BLOCKSCOUT_API_KEY` with your API key or a placeholder string.

5. **Install Node.js Dependencies** (Optional):
   If using JavaScript for deployment or front-end integration:
   ```bash
   npm install web3 ethers dotenv
   ```
   or
   ```bash
   yarn add web3 ethers dotenv
   ```

---

## 📁 Project Structure

```
dezenmart-smart_contract/
├── src/                        # Smart contract source files
│   └── DezenMartLogistics.sol  # Main contract
├── test/                       # Foundry test files
│   └── DezenMartLogistics.t.sol # Test suite
├── lib/                        # External libraries (e.g., OpenZeppelin)
├── script/                     # Deployment scripts
│   └── Deploy.s.sol            # Example deployment script
├── foundry.toml                # Foundry configuration
├── .env                        # Environment variables (not committed)
├── package.json                # Node.js dependencies (optional)
└── README.md                   # Project documentation
```

---

## 🧪 Testing

The project includes a test suite to verify contract functionality. Tests are written in Solidity using Foundry’s testing framework.

1. **Run Tests**:
   ```bash
   forge test
   ```
   - Runs all tests in the `test/` directory.
   - Outputs test results, including gas usage and coverage.

2. **Verbose Output**:
   For detailed logs:
   ```bash
   forge test -vvv
   ```

3. **Specific Test**:
   Run a single test:
   ```bash
   forge test --match-test testCreateTrade
   ```

4. **Test Coverage**:
   Generate a coverage report:
   ```bash
   forge coverage
   ```

**Example Test Cases**:
- Trade creation with ETH and USDT.
- Delivery confirmation and payment settlement.
- Dispute raising and resolution.
- Fee calculations (2.5% on product and logistics costs).

---

## 🚀 Deployment

Deploy the `DezenMartLogistics` contract to your chosen Ethereum network (e.g., Alfajores Testnet).

### Prerequisites
- A funded wallet with ETH for gas fees.
- The USDT contract address for the target network (e.g., Tether’s USDT on mainnet or a testnet mock).

### Deployment Steps
1. **Write a Deployment Script**:
   Create `script/Deploy.s.sol`:
   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.20;

   import {Script} from "forge-std/Script.sol";
   import {DezenMartLogistics} from "../src/DezenMartLogistics.sol";

   contract Deploy is Script {
       function run() external {
           vm.startBroadcast();
           DezenMartLogistics contractInstance = new DezenMartLogistics(USDT_ADDRESS);
           vm.stopBroadcast();
       }
   }
   ```
   Replace `USDT_ADDRESS` with the actual USDT contract address (e.g., `0xdAC17F958D2ee523a2206206994597C13D831ec7` for Ethereum mainnet USDT).

2. **Deploy with Foundry**:
   ```bash
   forge script script/Deploy.s.sol:Deploy --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
   ```
   - `--rpc-url`: Your Ethereum node URL.
   - `--private-key`: Your wallet’s private key.
   - `--broadcast`: Executes the deployment.
   - `--verify`: Verifies the contract on Blockscout/Etherscan (requires API key).

3. **Verify Deployment**:
   Check the contract address in the console output or on the block explorer (e.g., `https://testnet.blockscout.com`).

4. **Alternative: Deploy with JavaScript**:
   Use Web3.js or Ethers.js:
   ```javascript
   const { ethers } = require("ethers");
   require("dotenv").config();

   const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
   const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
   const factory = new ethers.ContractFactory(DezenMartLogistics_ABI, DezenMartLogistics_BYTECODE, wallet);
   const contract = await factory.deploy(usdtAddress);
   await contract.waitForDeployment();
   console.log("Deployed at:", await contract.getAddress());
   ```

---

## 🔗 Configuring `foundry.toml`

The `foundry.toml` file configures Foundry’s behavior. Below is a complete example for Alfajores Testnet:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.20"
evm_version = "paris"
optimizer = true
optimizer_runs = 200

[rpc_endpoints]
alfajores = "https://public-node.testnet.co"

[etherscan]
alfajores = { key = "${BLOCKSCOUT_API_KEY}", url = "https://testnet.blockscout.com/api" }

[fmt]
line_length = 100
tab_width = 4
bracket_spacing = true
```

### Notes
- **RPC URL**: Replace with your network’s URL (e.g., Infura, Alchemy).
- **Blockscout API Key**: Use any non-empty string if no API key is required (Foundry needs a placeholder).
- **Chains**: Add additional networks (e.g., Sepolia, mainnet) as needed:
  ```toml
  [rpc_endpoints]
  sepolia = "https://rpc.sepolia.org"
  ```

---

## 📜 Key Functions

Below are the primary functions for interacting with `DezenMartLogistics`. All monetary amounts are in **micro-USDT** (6 decimals) for USDT or **wei** for ETH.

### Public Functions
| Function | Parameters | Description | Returns | Restrictions |
|----------|------------|-------------|---------|--------------|
| `registerSeller()` | - | Registers `msg.sender` as a seller | - | None |
| `registerLogisticsProvider(address provider)` | `provider` | Registers a logistics provider | - | Admin only |
| `createTrade(address seller, uint256 productCost, address logisticsProvider, uint256 logisticsCost, bool useUSDT)` | `seller`, `productCost`, `logisticsProvider`, `logisticsCost`, `useUSDT` | Creates a trade, locking funds in escrow | `uint256` (tradeId) | Buyer only, seller must be registered, provider must be 0x0 or registered |
| `confirmDelivery(uint256 tradeId)` | `tradeId` | Confirms delivery, settles payments (minus 2.5% fees) | - | Buyer only, trade not delivered/disputed |
| `cancelTrade(uint256 tradeId)` | `tradeId` | Cancels trade, refunds buyer | - | Buyer only, trade not delivered/disputed |
| `raiseDispute(uint256 tradeId)` | `tradeId` | Raises a dispute | - | Trade participants only, trade not completed |
| `resolveDispute(uint256 tradeId, address winner)` | `tradeId`, `winner` | Resolves dispute, refunds or pays out | - | Admin only, active dispute |
| `withdrawEscrowFeesETH()` | - | Withdraws ETH fees | - | Admin only |
| `withdrawEscrowFeesUSDT()` | - | Withdraws USDT fees | - | Admin only |
| `getTradesByBuyer()` | - | Returns all trades for `msg.sender` | `Trade[]` | None |

### View Functions
| Function | Description | Returns |
|----------|-------------|---------|
| `admin()` | Returns admin’s address | `address` |
| `usdt()` | Returns USDT contract address | `address` |
| `BASIS_POINTS()` | Returns `10000` (fee denominator) | `uint256` |
| `ESCROW_FEE_PERCENT()` | Returns `250` (2.5% fee) | `uint256` |
| `trades(uint256)` | Returns `Trade` struct for a trade ID | `Trade` |
| `tradeCounter()` | Returns total trades | `uint256` |
| `sellers(address)` | Returns `true` if address is a seller | `bool` |
| `logisticsProviders(address)` | Returns `true` if address is a provider | `bool` |

### USDT Functions (ERC20)
| Function | Parameters | Description | Returns |
|----------|------------|-------------|---------|
| `balanceOf(address)` | `account` | Returns USDT balance (micro-USDT) | `uint256` |
| `allowance(address, address)` | `owner`, `spender` | Returns approved amount | `uint256` |
| `approve(address, uint256)` | `spender`, `value` | Approves USDT spending | `bool` |

---

## 🔐 Admin Controls

The admin (contract deployer) has the following privileges:
- **Register Logistics Providers**: Whitelist providers via `registerLogisticsProvider`.
- **Resolve Disputes**: Settle disputes via `resolveDispute`, refunding the buyer or paying the seller/provider.
- **Withdraw Fees**: Collect accumulated 2.5% fees via `withdrawEscrowFeesETH` or `withdrawEscrowFeesUSDT`.

**Security Note**: Admin actions are restricted by the `onlyAdmin` modifier. Ensure the admin’s private key is secure.

---

## 📄 Events

Events provide transparency and enable real-time tracking:

| Event | Parameters | Description |
|-------|------------|-------------|
| `TradeCreated` | `tradeId (indexed uint256)`, `buyer (indexed address)`, `seller (address)`, `logisticsProvider (address)`, `totalAmount (uint256)`, `isUSDT (bool)` | Trade created |
| `DeliveryConfirmed` | `tradeId (indexed uint256)` | Delivery confirmed |
| `PaymentSettled` | `tradeId (indexed uint256)`, `sellerAmount (uint256)`, `logisticsAmount (uint256)`, `isUSDT (bool)` | Payments settled |
| `LogisticsSelected` | `tradeId (indexed uint256)`, `logisticsProvider (address)`, `logisticsCost (uint256)` | Logistics provider selected |
| `PaymentHeld` | `tradeId (indexed uint256)`, `totalAmount (uint256)`, `isUSDT (bool)` | Funds locked in escrow |
| `DisputeRaised` | `tradeId (indexed uint256)`, `initiator (address)` | Dispute raised |
| `DisputeResolved` | `tradeId (indexed uint256)`, `winner (address)`, `isUSDT (bool)` | Dispute resolved |

**Example: Event Listener**
```javascript
contract.events.TradeCreated({ filter: { buyer: buyerAddress } })
    .on('data', event => {
        console.log(`New Trade: ID=${event.returnValues.tradeId}, Total=${event.returnValues.totalAmount / 1e6} USDT`);
    });
```

---

## 🖥️ Backend Integration

### Setup
1. **Initialize Web3/Ethers**:
   ```javascript
   const { ethers } = require("ethers");
   const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
   const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
   const contract = new ethers.Contract(contractAddress, DezenMartLogistics_ABI, wallet);
   const usdtContract = new ethers.Contract(usdtAddress, USDT_ABI, wallet);
   ```

2. **API Endpoints**:
   - **Create Trade**:
     ```javascript
     app.post('/trade', async (req, res) => {
         const { seller, productCost, logisticsProvider, logisticsCost, useUSDT, buyer } = req.body;
         const totalAmount = (parseFloat(productCost) + parseFloat(logisticsCost)) * 1e6;
         if (useUSDT) {
             const allowance = await usdtContract.allowance(buyer, contractAddress);
             if (allowance < totalAmount) throw new Error("Insufficient USDT allowance");
         }
         const tx = await contract.createTrade(
             seller,
             ethers.parseUnits(productCost, 6),
             logisticsProvider || ethers.ZeroAddress,
             ethers.parseUnits(logisticsCost, 6),
             useUSDT,
             { from: buyer }
         );
         res.json({ tradeId: tx.events.TradeCreated.returnValues.tradeId });
     });
     ```
   - **Get Trades**:
     ```javascript
     app.get('/trades/:buyer', async (req, res) => {
         const trades = await contract.getTradesByBuyer({ from: req.params.buyer });
         res.json(trades.map(trade => ({
             tradeId: trade.tradeId,
             productCost: ethers.formatUnits(trade.productCost, 6),
             status: trade.delivered ? 'Delivered' : trade.disputed ? 'Disputed' : 'Pending'
         })));
     });
     ```

3. **Event Monitoring**:
   ```javascript
   contract.on("TradeCreated", (tradeId, buyer, seller, logisticsProvider, totalAmount, isUSDT) => {
       db.trades.insert({
           tradeId: tradeId.toString(),
           buyer,
           totalAmount: ethers.formatUnits(totalAmount, isUSDT ? 6 : 18)
       });
   });
   ```

### Considerations
- **Database**: Store trade details for quick access (e.g., MongoDB).
- **Event Indexing**: Use The Graph for efficient event querying.
- **Error Handling**: Catch `InsufficientUSDTAllowance` and prompt approvals.

---

## 🌐 Frontend Integration

### Setup
1. **Connect Wallet**:
   ```javascript
   import { ethers } from "ethers";
   const provider = new ethers.BrowserProvider(window.ethereum);
   await provider.send("eth_requestAccounts", []);
   const signer = await provider.getSigner();
   const contract = new ethers.Contract(contractAddress, DezenMartLogistics_ABI, signer);
   const usdtContract = new ethers.Contract(usdtAddress, USDT_ABI, signer);
   ```

2. **UI Components**:
   - **Balance Display**:
     ```javascript
     const balance = await usdtContract.balanceOf(signer.address);
     setBalance(ethers.formatUnits(balance, 6));
     ```
   - **Trade Form**:
     ```javascript
     const handleCreateTrade = async () => {
         const productCost = ethers.parseUnits(form.productCost, 6);
         const logisticsCost = ethers.parseUnits(form.logisticsCost, 6);
         const totalAmount = productCost + logisticsCost;
         if (form.useUSDT) {
             const allowance = await usdtContract.allowance(signer.address, contractAddress);
             if (allowance < totalAmount) {
                 await usdtContract.approve(contractAddress, totalAmount);
             }
         }
         const tx = await contract.createTrade(
             form.sellerAddress,
             productCost,
             form.logisticsProvider || ethers.ZeroAddress,
             logisticsCost,
             form.useUSDT
         );
         await tx.wait();
     };
     ```
   - **Trade History**:
     ```javascript
     const trades = await contract.getTradesByBuyer();
     setTrades(trades.map(trade => ({
         id: trade.tradeId,
         productCost: ethers.formatUnits(trade.productCost, 6),
         status: trade.delivered ? 'Delivered' : trade.disputed ? 'Disputed' : 'Pending'
     })));
     ```

### Considerations
- **Decimals**: Convert micro-USDT to USDT (e.g., `3000000 / 1e6 = 3 USDT`).
- **UX**: Prompt users for USDT approvals with clear instructions.
- **Pagination**: Handle large trade lists with lazy loading.

---

## 📚 Example Workflow

### Buyer Creates a Trade
1. **Frontend**:
   - User inputs: Product cost ($3), logistics cost ($1), seller address, USDT payment.
   - Approves USDT:
     ```javascript
     await usdtContract.approve(contractAddress, ethers.parseUnits("4", 6));
     ```
   - Creates trade:
     ```javascript
     await contract.createTrade(sellerAddress, ethers.parseUnits("3", 6), logisticsProviderAddress, ethers.parseUnits("1", 6), true);
     ```

2. **Backend**:
   - Logs `TradeCreated` event in database.

### Buyer Confirms Delivery
1. **Frontend**:
   - Calls `confirmDelivery(1)` for trade ID 1.
2. **Backend**:
   - Updates database on `DeliveryConfirmed`.

---

## 🔎 Troubleshooting

- **InsufficientUSDTAllowance**: Ensure buyer approves USDT:
  ```javascript
  await usdtContract.approve(contractAddress, totalAmount);
  ```
- **Zero Fees**: Small inputs (e.g., `productCost = 3`) yield zero fees. Use micro-USDT (e.g., `3000000` for $3).
- **Gas Issues**: Increase gas limit for complex transactions (e.g., 200,000).

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit changes (`git commit -m "Add YourFeature"`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

For questions, contact the maintainer at `[Insert contact email or Discord]`.

---

## 📌 Notes
- **Network**: Tested on Alfajores Testnet; adapt for other networks (e.g., Sepolia, mainnet).
- **USDT**: Use the official USDT contract or a testnet mock.
- **Security**: Audit the contract before mainnet deployment.

This README provides a complete guide to `DezenMartLogistics`. For additional help, open an issue or reach out to the team!