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

    function addItem(
        uint itemId,
        uint itemType,
        uint itemSubType
    ) external {
        require(
            items.length == itemId,
            "Require that caller know the id of item being added"
        );

        OptionalItemProperties memory itemPropsOptional;

        ItemProperties memory itemProps = ItemProperties(
            items.length,
            7, // mass
            7, // volume
            ItemType(itemType),
            ItemSubType(itemSubType),
            itemPropsOptional
        );
        items.push(itemProps);
    }

    function addAssemblerProperties(uint targetTransformationId) external {
        AssemblerItem storage curAssembler = items[
            items.length - 1
        ].optionalProperties.assembler;

        curAssembler.targetTransformationId = targetTransformationId;
    }

    function addExtractorProperties(uint targetTransformationId) external {
        ExtractorItem storage curExtractor = items[
            items.length - 1
        ].optionalProperties.extractor;

        curExtractor.targetTransformationId = targetTransformationId;
    }

    function addSiloProperties(uint targetItemId, uint maxQuantity) external {

        SiloItem storage curSilo =
            items[items.length - 1].optionalProperties.silo;
        curSilo.targetItemId = targetItemId;
        curSilo.maxQuantity = maxQuantity;

        //  = SiloItem(
        //     ItemSubtype(items.length),
        //     PlaceableProperties(7),
        //     targetItemId,
        //     maxQuantity,
        //     0
        // );


    }

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