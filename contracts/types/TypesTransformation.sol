pragma solidity ^0.5.0;

contract TypesTransformation{
    struct TransformationElement{
        uint itemId;
        uint quantity;
    }
    struct Transformation{
        uint transformationId;
        TransformationElement[] inputs;
        TransformationElement[] outputs;
    }
}