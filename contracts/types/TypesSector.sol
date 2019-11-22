pragma solidity ^0.5.0;

import "./TypesItem.sol";

/**
TypesSector contract:
    is for the structs resposible for holding the data about a sector.
    It also contains processing for sector level actions.
*/
contract TypesSector is TypesItem{

    struct NaturalResource{
        uint itemId;
        uint quantity;
        uint difficulty;
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

        NaturalResource[] naturalResources;

        /* Placeables       */
        SiloItem[] silos;
        ExtractorItem[] extractors;
        AssemblerItem[] assemblers;
    }
    /**************************************************************
    Internal
    **************************************************************/

    /**
    - When sectors are nativly initialize or taken for the first time via
    confict they need to have their natural properties set. Must be done
    algorithmically.
    */
    function initializeSector(
        Sector storage sector,
        address owner, /* the new owner */
        address sectorAddress /* the key in the address -> sector map */
    )
    internal {
        require(
            !sector.initialized,
            "Require that given sector has not been initialized"
        );

        sector.owner = owner;
        sector.initialized = true;

        (   uint xAngle,
            uint zAngle
        ) = convertAddressToCordinateTuple(sectorAddress);

        sector.cordinates = SphereCordinate(xAngle, zAngle);

        initializeSectorNaturalResources(sector);
    }

    function initializeSectorNaturalResources(
        Sector storage sector
    ) private view {

    }

    function consumeItem(
        Sector storage sector,
        ItemProperties memory item,
        uint quantityIn
    )
    internal returns (
        bool successful
    ){
        uint quantity = quantityIn;

        if(item.itemType == ItemType.NaturalResource){
            /* Extract item from sector's potential nat reasource */

        }else if(item.itemType == ItemType.Component){
            /* Subtract item from sector's silos */
            for(
                uint i = 0;
                i < sector.silos.length && quantity > 0;
                i++
            ){
                if(item.id == sector.silos[i].targetItemId){
                    if(quantity < sector.silos[i].curQuantity){
                        sector.silos[i].curQuantity -= quantity;
                        quantity = 0;
                    }else{
                        quantity -= sector.silos[i].curQuantity;
                        sector.silos[i].curQuantity = 0;
                    }
                }
            }
        }else if(item.itemType == ItemType.Placeable){
            /* Check if placeable exisits in sector */
        }
        return (quantity == 0);
    }

    function storeItem(
        Sector storage sector,
        ItemProperties memory item,
        uint quantityIn
    )
    internal returns(
        bool successful
    ){
        uint quantity = quantityIn;

        if(item.itemType == ItemType.Placeable){
            require(
                quantity == 1,
                "Require that placeable are stored one at a time"
            );

            if(item.itemSubType == ItemSubType.Silo){
                sector.silos.push(item.optionalProperties.silo);
            }else if(item.itemSubType == ItemSubType.Extractor){
                sector.extractors.push(item.optionalProperties.extractor);
            }else if(item.itemSubType == ItemSubType.Assembler){
                sector.assemblers.push(item.optionalProperties.assembler);
            }

            quantity = 0;

        }else if(item.itemType == ItemType.Component){
            for(uint i = 0; i < sector.silos.length && quantity > 0; i++){

                if(item.id == sector.silos[i].targetItemId){

                    sector.silos[i].curQuantity += quantity;

                    if(
                        sector.silos[i].curQuantity
                        > sector.silos[i].maxQuantity
                    ){
                        quantity = sector.silos[i].curQuantity -
                            sector.silos[i].maxQuantity;

                        sector.silos[i].curQuantity = sector.silos[i].maxQuantity;
                    }else{
                        quantity = 0;
                    }
                }
            }
        }

        return (quantity == 0);
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