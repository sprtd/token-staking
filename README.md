# Staking Contract

Staking contract allows users to deposit `mUSDT` in return for `rToken` as rewards. Each staker earns `rToken` pro rata the size of their `mUSDT` stake to the total amount of `mUSDT` stake per time

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
