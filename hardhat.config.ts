import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  networks:{
    sepolia: {
      url: 'https://virulent-convincing-surf.ethereum-sepolia.discover.quiknode.pro/38556d84c31834f53f8ec7feac5ddac1edf16e6c/',
      accounts: [
        'df57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e'
      ]
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