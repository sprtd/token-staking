// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDT is ERC20 {
    
    constructor(uint256 initialSupply) ERC20("MockUSDT", "mUSDT") {
        _mint(msg.sender, initialSupply);
    }
}