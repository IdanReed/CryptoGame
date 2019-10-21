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
            uint zAngleConverted
        ) = game.convertAddressToCordinateTuple(address(this));

        Assert.equal(initialized, true, "Verify that native sector is initialized");
        Assert.equal(owner, address(this), "Verify that the native sector owner is the test contract");

        Assert.equal(xAngleInit, xAngleConverted, "Verify initialized xAngle matches a direct conversion");
        Assert.equal(zAngleInit, zAngleConverted, "Verify initialized xAngle matches a direct conversion");
    }

    function setupRoutine_addRecipes() private {
        game.addItem(1, 0);
        game.addItem(2, 1);
        //game.addRecipe();
        game.addRecipeElement(true, 0, 1);
        game.addRecipeElement(false, 1, 2);
    }

    function testSetupRoutine_addRecipes() public {
        setupRoutine_addRecipes();

        (
            uint itemCount,
            uint recipeCount
        ) = game.getCraftingMapRanges();

        Assert.equal(itemCount, 2, "Verify that item count equals expected.");
        Assert.equal(recipeCount, 1, "verify that recipe count equals expected.");

        (
            uint density,
            uint itemType
        ) = game.getItemProperties(0);

        Assert.equal(density, 1, "Item 1 property density equals expected.");
        Assert.equal(itemType, 0, "Item 1 property itemType equals expected.");

        (
            density,
            itemType
        ) = game.getItemProperties(1);

        Assert.equal(density, 2, "Item 2 property density equals expected.");
        Assert.equal(itemType, 1, "Item 2 property itemType equals expected.");

        (
            uint[] memory inputItemIds,
            uint[] memory inputQuantities,
            uint[] memory outputItemIds,
            uint[] memory outputQuantities
        ) = game.getRecipeProperties(1);

        // Assert.equal(inputItemIds.length, 1, "Item 2 property density equals expected.");
        // Assert.equal(inputQuantities.length, 1, "Item 2 property density equals expected.");
        // Assert.equal(outputItemIds.length, 1, "Item 2 property density equals expected.");
        // Assert.equal(outputQuantities.length, 1, "Item 2 property density equals expected.");

    }
}