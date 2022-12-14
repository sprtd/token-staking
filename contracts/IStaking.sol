// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IStaking {

     /* ========== EVENTS ========== */
    /// @notice Emitted whenever mUSDT is staked
    /// @param staker address of the staker
    /// @param amount The amount of mUSDT stake
    event Stake(address staker, uint256 amount);

    /// @notice Emitted whenever mUSDT is staked
    /// @param staker address of the staker
    /// @param amount The amount of mUSDT stake
    event Unstake(address staker, uint256 amount);

    /// @notice Emitted whenever reward duration is set
    /// @param duration The amount of mUSDT stake
    /// @param timeInitiated The amount of mUSDT stake
    event RewardDurationSet(uint256 duration, uint256 timeInitiated);

    /// @notice Emitted whenever notifyRewardAmount is called and the initial reward rate is set
    /// @param rewardRate reward amount / reward duration
    /// @param rewardDuration period for which reward is valid
    event InitialRewardRate(uint256 rewardRate, uint256 rewardDuration);

    /* ========== CUSTOM ERRORS ========== */

    /// @dev Reverts if unsupported token is staked
    error StakeTokenAddressError();

    /// @dev Reverts if stake amount is 0
    error StakeAmountError();

    /// @dev Reverts if stake is not successfully transferred to contract
    error StakeTransferError();

    /// @dev Reverts if there is mismatch during stake unstaking
    error UnstakeError(address caller, uint256 amount);

    /// @dev Reverts if staker's mUSDT is not successfully transferred from staking contract to staker
    error UnstakeTransferError(address caller, uint256 amount);

    /// @dev Reverts if  msg.sender is not owner
    error OnlyOwner(address caller);

    /// @dev Reverts if reward duration is not finished
    error UnfinishedRewardDuration();

    /// @dev Reverts if reward rate == 0
    error RewardZero();

    /// @dev Reverts if current reward is greater than staking contract's reward token balance
    error RewardGreaterThanRewardBalance();

    /// @dev Reverts owner attempt to set 0 reward rate
    error ZeroRewardError();

    /// @dev Reverts owner attempt to set 0 reward duration
    error  ZeroRewardDuration();
}
