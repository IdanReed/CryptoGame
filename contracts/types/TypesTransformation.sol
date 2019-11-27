pragma solidity ^0.5.0;

import "./TypesSector.sol";

contract TypesTransformation{

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

    /**
    Transformations are applied step-by-step and acts directly on storage (to
    prevent excess copying). Each step creates one these structs to perserve
    the original Sector data incase a following step fails.
    */
    // struct TransfromationLogElement{
    //     uint
    // }


}