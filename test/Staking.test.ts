import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";

import { parseEther, formatEther } from "ethers/lib/utils";

import { ethers } from "hardhat";
const toAddr1 = "10000";

describe("Staking Contract Test Suite", async () => {
  const fromWei = ethers.utils.formatEther;
  const toWei = ethers.utils.parseEther;

  // test constants
  const MUSDT_TOTAL_SUPPLY = parseEther("100000000");
  const R_TOKEN_TOTAL_SUPPLY = parseEther("100000");

  let mUSDT: any,
    rToken: any,
    staking: any,
    stakingMUSDTBalance: any,
    owner: any,
    addr1: any,
    sendRTokenToStakingTxn,
    rTokenToStaking;

    beforeEach(async () => {
      [owner, addr1] = await ethers.getSigners();
      // mock usdt contract instance
      const MockUSDT = await ethers.getContractFactory("MockUSDT");
      mUSDT = await MockUSDT.deploy(MUSDT_TOTAL_SUPPLY);
   
  
      // reward token contract instance
      const RewardToken = await ethers.getContractFactory("RewardToken");
      rToken = await RewardToken.deploy(R_TOKEN_TOTAL_SUPPLY);
   
  
      // staking contract instance
      const Staking = await ethers.getContractFactory("Staking");
      staking = await Staking.deploy(mUSDT.address, rToken.address);
  
      const sendRTokenToStakingTxn = await rToken.connect(owner).transfer(staking.address, R_TOKEN_TOTAL_SUPPLY);
      await sendRTokenToStakingTxn.wait();
  
  
      // owner transfers 10000 mUSDT tokens to addr1
      const transferMUSTToAddr1Txn = await mUSDT.connect(owner).transfer(addr1.address, parseEther(toAddr1));
      await transferMUSTToAddr1Txn.wait();

      stakingMUSDTBalance = await mUSDT.balanceOf(staking.address);
    })

  
  describe("Deployment", async () => {
    it("Should set the appropriate mUSDT total supply", async () => {
      console.log("staking balance", fromWei(stakingMUSDTBalance));
      expect(await mUSDT.totalSupply()).to.equal(MUSDT_TOTAL_SUPPLY);
    });

    it("Should set the appropriate rToken total supply", async () => {
      expect(await rToken.totalSupply()).to.equal(R_TOKEN_TOTAL_SUPPLY);
    });

    it("Should check successful transfer of all rTokens from owner to staking contract", async () => {
      expect(await rToken.balanceOf(staking.address)).to.equal(R_TOKEN_TOTAL_SUPPLY);
      expect(await rToken.balanceOf(owner.address)).to.equal("0");
    });

  });


});