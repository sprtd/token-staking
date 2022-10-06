# Staking Contract

Staking contract allows users to deposit `mUSDT` in return for `rToken` as rewards. Each staker earns `rToken` prorata the size of their `mUSDT` stake to the total amount of `mUSDT` stake

#### Reward Token Calculation

`rToken` is emitted as reward per hour and is calculated thus:

```
    amountStakedPerUser/totalAmountStakedInPool * rToken
```
