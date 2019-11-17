pragma solidity ^0.5.0;

import "./types/TypesSector.sol";
import "./types/TypesItem.sol";
import "./types/TypesTransformation.sol";

/**
ProductionMap contract:
    stores all possible production transformations and items
*/
contract ProductionMap is
    TypesItem, TypesTransformation, TypesSector
    {

    Transformation[] transformations;
    ItemProperties[] items;

    /**************************************************************
    Item loading
    **************************************************************/
    function addItem(
        uint density,
        uint itemType,
        uint itemPlaceableType
    ) external {
        OptionalItemProperties memory itemPropsOptional;

        ItemProperties memory itemProps = ItemProperties(
            items.length - 1,
            density,
            ItemType(itemType),
            ItemPlaceableType(itemPlaceableType),
            itemPropsOptional
        );
        items.push(itemProps);
    }
    function addExtractorProps() external {

    }

    /**************************************************************
    Transformation loading
    **************************************************************/
    function addTransformation() external {
        transformations.length += 1;
    }
    function addTransformationElement(
        bool isInput,
        uint itemId,
        uint quantity
    ) external {

        Transformation storage transformation = transformations[
            transformations.length - 1
        ];
        TransformationElement memory element = TransformationElement(
            itemId,
            quantity
        );

        if(isInput) {
            transformation.inputs.push(element);
        }else{
            transformation.outputs.push(element);
        }
    }
}