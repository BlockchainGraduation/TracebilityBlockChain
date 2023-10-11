import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  defaultNetwork: "testnet",
  networks: {
    testnet: {
      url: "https://ethereum-sepolia.blockpi.network/v1/rpc/public", //3s cho 1 transaction
      chainId: 11155111,
      gasPrice: 10000000000,
      accounts: ['24045d471ee28f805d1058b6a68307d2faa71fa7b9ff5f9441c1d67259d151c4'] 
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.19",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          },
          // allowUnlimitedContractSize: true
        }  
      }
    ]
  }
}

export default config;