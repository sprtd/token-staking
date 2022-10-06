# Staking Contract

Staking contract allows users to deposit `mUSDT` in return for `rToken` as rewards. Each staker earns `rToken` pro rata the size of their `mUSDT` stake in relation to the total amount of `mUSDT` staked per time

#### Reward Token Calculation

`rToken` is emitted as reward per hour and is calculated thus:

```bash
amountStakedPerUser/totalAmountStakedInPool * rToken
```


#### Tests


To test `Staking` contract, simply run:

```bash
npm run test
```
