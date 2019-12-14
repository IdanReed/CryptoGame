pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Game.sol";

contract TestGame {
    Game game = Game(DeployedAddresses.Game());
    uint public initialBalance = 10 ether;

    /**
    This function must run first. Other tests are dependent on the setup state
    */
    function testSetupRoutine_addTransformations() public {
        setupRoutine_addTransformations();
    }


    /**
    This function simulates the external calls that would be made to add
    production transformations.
    The idea is for JSON to be read and make these calls like they are here
    now
    */
    function setupRoutine_addTransformations() private {

        game.addItem(
            0,
            3, /* placeable */
            1  /* silo */
        );
        game.addSiloProperties(2, 100);

        game.addItem(
            1,
            3, /* placeable */
            1  /* silo */
        );
        game.addSiloProperties(3, 100);

        game.addItem(
            2,
            2, /* component */
            1  /* standard */
        );

        game.addItem(
            3,
            2, /* component */
            1  /* standard */
        );

        game.addItem(
            4,
            3, /* placeable */
            3  /* Assembler */
        );
        game.addAssemblerProperties(4);

        for(uint i = 5; i < 10; i++){
            game.addItem(
                i,
                1, /* NaturalResource */
                1  /* Standard */
            );
        }

        game.addItem(
            10,
            3, /* placeable */
            2  /* Extractor */
        );
        game.addExtractorProperties(4);

        game.addTransformation(0); // free silo 0
        game.addTransformationElement(false, 0, 1);

        game.addTransformation(1); // free silo 1
        game.addTransformationElement(false, 1, 1);

        game.addTransformation(2); // free component 2
        game.addTransformationElement(false, 2, 75);

        game.addTransformation(3); // component 2 -> assembler 4
        game.addTransformationElement(true, 2, 25);
        game.addTransformationElement(false, 4, 1);

        game.addTransformation(4); // component 2 + assembler -> component 3
        game.addTransformationElement(true, 2, 25);
        game.addTransformationElement(true, 4, 1);
        game.addTransformationElement(false, 3, 1);

        game.addTransformation(5); // natRes 5 -> natRes 5 in silo
        game.addTransformationElement(true, 5, 1);
        game.addTransformationElement(false, 5, 1);
    }

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
        Assert.notEqual(
            (x+z),
            0,
            "Verify that cordinate xAngle and zAngle are not zero");

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

        Assert.equal(
            initialized,
            true,
            "Verify that native sector is initialized"
        );
        Assert.equal(
            owner,
            address(this),
            "Verify that the native sector owner is the test contract"
        );

        Assert.equal(
            xAngleInit,
            xAngleConverted,
            "Verify initialized xAngle matches a direct conversion"
        );
        Assert.equal(
            zAngleInit,
            zAngleConverted,
            "Verify initialized xAngle matches a direct conversion"
        );

    }

    function testFunction_manualTransformation() public {
        bool successful = true;

        // free silo 0 for component 2
        successful = game.manualTransformation(address(this), 0)
            ? successful : false;

        // free silo 0 for component 2
        successful = game.manualTransformation(address(this), 1)
            ? successful : false;

        // free component 2
        successful = game.manualTransformation(address(this), 2)
            ? successful : false;

        // component 2 -> assembler 4
        successful = game.manualTransformation(address(this), 3)
            ? successful : false;

        // component 2 + assembler -> component 3
        successful = game.manualTransformation(address(this), 4)
            ? successful : false;

        Assert.equal(
            true,
            successful,
            "Verify all transformations were successful"
        );

        (   uint[] memory itemIds,
            uint[] memory itemQuantities
        ) = game.getSectorSilos(address(this));

        Assert.equal(
            itemIds.length,
            2,
            "Verify that number of silos matches expected"
        );
        Assert.equal(
            itemIds[0],
            2,
            "Verify that first silo stores component 2"
        );
        Assert.equal(
            itemIds[1],
            3,
            "Verify that second silo stores component 3"
        );
        Assert.equal(
            itemQuantities[0],
            25,
            "Verify that remaining component 2 matches expected"
        );
        Assert.equal(
            itemQuantities[1],
            1,
            "Verify that remaining component 3 matches expected"
        );
    }

    function testFunction_tickSector() public {
        game.tickSector(address(this));

        (   uint[] memory itemIds,
            uint[] memory itemQuantities
        ) = game.getSectorSilos(address(this));

        Assert.equal(
            itemIds.length,
            2,
            "Verify that number of silos matches expected"
        );
        Assert.equal(
            itemIds[0],
            2,
            "Verify that first silo stores component 2"
        );
        Assert.equal(
            itemIds[1],
            3,
            "Verify that second silo stores component 3"
        );
        Assert.equal(
            itemQuantities[0],
            0,
            "Verify that remaining component 2 matches expected"
        );
        Assert.equal(
            itemQuantities[1],
            2,
            "Verify that remaining component 3 matches expected"
        );
    }


    function testFunction_manualTransformationFailCase() public {

        (   uint[] memory itemIds1,
            uint[] memory itemQuantities1
        ) = game.getSectorSilos(address(this));

        bool rtn = game.manualTransformation(address(this), 3);

        Assert.equal(
            rtn,
            false,
            "Verify that the transformation was unsuccessful."
        );

        (   uint[] memory itemIds2,
            uint[] memory itemQuantities2
        ) = game.getSectorSilos(address(this));

        Assert.equal(
            itemQuantities2[0],
            itemQuantities1[0],
            "Verify that the sector's component 2 stored counts match."
        );
    }


}