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
    External functions - full
    **************************************************************/

    function addItem(
        uint itemId,
        uint itemCategory,
        uint itemSubType
    ) external {
        require(
            items.length == itemId,
            "Require that caller know the id of item being added"
        );

        ItemProperties memory itemProps;
        itemProps.id = items.length;
        itemProps.itemType.itemCategory = ItemCategory(itemCategory);
        itemProps.itemType.itemSubtype = itemSubType;

        items.push(itemProps);
    }

    function addAssemblerProperties(uint targetTransformationId) external {
        AssemblerItem storage curAssembler = items[topItemId()]
            .subtypes
            .placeable
            .assembler;

        curAssembler.itemIntf.itemId = topItemId();
        curAssembler.targetTransformationId = targetTransformationId;
    }

    function addExtractorProperties(uint targetTransformationId) external {
        ExtractorItem storage curExtractor = items[topItemId()]
            .subtypes
            .placeable
            .extractor;

        curExtractor.itemIntf.itemId = topItemId();
        curExtractor.targetTransformationId = targetTransformationId;
    }

    function addSiloProperties(uint targetItemId, uint maxQuantity) external {

        SiloItem storage curSilo = items[topItemId()]
            .subtypes
            .placeable
            .silo;

        curSilo.itemIntf.itemId = topItemId();
        curSilo.targetItemId = targetItemId;
        curSilo.maxQuantity = maxQuantity;
    }

    function addTransformation(uint transformationId) external {
        require(
            transformations.length == transformationId,
            "Require that caller know the id the transformation being added"
        );
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

    /**************************************************************
    Internal functions - full
    **************************************************************/

    function topItemId() internal view returns(uint ) {
        return items.length - 1;
    }
}