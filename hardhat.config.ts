import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  // defaultNetwork: ,
  networks: {
    sepolia: {
      url: process.env.ARBITRUM_SEPOLIA,
      accounts: [process.env.PRIVATE_KEY!],
    }
  }
};

export default config;
