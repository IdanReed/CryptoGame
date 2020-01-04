pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Game.sol";
import "../contracts/GameLib.sol";

contract TestGame {
    Game game = Game(DeployedAddresses.Game());

    function testFunction_testLib() public {
        game.testLib();
    }
}