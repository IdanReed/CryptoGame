pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/Game.sol";
import "../contracts/GameLib.sol";
import "../contracts/Components.sol";

contract TestGame {

    //GameLib gameLib = gameLib(DeployedAddresses.gameLib());
    Game game = Game(DeployedAddresses.Game());
    //Components components = Components(DeployedAddresses.Components());

    function testFunction_testLib() public {
        GameLib.Sector memory sector;
        sector.components = new ComponentIntf[](1);

        CompDefault comp = new CompDefault();
        sector.components[0] = comp;

        bool rtn = sector.components[0].store(sector);
        Assert.equal(rtn, true, "");
    }
}