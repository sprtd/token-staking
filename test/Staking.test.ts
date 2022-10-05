import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import { expect } from "chai";

import { parseEther, formatEther } from "ethers/lib/utils";

import { ethers } from "hardhat";
const toAddr1 = "10000";

describe("Staking Contract Test Suite", async () => {


  // test constants
  const MUSDT_TOTAL_SUPPLY = parseEther("100000000");
  const R_TOKEN_TOTAL_SUPPLY = parseEther("100000");

  let mUSDT: any,
    rToken: any,
    staking: any,
    stakingMUSDTBalance: any,
    owner: SignerWithAddress,
    addr1: SignerWithAddress,
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

    // deployer transfers all rTokens to staking
    const sendRTokenToStakingTxn = await rToken.connect(owner).transfer(staking.address, R_TOKEN_TOTAL_SUPPLY);
    await sendRTokenToStakingTxn.wait();


    // owner transfers 10000 mUSDT tokens to addr1
    const transferMUSTToAddr1Txn = await mUSDT.connect(owner).transfer(addr1.address, parseEther(toAddr1));
    await transferMUSTToAddr1Txn.wait();
  })


  describe("Deployment", async () => {
    it("Should set the appropriate mUSDT total supply", async () => {
      expect(await mUSDT.totalSupply()).to.equal(MUSDT_TOTAL_SUPPLY);
    });

    it("Should set the appropriate rToken total supply", async () => {
      expect(await rToken.totalSupply()).to.equal(R_TOKEN_TOTAL_SUPPLY);
    });

    it("Should transfer all rTokens from deploer to staking contract", async () => {
      expect(await rToken.balanceOf(staking.address)).to.equal(R_TOKEN_TOTAL_SUPPLY);
      expect(await rToken.balanceOf(owner.address)).to.equal("0");
    });

    it("Should transfer 10000 mUSDT from deployer to addr1", async () => {
      expect(await mUSDT.balanceOf(addr1.address)).to.equal(parseEther(toAddr1));
    });


  });

  describe("Transactions", async () => {
    describe("Staking Validations", async () => {
      it("Should revert an attempt to non-mUSDT", async () => {
        expect(staking.connect(addr1).stake(rToken.address, parseEther("100"))).to.be.reverted;
        expect(staking.connect(addr1).stake(rToken.address, parseEther("100"))).to.be.revertedWith("StakeTokenAddressError();")
      });

    })
  })


});