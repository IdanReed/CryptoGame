pragma solidity ^0.5.0;

import "./ItemTypes.sol";
import "./RecipeTypes.sol";

contract CraftingManager is ItemTypes, RecipeTypes{
    Recipe[] recipes;
    ItemProperties[] items;

    /**************************************************************
    Public pure/views
    **************************************************************/
    function getRecipeProperties(uint recipeId) public view returns (
        uint inputCounts,
        uint[50] memory inputItemIds,
        uint[50] memory inputQuantities,
        uint outputCounts,
        uint[50] memory outputItemIds,
        uint[50] memory outputQuantities
    ){
        Recipe memory recipe = recipes[recipeId];

        uint i;

        for(i = 0; i < recipe.inputs.length; i++){
            inputItemIds[i] = recipe.inputs[i].itemId;
            inputQuantities[i] = recipe.inputs[i].quantity;
        }
        for(i = 0; i < recipe.outputs.length; i++){
            outputItemIds[i] = recipe.outputs[i].itemId;
            outputQuantities[i] = recipe.outputs[i].quantity;
        }

        return (
            recipe.inputs.length,
            inputItemIds,
            inputQuantities,

            recipe.outputs.length,
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

    function getCraftingMapRanges() public view returns (
        uint itemCount,
        uint recipeCount
    ){
        return(
            items.length,
            recipes.length
        );
    }

    /**************************************************************
    Recipe/item loading
    **************************************************************/
    function addItem(uint density, uint itemType) public {
        OptionalItemProperties memory itemPropsOptional;

        ItemProperties memory itemProps = ItemProperties(
            items.length - 1,
            density,
            ItemType(itemType),
            itemPropsOptional
        );
        items.push(itemProps);
    }

    function addRecipe() public {
        recipes.length += 1;
    }
    function addRecipeElement(bool isInput, uint itemId, uint quantity) public {
        //require(itemId < items.length, "Require that itemId is within range of valid items.");

        Recipe storage recipe = recipes[recipes.length - 1];
        RecipeElement memory element = RecipeElement(itemId, quantity);

        if(isInput) {
            recipe.inputs.push(element);
        }else{
            recipe.outputs.push(element);
        }
    }

    function addExtractorProps() public {

    }
}