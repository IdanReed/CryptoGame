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

    function getTransformationProperties(uint transformationId) public view returns (
        uint inputCounts,
        uint[50] memory inputItemIds,
        uint[50] memory inputQuantities,
        uint outputCounts,
        uint[50] memory outputItemIds,
        uint[50] memory outputQuantities
    ){
        Transformation memory transformation = transformations[transformationId];

        uint i;

        for(i = 0; i < transformation.inputs.length; i++){
            inputItemIds[i] = transformation.inputs[i].itemId;
            inputQuantities[i] = transformation.inputs[i].quantity;
        }
        for(i = 0; i < transformation.outputs.length; i++){
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

    function getItemProperties(uint itemId) public view returns (
        uint density,
        uint itemType
    ){
        //require(itemId < items.length, "Require that itemId is within range of valid items.");
        ItemProperties memory item = items[itemId];

        return (
            item.density,
            uint(item.itemType)
        );
    }

    function getProductionMapRanges() public view returns (
        uint itemCount,
        uint transformationCount
    ){
        return(
            items.length,
            transformations.length
        );
    }

    function proccessTransformation(Sector memory sector, Transformation memory transformation) internal returns(
        bool successful
    ){
        TransformationElement memory trElem;
        ItemProperties memory itemProps;

        for(uint i = 0; i < transformation.inputs.length; i++){
            trElem = transformation.inputs[i];
            itemProps = items[trElem.itemId];

            if(!consumeResource(sector, itemProps.itemType, trElem.itemId, trElem.quantity)){
                return false;
            }
        }
        for(uint i = 0; i < transformation.outputs.length; i++){
            trElem = transformation.outputs[i];
            itemProps = items[trElem.itemId];

            if(!storeResource(sector, itemProps.itemType, trElem.itemId, trElem.quantity)){
                return false;
            }
        }
    }
}