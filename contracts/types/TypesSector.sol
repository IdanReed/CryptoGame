pragma solidity ^0.5.0;

import "./TypesItem.sol";

/**
TypesSector contract:
    is for the structs resposible for holding the data about a sector.
    It also contains processing for sector level actions.
*/
contract TypesSector is TypesItem{
    struct PlaceableProperties {
        uint itemId;

        uint spaceRequired;
    }
    struct Silo {
        PlaceableProperties placeableProps;

        uint itemId;
        uint quantity;
    }
    struct Extractor {
        PlaceableProperties placeableProperties;

    }
    struct Factory {
        PlaceableProperties placeableProperties;

        uint targetRecipe;
    }
    struct SphereCordinate{
        uint xAngle; /* address bits from 160 to 80 */
        uint zAngle; /* address bits from 80 to 0   */
    }
    struct ExtractionProperties{
        uint depth;
        uint heat;
        uint surroundingHardness;
    }
    struct NaturalResource{
        ExtractionProperties extractionProperties;
        uint itemId;
        uint quantity;
    }
    struct Sector {
        bool initialized;

        address owner;
        SphereCordinate cordinates;
        uint lastTickBlock;

        NaturalResource[] naturalResources;

        /* Placeables       */
        Silo[] silos;
        Extractor[] extractors;
        Factory[] factories;
    }
    /**************************************************************
    Internal
    **************************************************************/
    /**
    - When sectors are nativly initialize or taken for the first time via
    confict they need to have their natural properties set. Must be done
    algorithmically.
    - Assumes owner is previously set
    */
    function initializeSector(
        Sector memory sector,
        address sectorAddress /* the key in the address -> sector map */
    )
    internal {
        require(
            !sector.initialized,
            "Require that given sector has not been initialized"
        );
        require(
            sector.owner != address(0),
            "Require that given sector has set owner"
        );

        (   uint xAngle,
            uint zAngle
        ) = convertAddressToCordinateTuple(sectorAddress);

        sector.cordinates = SphereCordinate(xAngle, zAngle);

        initializeSectorNaturalResources(sector);
    }
    function initializeSectorNaturalResources(
        Sector memory sector
    ) private view {

    }
    function consumeResource(
        Sector memory sector,
        ItemType itemType,
        uint itemId,
        uint quantityIn
    )
    internal pure returns (
            bool successful
    ){
        uint quantity = quantityIn;

        if(itemType == ItemType.NaturalResource){
            /* Check nat res arr */
            for(
                uint i = 0;
                i < sector.naturalResources.length && quantity > 0;
                i++
            ){
                if(itemId == sector.naturalResources[i].itemId){
                    if(quantity < sector.naturalResources[i].quantity){
                        sector.naturalResources[i].quantity -= quantity;
                        quantity = 0;
                    }else{
                        quantity -= sector.naturalResources[i].quantity;
                        sector.naturalResources[i].quantity = 0;
                    }
                }
            }
        }else{
            /* Check silos */
            for(
                uint i = 0;
                i < sector.silos.length && quantity > 0;
                i++
            ){
                if(itemId == sector.silos[i].itemId){
                    if(quantity < sector.silos[i].quantity){
                        sector.silos[i].quantity -= quantity;
                        quantity = 0;
                    }else{
                        quantity -= sector.silos[i].quantity;
                        sector.silos[i].quantity = 0;
                    }
                }
            }
        }
        return (quantity == 0);
    }
    function storeResource(
        Sector memory sector,
        ItemType itemType,
        uint itemId,
        uint quantity
    )
    internal returns(
        bool successful
    ){

    }

    /**************************************************************
    Public Views/Pure
    **************************************************************/
    function convertAddressToCordinateTuple(
        address addressToConvert
    )
    public pure returns(
        uint xAngle, uint zAngle
    ){
        uint rightMask = (1 << 80) - 1;
        uint addressCasted = uint(addressToConvert);

        xAngle = (addressCasted & ~rightMask) >> 80;
        zAngle = addressCasted & rightMask;
        return (xAngle, zAngle);
    }
}