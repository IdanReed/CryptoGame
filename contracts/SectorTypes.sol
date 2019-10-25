pragma solidity ^0.5.0;

contract SectorTypes{

    /**************************************************************
    Sector
    **************************************************************/
    struct SectorPlaceable {
        uint itemId;

        uint spaceRequired;
    }

    /**************************************************************
    Silo
    **************************************************************/
    struct Silo {
        SectorPlaceable placeableData;

        uint itemId;
        uint quantity;
    }

    /**************************************************************
    Extractor
    **************************************************************/
    struct Extractor {
        SectorPlaceable placeableData;

    }

    /**************************************************************
    Extractor
    **************************************************************/
    struct Factory {
        SectorPlaceable placeableData;

        uint targetRecipe;
    }

    /**************************************************************
    World
    **************************************************************/
    struct SphereCordinate{
        uint xAngle; /* address bits from 160 to 80 */
        uint zAngle; /* address bits from 80 to 0   */
    }

    struct Sector {
        bool initialized;

        address owner;
        SphereCordinate cordinates;
        uint lastTickBlock;

        /* Placeables       */
        Silo[] silos;
        Extractor[] extractors;
        Factory[] factories;
    }
    

    /**************************************************************
    Public Views/Pure
    **************************************************************/
    function convertAddressToCordinateTuple(address addressToConvert) public pure returns (uint xAngle, uint zAngle) {
        
        uint rightMask = (1 << 80) - 1;
        uint addressCasted = uint(addressToConvert);

        xAngle = (addressCasted & ~rightMask) >> 80;
        zAngle = addressCasted & rightMask;
        return (xAngle, zAngle);
    }
    // function tickExtractor(address sectorAddress, uint extractorIndex) public {
    //     Sector storage selSector = sectors[sectorAddress];

    //     if(
    //         selSector.initialized &&
    //         selSector.owner == msg.sender &&
    //         extractorIndex < selSector.extractors.length
    //         ) {

    //         //Extractor storage selExtractor = selSector.extractors[extractorIndex];
    //     }
    // }
}