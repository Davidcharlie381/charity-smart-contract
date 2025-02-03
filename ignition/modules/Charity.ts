// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ONE_GWEI: bigint = 1_000_000_000n;

export default buildModule("CharityModule", (m) => {
  const target = m.getParameter("target", ONE_GWEI);
  const goal = m.getParameter("goal", "The goal is 1 billion gwei");

  const charity = m.contract("Charity", [target, goal]);
  return { charity };
});
