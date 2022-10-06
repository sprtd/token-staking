// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "hardhat/console.sol";
import "./IStaking.sol";

contract Staking is IStaking, ReentrancyGuard {
    IERC20 public stakeToken;
    IERC20 public rewardToken;
    using SafeMath for uint256;

    uint256 public totalStakes;

    address public owner;
    mapping(address => uint256) public stakes;

    // REWARD VARS //
    uint256 public rewardDuration; // duration of rewards to be paid out

    uint256 public rewardFinishAt; // timestamp of the end of rewards

    uint256 public rewardUpdatedAt;

    uint256 public rewardRate; // reward to be paid per sec

    // Sum of (reward rate * dt * 1e18 / total supply)
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid; // staker => rewardPerTokenStored

    mapping(address => uint256) public rewardsToBeClaimed; // staker => rewards

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner(msg.sender);
        _;
    }

    /**
     * @dev instantiate contract with stakeToken and reward token addresses
     * @param _stakeToken address of stake tokens
     * @param _rewardToken address of the reward token
     */
    constructor(IERC20 _stakeToken, IERC20 _rewardToken) {
        stakeToken = _stakeToken;
        rewardToken = _rewardToken;
        owner = msg.sender;
    }

    /* ========== STATE_CHANGING FUNCTIONS ========== */

    /**
     * @dev allows anyone to deposit stake tokens to the contract
     * @param _stakeToken address of specific stake asset
     * @param _amount amount of token to be staked
     */
    function stake(address _stakeToken, uint256 _amount) external nonReentrant {
        //  revert if unsupported token is staked
        if (address(stakeToken) != _stakeToken) revert StakeTokenAddressError();

        // Reverts if stake amount is 0
        if (_amount == 0) revert StakeAmountError();

        // add to stakers stake amount
        stakes[msg.sender] = stakes[msg.sender].add(_amount);

        // add to existing total stakes
        totalStakes = totalStakes.add(_amount);

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

    /**
     * @dev allows only staker to withdraw mUSDT stake
     */
    function unstake() external nonReentrant  {
        uint256 unstakeAmount = stakes[msg.sender];
        if (unstakeAmount == 0) revert UnstakeError(msg.sender, unstakeAmount);

        // substract staker's current stake
        stakes[msg.sender] = stakes[msg.sender].sub(unstakeAmount);

        // deduct unstake amount from totalStakes
        totalStakes = totalStakes.sub(unstakeAmount);

        bool success = stakeToken.transfer(msg.sender, unstakeAmount);
        if (!success) revert UnstakeTransferError(msg.sender, unstakeAmount);

        emit Unstake(msg.sender, unstakeAmount);
    }

    function notifyRewardAmount(uint256 _amount) external onlyOwner {
        if(block.timestamp > rewardFinishAt) {
            rewardRate = _amount.div(rewardDuration);
            console.log("reward rate %s", rewardRate);
        } else {
            uint remainingRewards = rewardRate * (rewardFinishAt - block.timestamp);
            rewardRate = (remainingRewards.add(_amount)).div(rewardDuration);
        }
        if(rewardRate <= 0) revert RewardZero();
        if(rewardRate.mul(rewardDuration) >= rewardToken.balanceOf(address(this))) revert RewardGreaterThanRewardBalance();

        rewardFinishAt = block.timestamp.add(rewardDuration); 
        rewardUpdatedAt = block.timestamp;


    }

    function _updateReward(address _account) private {
        rewardPerTokenStored = rewardPerToken();
        rewardUpdatedAt = lastTimeRewardApplicable();
        if (_account != address(0)) {
            rewardsToBeClaimed[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
    }

    function setRewardDuration(uint256 _duration) external onlyOwner {
        if (rewardFinishAt >= block.timestamp)
            revert UnfinishedRewardDuration();
        rewardDuration = _duration;
    }

   

    /* ========== UTILITY FUNCTIONS ========== */
    function rewardPerToken() public view returns (uint256) {
        if (totalStakes == 0) return rewardPerTokenStored;

        uint256 _rewardPerToken = rewardPerTokenStored.add(
            lastTimeRewardApplicable()
                .sub(rewardUpdatedAt)
                .mul(rewardRate)
                .mul(1e18)
                .div(totalStakes)
        );
        console.log("reward per token %s", _rewardPerToken);

        return _rewardPerToken;
    }

    function earned(address _account) public view returns (uint256) {
        return
            stakes[_account]
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[_account]))
                .div(1e18)
                .add(rewardsToBeClaimed[_account]);
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return
            block.timestamp < rewardFinishAt ? block.timestamp : rewardFinishAt;
    }
}
