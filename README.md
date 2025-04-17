

```markdown
# DezenMartLogistics

A decentralized logistics and escrow system enabling secure marketplace transactions with optional logistics provider integration. Built with Solidity and Foundry, the contract ensures secure fund handling, supports ETH and USDT payments, and enables dispute resolution with minimal platform fees.

## 🔍 Features

- 🔐 **Escrow Mechanism** – Ensures funds are locked until delivery is confirmed.
- 💱 **Dual Payment Support** – Accepts both ETH and USDT.
- 🚚 **Optional Logistics Integration** – Users can select a logistics provider.
- ⚖️ **Dispute Resolution** – Admin-resolved disputes with event logs.
- 🧾 **Event Transparency** – Emits events for every major action.
- 💰 **Platform Fee** – 2.5% charged on logistics only.

## 🛠 Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Node.js](https://nodejs.org/)
- An Ethereum wallet (e.g., MetaMask)
- RPC URL (e.g.,Alfajore Testnet)

## ⚙️ Setup

```bash
git clone https://github.com/your-username/DezenMartLogistics.git
cd DezenMartLogistics
forge install
```

## 📁 Project Structure

```
src/                   → Smart contracts
├── Logistics.sol
test/                  → Foundry tests
foundry.toml           → Foundry config
README.md              → Project docs
```

## 🧪 Testing

```bash
forge test
```

## 🚀 Deployment

Use the constructor to deploy with a USDT token address:

```solidity
constructor(address _usdtAddress)
```

## 🔗 Configuring `foundry.toml`

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]

[rpc_endpoints]
Testneturl = "https://public-node.testnet.co"

[etherscan]
key = { Testnet = "PLACEHOLDER_API_KEY" }

chains = [
  { 
    name = "Testnet", 
    chain_id = 3100, 
    explorer = "https://testnet.blockscout.com", 
    api_url = "https://testnet.blockscout.com/api"
  },
]
```

> 📌 Replace `PLACEHOLDER_API_KEY` with any non-empty string (required for Foundry).

## 📜 Key Functions

- `registerSeller()`
- `registerLogisticsProvider(address)`
- `createTrade(...)`
- `confirmDelivery(uint256)`
- `cancelTrade(uint256)`
- `raiseDispute(uint256)`
- `resolveDispute(uint256, address)`
- `withdrawEscrowFeesETH()`
- `withdrawEscrowFeesUSDT()`

## 🔐 Admin Controls

- Whitelist logistics providers
- Resolve disputes
- Withdraw fees

## 📄 License

MIT License

## 🤝 Contributing

Feel free to open issues or PRs. For questions, connect with the maintainer.

---

Let me know if you'd like to include a logo, badges (build, license, audit status), or a usage example with UI!