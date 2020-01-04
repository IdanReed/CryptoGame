const Game = artifacts.require('Game.sol');
const GameLib = artifacts.require('GameLib.sol');

module.exports = function (deployer) {
    deployer.deploy(GameLib).then(() => {
        deployer.link(GameLib, Game);
        return deployer.deploy(Game);
    });
};