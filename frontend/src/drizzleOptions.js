import Web3 from "web3";

import Game from "./contracts/Game.json";

const options = {
    contracts: [Game],
    web3: {
      fallback: {
        type: "ws",
        url: "ws://127.0.0.1:9545",
      },
    },
};

export default options;