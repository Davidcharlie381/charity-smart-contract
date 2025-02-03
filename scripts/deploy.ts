import { ethers } from "hardhat";

const ONE_GWEI: bigint = 1_000_000_000n;

async function main() {
  const Charity = await ethers.getContractFactory("Charity");

  const target = ONE_GWEI;
  const goal = "The goal is one gwei";

  const charity = await Charity.deploy(target, goal);
  await charity.waitForDeployment();

  console.log(`Greeting deployed to: ${await charity.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
