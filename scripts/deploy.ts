import { ethers } from "hardhat";

async function main() {
  const actorManager = await ethers.deployContract("ActorManager");

  await actorManager.waitForDeployment();
  console.log("Contract deployed at:", actorManager.getAddress());
  console.log("target: ", actorManager.target)

  const ad_actor = actorManager.target;

  const productManager = await ethers.deployContract("ProductManager", [ad_actor]);

  await productManager.waitForDeployment();
  console.log("Contract deployed at:", productManager.getAddress());
  console.log("target: ", productManager.target)

  const ad_product = productManager.target;

  const supplyChain = await ethers.deployContract("SupplyChain", [ad_actor, ad_product]);

  await supplyChain.waitForDeployment();
  console.log("Contract deployed at:", supplyChain.getAddress());
  console.log("target: ", supplyChain.target)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
