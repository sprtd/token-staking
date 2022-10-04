import { ethers } from "hardhat";

const { utils: { formatEther, parseEther } } = ethers

async function main() {

  const MUSDT_TOTAL_SUPPLY = parseEther("100000000");

  const MockUSDT = await ethers.getContractFactory("MockUSDT");
  const mUSDT = await MockUSDT.deploy(MUSDT_TOTAL_SUPPLY);

  await mUSDT.deployed()

  const Staking = await ethers.getContractFactory("Staking");
  const staking = await Staking.deploy(mUSDT.address);

  await staking.deployed();

  console.log(`Staking deployed to: ${staking.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
