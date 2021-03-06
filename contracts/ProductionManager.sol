pragma solidity ^0.5.0;

import "./types/TypesItem.sol";
import "./types/TypesTransformation.sol";
import "./types/TypesSector.sol";

import "./ProductionMap.sol";

/**
ProductionManager contract:
    is for processing production transformations on a sector
*/
contract ProductionManager is
    TypesItem, TypesTransformation, TypesSector,
    ProductionMap
{
    /**************************************************************
    External functions - view, pure
    **************************************************************/
    function getTransformationProperties(
        uint transformationId
    )
    external view returns (
        uint inputCounts,
        uint[50] memory inputItemIds,
        uint[50] memory inputQuantities,
        uint outputCounts,
        uint[50] memory outputItemIds,
        uint[50] memory outputQuantities
    ){
        Transformation memory transformation = transformations[
            transformationId
        ];

        for(uint i = 0; i < transformation.inputs.length; i++){
            inputItemIds[i] = transformation.inputs[i].itemId;
            inputQuantities[i] = transformation.inputs[i].quantity;
        }
        for(uint i = 0; i < transformation.outputs.length; i++){
            outputItemIds[i] = transformation.outputs[i].itemId;
            outputQuantities[i] = transformation.outputs[i].quantity;
        }

        return (
            transformation.inputs.length,
            inputItemIds,
            inputQuantities,

            transformation.outputs.length,
            outputItemIds,
            outputQuantities
        );
    }

    function getItemType(uint itemId) external view returns (
        uint itemCategory,
        uint itemSubtype
    ){
        require(
            itemId < items.length,
            "Require that itemId is within range of valid items."
        );

        ItemProperties memory item = items[itemId];
        return (
            uint(item.itemType.itemCategory),
            item.itemType.itemSubtype
        );
    }

    function getProductionMapRanges() external view returns (
        uint itemCount,
        uint transformationCount
    ){
        return(
            items.length,
            transformations.length
        );
    }

    /**************************************************************
    Internal functions - full
    **************************************************************/

    /**
    This function is called by manualTransformation or tickSector to
    execute production transformations on a sector.
    */
    function proccessTransformation(
        Sector storage sector,
        Transformation memory transformation
    ) internal returns (
        bool wasSuccessful
    ){
        Sector memory sectorBackup = sector;

        TransformationElement memory trElem;
        ItemProperties memory itemProps;

        for(uint i = 0; i < transformation.inputs.length; i++){
            trElem = transformation.inputs[i];
            itemProps = items[trElem.itemId];

            if(!consumeItem(
                sector,
                itemProps,
                trElem.quantity
            )){
                memcpyPlaceable(sectorBackup, sector);
                return false;
            }
        }
        for(uint i = 0; i < transformation.outputs.length; i++){
            trElem = transformation.outputs[i];
            itemProps = items[trElem.itemId];

            if(!storeItem(
                sector,
                itemProps,
                trElem.quantity
            )){
                memcpyPlaceable(sectorBackup, sector);
                return false;
            }
        }

        return true;
    }

    /**************************************************************
    Internal functions - view, pure
    **************************************************************/

    function getApItem() internal view returns (ItemProperties memory){
        uint itemId = itemIdsByType
            [uint(ItemCategory.Ap)]
            [uint(ItemSubtypeAp.Standard)]
            [0]; /* Only 1 ap type */
        return items[itemId];
    }
}