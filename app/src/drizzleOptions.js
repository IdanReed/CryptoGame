import Web3 from "web3";
// import SimpleStorage from "./contracts/SimpleStorage.json";
// import ComplexStorage from "./contracts/ComplexStorage.json";
// import TutorialToken from "./contracts/TutorialToken.json";
import Game from "./contracts/Game.json";

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:8545"),
  },
  contracts: [Game],
  // events: {
  //   SimpleStorage: ["StorageSet"],
  // },
  // polls: {
  //   accounts: 1500,
  // },
};

// const options = {
//   contracts: [Game],
//   web3: {
//     fallback: {
//       type: "ws",
//       url: "ws://127.0.0.1:9545",
//     },
//   },
// };

export default options;
