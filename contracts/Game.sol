pragma solidity ^0.5.0;

contract Game {
    constructor() public { }

    /**************************************************************
    Crafting map
    **************************************************************/
    struct ExtractorPros{
        uint what;
    }
    enum ItemType{
        NaturalReasource,
        AttackPower,
        Component,
        Placeable
    }

    struct ItemProperties{
        uint backupItemId;

        ItemType itemType;
        uint weight;
        uint volume;

        ExtractorPros extractor;
    }
    ItemProperties[] items;

    struct RecipeElement{
        uint itemId;
        uint quantity;
    }
    struct Recipe{
        bool valid;
        RecipeElement[] inputIds;
        RecipeElement[] outputIds;
    }
    Recipe[] recipes;

    function getItemProperties(uint itemI) private returns (ItemProperties memory) {

    }

    function craft(uint recipeId) public {

    }

    /**************************************************************
    Sector
    **************************************************************/
    struct SectorPlaceable {
        ItemReference itemReference;

        uint spaceRequired;
    }


    /**************************************************************
    Silo
    **************************************************************/
    struct Silo {
        SectorPlaceable placeableData;

        ItemReference storedItemReference;
        uint quantity;
    }

    /**************************************************************
    Extractor
    **************************************************************/
    struct Extractor {
        SectorPlaceable placeableData;

        uint targetRecipe;
    }

    /**************************************************************
    Extractor
    **************************************************************/
    struct Factory {
        SectorPlaceable placeableData;

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

    //         Extractor storage selExtractor = selSector.extractors[extractorIndex];
    //         selExtractor.testVal = true;
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