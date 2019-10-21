pragma solidity ^0.5.0;

contract RecipeTypes{
    struct RecipeElement{
        uint itemId;
        uint quantity;
    }
    struct Recipe{
        uint recipeId;
        RecipeElement[] inputs;
        RecipeElement[] outputs;
    }

}