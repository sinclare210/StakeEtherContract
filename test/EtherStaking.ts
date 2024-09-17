import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre, { ethers } from "hardhat";


describe("EtherStaking", function(){

  async function deployEtherStaking() {
  

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await hre.ethers.getSigners();
    

    const  EtherStaking = await hre.ethers.getContractFactory("EtherStaking");
    const etherStaking = await EtherStaking.deploy();

    return {etherStaking,owner, otherAccount};
  }

     describe("Deployment", function () {
    it("should set the correct owner", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);
    

      expect (await etherStaking.owner()).to.be.equal(owner);
    });
  });

    describe("viewUsersStaked", function () {
    it("should return the total amount staked", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("5.0")
    
      await etherStaking.connect(owner).stake(5, {value:amountToStake});

    
       expect (await etherStaking.viewUsersStake(owner)).to.be.equal(5000000000000000000n);
      
    });

     it("should revert wehn called by another account", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("5.0")
    
      await etherStaking.connect(owner).stake(5, {value:amountToStake});

    
       expect (await etherStaking.viewUsersStake(otherAccount)).to.be.reverted;
      
    });
  });

  describe("totalStaked", function () {
    it("should return the total amount staked", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("0.000001")
    
      await etherStaking.connect(owner).stake(1, {value:amountToStake});
      await etherStaking.connect(otherAccount).stake(1, {value:amountToStake});

     expect (await etherStaking.viewTotalStaked()).to.be.equal(2000000000000)
      
    });

  });

  describe("stake", function () {
    it("should revert if user try to stake zero", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("0")
    
     

     await expect ( etherStaking.connect(owner).stake(1,{value:amountToStake})).to.be.revertedWithCustomError(etherStaking, "CantStakeZero");
      
    });

    it("should revert user has stake", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("1")
    
     

     await ( etherStaking.connect(owner).stake(1,{value:amountToStake}));
      await expect ( etherStaking.connect(owner).stake(1,{value:amountToStake})).to.be.revertedWithCustomError(etherStaking, "AlreadyStaked");
     

      
    });

     it("check if user amount succefully updated", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("1")
    
     

     await ( etherStaking.connect(owner).stake(1,{value:amountToStake}));
     expect ((await etherStaking.stakers(owner)).amount).to.be.equal(1000000000000000000n);
     
     

      
    });

    it("set useer to true", async function () {
      const [owner, otherAccount] = await hre.ethers.getSigners();
      const {etherStaking} = await loadFixture(deployEtherStaking);

      const amountToStake = ethers.parseEther("1")
    
     

     await ( etherStaking.connect(owner).stake(1,{value:amountToStake}));
     expect ((await etherStaking.stakers(owner)).stillStaked).to.be.equal(true);
     
     

      
    });

  });


});