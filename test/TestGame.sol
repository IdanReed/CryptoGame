pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Game.sol";

contract TestGame {
    Game game = Game(DeployedAddresses.Game());
    uint public initialBalance = 10 ether;

    function testFunction_ConvertAddressToCordinateTuple() public {

        uint x;
        uint z;

        address testAddress = address(
            (1 << 159) +
            (1 << 79)
        );

        (x, z) = game.convertAddressToCordinateTuple(testAddress);
        Assert.equal(x, z, "Verify that cordinate xAngle and zAngle are equal");
        Assert.notEqual((x+z), 0, "Verify that cordinate xAngle and zAngle are not zero");
    }

    function testFunction_initializeNativeSector() public {
        game.initializeNativeSector();
        (
            bool initialized,
            address owner,
            uint xAngleInit,
            uint zAngleInit
        ) = game.getSectorAttributes(address(this));

        (
            uint xAngleConverted,
            ,
            uint zAngleConverted
        ) = game.convertAddressToCordinateTuple(address(this));

        Assert.equal(initialized, true, "Verify that native sector is initialized");
        Assert.equal(owner, address(this), "Verify that the native sector owner is the test contract");

        Assert.equal(xAngleInit, xAngleConverted, "Verify initialized xAngle matches a direct conversion");
        Assert.equal(zAngleInit, zAngleConverted, "Verify initialized xAngle matches a direct conversion");
    }
}