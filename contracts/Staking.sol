// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IStaking.sol";



contract Staking is Ownable, IStaking {
    IERC20 public stakeToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public stakes;

    /**
     * @dev instantiate contract with stakeToken address
     * @param _stakeToken address of specific stake asset
     */
    constructor(IERC20 _stakeToken,  IERC20 _rewardToken) {
        stakeToken = _stakeToken;
        rewardToken = _rewardToken; 
    }

    /**
     * @dev allows anyone to deposit stake tokens to the contract
     * @param _stakeToken address of specific stake asset
     * @param _amount amount of token to be staked
     */

    function stake(address _stakeToken, uint256 _amount) external {
        if (address(stakeToken) != _stakeToken) revert StakeTokenAddressError();
        if (_amount == 0) revert StakeAmountError();
        stakes[msg.sender] += _amount;
        emit Stake(msg.sender, _amount);
    }
}
