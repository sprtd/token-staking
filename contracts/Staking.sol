// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error StakeAddressError();
error StakeAmountError();

contract Staking is Ownable {
    IERC20 public stakeToken;

    mapping(address => uint256) public stakes;

    event Stake(address staker, uint256 amount);

    /**
     * @dev instantiate contract with stakeToken address
     * @param _stakeToken address of specific stake asset
     */
    constructor(IERC20 _stakeToken) {
        stakeToken = _stakeToken;
    }

    /**
     * @dev allows anyone to deposit stake tokens to the contract
     * @param _stakeToken address of specific stake asset
     * @param _amount amount of token to be staked
     */

    function stake(address _stakeToken, uint256 _amount) external {
        if (address(stakeToken) != _stakeToken) revert StakeAddressError();
        if (_amount == 0) revert StakeAmountError();
        stakes[msg.sender] += _amount;
        emit Stake(msg.sender, _amount);
    }
}
