import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  defaultNetwork: "testnet",
  networks: {
    testnet: {
      url: "https://goerli-rollup.arbitrum.io/rpc", //3s cho 1 transaction
      chainId: 421613,
      gasPrice: 5000000000,
      accounts: ['2bd81d7cace245abc1a7e981075332251823b56a136c0154187cd8a0746ed84a'] 
    }
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100,
      },
      viaIR: true,
    },
  },
}

export default config;