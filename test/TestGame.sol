pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Game.sol";

contract TestGame {
    Game game = Game(DeployedAddresses.Game());
    uint public initialBalance = 10 ether;


    function testFunction_convertAddressToCordinateTuple() public {

        uint x;
        uint z;

        address testAddress = address(
            (1 << 159) +
            (1 << 79)
        );

        (x, z) = game.convertAddressToCordinateTuple(testAddress);
        Assert.equal(
            x,
            z,

            "Verify that cordinate xAngle and zAngle are equal");
        Assert.notEqual((x+z), 0, "Verify that cordinate xAngle and zAngle are not zero");
    }

    function testFunction_initializeNativeSector() public {
        game.initializeNativeSector();

        (   bool initialized,
            address owner,
            uint xAngleInit,
            uint zAngleInit
        ) = game.getSectorAttributes(address(this));

        (   uint xAngleConverted,
            uint zAngleConverted
        ) = game.convertAddressToCordinateTuple(address(this));

        Assert.equal(initialized, true, "Verify that native sector is initialized");
        Assert.equal(owner, address(this), "Verify that the native sector owner is the test contract");

        Assert.equal(xAngleInit, xAngleConverted, "Verify initialized xAngle matches a direct conversion");
        Assert.equal(zAngleInit, zAngleConverted, "Verify initialized xAngle matches a direct conversion");
    }

    /**
    This function simulates the external calls that would be made to add
    production recipies.
    The idea is for JSON to be read and make these calls like they are here
    now
    */
    function setupRoutine_addTransformations() private {
        game.addItem(1, 0);
        game.addItem(2, 1);
        game.addTransformation();
        game.addTransformationElement(true, 0, 1);
        game.addTransformationElement(false, 1, 2);
    }

    function testSetupRoutine_addTransformations() public {
        setupRoutine_addTransformations();

        (   uint itemCount,
            uint recipeCount
        ) = game.getProductionMapRanges();

        Assert.equal(
            itemCount,
            2,
            "Verify that item count equals expected."
        );
        Assert.equal(recipeCount, 1, "verify that recipe count equals expected.");

        (   uint density,
            uint itemType
        ) = game.getItemProperties(0);

        Assert.equal(density, 1, "Item 1 property density equals expected.");
        Assert.equal(itemType, 0, "Item 1 property itemType equals expected.");

        (   density,
            itemType
        ) = game.getItemProperties(1);

        Assert.equal(density, 2, "Item 2 property density equals expected.");
        Assert.equal(itemType, 1, "Item 2 property itemType equals expected.");

        // game.getRecipeProperties(0);

        (   uint inputCounts,
            uint[50] memory inputItemIds,
            uint[50] memory inputQuantities,

            uint outputCounts,
            uint[50] memory outputItemIds,
            uint[50] memory outputQuantities
        ) = game.getTransformationProperties(0);

        Assert.equal(inputCounts, 1, "Item 2 property density equals expected.");
        Assert.equal(outputCounts, 1, "Item 2 property density equals expected.");

        Assert.equal(inputItemIds[0], 0, "Item 2 property density equals expected.");
        Assert.equal(inputQuantities[0], 1, "Item 2 property density equals expected.");

        Assert.equal(outputItemIds[0], 1, "Item 2 property density equals expected.");
        Assert.equal(outputQuantities[0], 2, "Item 2 property density equals expected.");
    }

    function testFunction_manualTransformation() public {
        bool status = game.manualTransformation(address(this), 0);
        Assert.equal(status, true, "");
    }

}