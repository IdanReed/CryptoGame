pragma solidity ^0.5.0;

import "./ItemTypes.sol";
import "./RecipeTypes.sol";
import "./CraftingManager.sol";

contract Game is ItemTypes, RecipeTypes, CraftingManager{

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

    mapping (address => Sector) sectors;

    function convertAddressToCordinate(address addressToConvert) private pure returns (SphereCordinate memory) {
        SphereCordinate memory cords;
        uint rightMask = (1 << 80) - 1;
        uint addressCasted = uint(addressToConvert);

        cords.xAngle = (addressCasted & ~rightMask) >> 80;
        cords.zAngle = addressCasted & rightMask;
        return cords;
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

    /**************************************************************
    Public ABI
    **************************************************************/
    function initializeNativeSector() public {
        Sector storage nativeSector = sectors[msg.sender];

        if (!nativeSector.initialized) {
            nativeSector.initialized = true;
            nativeSector.owner = msg.sender;
            nativeSector.cordinates = convertAddressToCordinate(nativeSector.owner);
        }
    }

    function buildPlaceable(address sectorAddress) public {

    }

    function tickSector(address sectorAddress) public {

    }

    /**************************************************************
    Public Views/Pure
    **************************************************************/
    function convertAddressToCordinateTuple(address addressToConvert) public pure returns (uint, uint){
        SphereCordinate memory cords = convertAddressToCordinate(addressToConvert);
        return (cords.xAngle, cords.zAngle);
    }

    function getSectorAttributes(address sectorAddress) public view returns (
        bool initialized,
        address owner,
        uint xAngle,
        uint zAngle ){

        Sector memory selSector = sectors[sectorAddress];

        return (
            selSector.initialized,
            selSector.owner,
            selSector.cordinates.xAngle,
            selSector.cordinates.zAngle
        );
    }

}