const Game = artifacts.require('Game.sol');
const GameLib = artifacts.require('GameLib.sol');
//const Components = artifacts.require('Components.sol');

module.exports = function (deployer) {

    // deployer.deploy(GameLib).then(() => {
    //     deployer.link(GameLib, Game);
    //     deployer.deploy(CompFuncs);
    //     return deployer.deploy(Game);
    // });

    deployer.deploy(GameLib);
    deployer.link(GameLib, [Game, Components]);
    //deployer.deploy(Components);
    deployer.deploy(Game);
};