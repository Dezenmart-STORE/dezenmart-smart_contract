// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Dezenmart is ERC20, Ownable {
    constructor() ERC20("usdt", "USDT") Ownable(msg.sender) {
        _mint(msg.sender, 1000000000 ether); // Mint 10,000 tokens with 18 decimals
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}