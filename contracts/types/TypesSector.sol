pragma solidity ^0.5.0;

contract TypesSector{
    struct SectorPlaceable {
        uint itemId;

        uint spaceRequired;
    }
    struct Silo {
        SectorPlaceable placeableData;

        uint itemId;
        uint quantity;
    }
    struct Extractor {
        SectorPlaceable placeableData;

    }
    struct Factory {
        SectorPlaceable placeableData;

        uint targetRecipe;
    }
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
    Internal - production utils
    **************************************************************/
    function consume(Sector memory sector, uint itemId, uint quantity) internal returns (
        bool successful,
        Sector memory newSector
    ){

    }
    function store(Sector memory sector, uint itemId, uint quantity) internal returns (
        bool successful,
        Sector memory newSector
    ){

    }

    /**************************************************************
    Public Views/Pure - type utils
    **************************************************************/
    function convertAddressToCordinateTuple(address addressToConvert) public pure returns (uint xAngle, uint zAngle) {
        uint rightMask = (1 << 80) - 1;
        uint addressCasted = uint(addressToConvert);

        xAngle = (addressCasted & ~rightMask) >> 80;
        zAngle = addressCasted & rightMask;
        return (xAngle, zAngle);
    }
}