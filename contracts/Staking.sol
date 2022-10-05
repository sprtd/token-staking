// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IStaking.sol";

contract Staking is Ownable, IStaking {
    IERC20 public stakeToken;
    IERC20 public rewardToken;

    uint256 public totalStakes;

    mapping(address => uint256) public stakes;

    /**
     * @dev instantiate contract with stakeToken address
     * @param _stakeToken address of specific stake asset
     */
    constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
        stakeToken = _stakeToken;
        rewardToken = _rewardToken;
    }

    /**
     * @dev allows anyone to deposit stake tokens to the contract
     * @param _stakeToken address of specific stake asset
     * @param _amount amount of token to be staked
     */

    function stake(address _stakeToken, uint256 _amount) external {
        //  revert if unsupported token is staked
        if (address(stakeToken) != _stakeToken) revert StakeTokenAddressError();

        // Reverts if stake amount is 0
        if (_amount == 0) revert StakeAmountError();

        // add to stakers stake amount
        stakes[msg.sender] += _amount;

        // add to existing total stakes
        totalStakes += _amount;

        // transfer mUSDT from staker to staking contract
        bool success = stakeToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        if (!success) revert StakeTransferError();

        // emit Stake
        emit Stake(msg.sender, _amount);
    }

    function unstake() external {
        uint256 withdrawAmount = stakes[msg.sender];
        if (withdrawAmount == 0)
            revert UnstakeError(msg.sender, withdrawAmount);
    }
}
