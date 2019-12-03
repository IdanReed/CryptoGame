pragma solidity ^0.5.0;

contract TypesTransformation {

    /**
    This struct contains a 'recipe' that specifies a transformation one item
    set into another.
    */
    struct Transformation{
        uint transformationId;
        TransformationElement[] inputs;
        TransformationElement[] outputs;
    }

    struct TransformationElement{
        uint itemId;
        uint quantity;
    }

}