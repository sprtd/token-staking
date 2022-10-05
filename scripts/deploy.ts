import { ethers } from "hardhat";

const { utils: { formatEther, parseEther } } = ethers

const MUSDT_TOTAL_SUPPLY = parseEther("100000000");
const R_TOKEN_TOTAL_SUPPLY = parseEther("100000");

async function main() {

  // mUSDT token contract instance
  const MockUSDT = await ethers.getContractFactory("MockUSDT");
  const mUSDT = await MockUSDT.deploy(MUSDT_TOTAL_SUPPLY);

  await mUSDT.deployed()


   // reward token contract instance
   const RewardToken = await ethers.getContractFactory("RewardToken");
   const rToken = await RewardToken.deploy(R_TOKEN_TOTAL_SUPPLY);

  const Staking = await ethers.getContractFactory("Staking");
  const staking = await Staking.deploy(mUSDT.address, rToken.address);

  await staking.deployed();

  console.log(`Staking deployed to: ${staking.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
