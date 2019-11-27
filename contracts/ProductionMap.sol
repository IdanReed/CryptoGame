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
        uint itemType,
        uint itemSubType
    ) external {
        require(
            items.length == itemId,
            "Require that caller know the id of item being added"
        );

        ItemProperties memory itemProps;
        itemProps.id = items.length;
        itemProps.itemType = ItemType(itemType);

        if(itemProps.itemType == ItemType.NaturalResource){
            itemProps.itemSubtypeNaturalResource = ItemSubtypeNaturalResource(
                itemSubType
            );
        }else if(itemProps.itemType == ItemType.Component){
            itemProps.itemSubtypeComponent = ItemSubtypeComponent(
                itemSubType
            );
        }else if(itemProps.itemType == ItemType.Placeable){
            itemProps.itemSubtypePlaceable = ItemSubtypePlaceable(
                itemSubType
            );
        }

        items.push(itemProps);
    }

    function addAssemblerProperties(uint targetTransformationId) external {
        AssemblerItem storage curAssembler = items[topItemId()]
            .placeableSubtypes
            .assembler;

        curAssembler.itemIntf.itemId = topItemId();
        curAssembler.targetTransformationId = targetTransformationId;
    }

    function addExtractorProperties(uint targetTransformationId) external {
        ExtractorItem storage curExtractor = items[topItemId()]
            .placeableSubtypes
            .extractor;

        curExtractor.itemIntf.itemId = topItemId();
        curExtractor.targetTransformationId = targetTransformationId;
    }

    function addSiloProperties(uint targetItemId, uint maxQuantity) external {

        SiloItem storage curSilo = items[topItemId()].placeableSubtypes.silo;

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