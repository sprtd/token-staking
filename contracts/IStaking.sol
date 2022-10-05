// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IStaking {
    /// @notice Emitted whenever mUSDT is staked
    /// @param staker address of the staker
    /// @param amount The amount of mUSDT stake
    event Stake(address staker, uint256 amount);

    /// @notice Emitted whenever mUSDT is staked
    /// @param staker address of the staker
    /// @param amount The amount of mUSDT stake
    event Unstake(address staker, uint256 amount);

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




}
