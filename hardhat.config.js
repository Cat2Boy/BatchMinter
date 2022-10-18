require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-ethers");
require("hardhat-gas-reporter");

/** @type import('hardhat/config').HardhatUserConfig */
const ALCHEMY_ID = "";
const INFURA_ID = '';
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.7"
      },
      {
        version: "0.8.0"
      },
      {
        version: "0.7.0",
      }
    ]
  },
  gasReporter: {
    enabled:true
  },
  networks:{
    ganache:{
      url:'http://127.0.0.1:7545'
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_ID}`,
      accounts: [`0x${RINKEBY_PRIVATE_KEY}`]
    },
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_ID}`,
      accounts: [`0x${RINKEBY_PRIVATE_KEY}`],
    }, 
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat:{
      forking:{
        url:`https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_ID}`
      },
    },
  }
  
};

