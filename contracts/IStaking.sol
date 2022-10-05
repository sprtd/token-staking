// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IStaking {
    /// @notice Emitted whenever mUSDT is staked
    /// @param staker address of the staker
    /// @param amount The amount of mUSDT stake
    event Stake(address staker, uint256 amount);

    /// @dev Reverts if unsupported token is staked
    error StakeTokenAddressError();

    /// @dev Reverts if stake amount is 0
    error StakeAmountError();
}
