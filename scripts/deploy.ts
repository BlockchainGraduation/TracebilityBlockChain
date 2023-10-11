import { ethers } from "hardhat";

async function main() {
  const supplychain = await ethers.deployContract("SupplyChain");
  
  await supplychain.waitForDeployment();
  console.log("Contract deployed at:", supplychain.getAddress());
  console.log("target: ", supplychain.target)
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
