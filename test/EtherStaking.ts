const { expect } = require("chai");
import { ethers } from "hardhat";

describe("EtherStaking", function () {
  it("Check if owner was set succesfully", async function () {
    const [owner, otherAccount] = await ethers.getSigners();

    const EtherStaking = await ethers.deployContract("EtherStaking");

    expect( await EtherStaking.owner()).to.be.equal(owner);

    
  });

    it("Check if the ether was properly staked", async function () {
    const [owner, otherAccount] = await ethers.getSigners();

    const EtherStaking = await ethers.deployContract("EtherStaking");
    const theAmount = 12;

    expect( await EtherStaking.stake(theAmount)).to.be.equal(theAmount);

    
  });

});