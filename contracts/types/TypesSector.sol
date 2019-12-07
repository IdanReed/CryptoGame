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

    struct Sector{
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

    struct SectorItemReference{
        ItemSubtypePlaceable itemType;
        uint itemIndex;
        uint originalVal;
    }

    /**
    Transformations are applied step-by-step and acts directly on storage (to
    prevent excess copying). Each step creates one these structs to perserve
    the original Sector data incase a following step fails.

    TODO switch from memcpy to this, could actually 'store' them in storage to
    allow for the list to be built dyn
    */
    struct SectorModification{
        ItemSubtypePlaceable itemSubtypePlaceable;
        uint itemIndex;
        uint originalValue;
    }

    /**************************************************************
    Internal functions - full
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
    ) private {

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

        if(item.itemType.itemCategory == ItemCategory.NaturalResource){
            /* Extract item from sector's potential nat reasource */

        }else if(item.itemType.itemCategory == ItemCategory.Component){
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
        }else if(item.itemType.itemCategory == ItemCategory.Placeable){
            /* Check if placeable exisits in sector */

            if(
                item.itemType.itemSubtype == uint(
                    ItemSubtypePlaceable.Assembler
                )
            ){
                for(uint i = 0;
                    i < sector.assemblers.length && quantity > 0;
                    i++
                ){
                    if(sector.assemblers[i].itemIntf.itemId == item.id){
                        quantity -= 1;
                    }
                }
            }else if(
                item.itemType.itemSubtype == uint(
                    ItemSubtypePlaceable.Extractor
                )
            ){
                for(uint i = 0;
                    i < sector.extractors.length && quantity > 0;
                    i++
                ){
                    if(sector.extractors[i].itemIntf.itemId == item.id){
                        quantity -= 1;
                    }
                }
            }

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

        if(item.itemType.itemCategory == ItemCategory.Placeable){
            if(
                item.itemType.itemSubtype == uint(
                    ItemSubtypePlaceable.Silo
                )
            ){
                sector.silos.push(item.subtypes.placeable.silo);
            }else if(
                item.itemType.itemSubtype == uint(
                    ItemSubtypePlaceable.Extractor
                )
            ){
                sector.extractors.push(item.subtypes.placeable.extractor);
            }else if(
                item.itemType.itemSubtype == uint(
                    ItemSubtypePlaceable.Assembler
                )
            ){
                sector.assemblers.push(item.subtypes.placeable.assembler);
            }
            quantity = 0;

        }else if(item.itemType.itemCategory == ItemCategory.Component){
            for(uint i = 0; i < sector.silos.length && quantity > 0; i++){

                if(item.id == sector.silos[i].targetItemId){

                    sector.silos[i].curQuantity += quantity;

                    if(
                        sector.silos[i].curQuantity
                        > sector.silos[i].maxQuantity
                    ){
                        quantity = sector.silos[i].curQuantity -
                            sector.silos[i].maxQuantity;

                        sector.silos[i].curQuantity = sector
                            .silos[i]
                            .maxQuantity;
                    }else{
                        quantity = 0;
                    }
                }
            }
        }

        return (quantity == 0);
    }

    function memcpyPlaceable(
        Sector memory sectorMem,
        Sector storage sectorStor
    )
    internal {

        sectorStor.silos.length = sectorMem.silos.length;
        for(uint i = 0; i < sectorMem.silos.length; i++ ){
            sectorStor.silos[i] = sectorMem.silos[i];
        }

        sectorStor.extractors.length = sectorMem.extractors.length;
        for(uint i = 0; i < sectorMem.extractors.length; i++ ){
            sectorStor.extractors[i] = sectorMem.extractors[i];
        }

        sectorStor.assemblers.length = sectorMem.assemblers.length;
        for(uint i = 0; i < sectorMem.assemblers.length; i++ ){
            sectorStor.assemblers[i] = sectorMem.assemblers[i];
        }
    }

    function setSectorTickBlock(Sector storage sector) internal {
        sector.lastTickBlock = block.number;
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