pragma solidity ^0.5.0;

import "./ItemTypes.sol";
import "./RecipeTypes.sol";
import "./CraftingManager.sol";
import "./SectorTypes.sol";

contract Game is ItemTypes, RecipeTypes, CraftingManager, SectorTypes{

    mapping (address => Sector) sectors;

    /**************************************************************
    Public ABI
    **************************************************************/
    function initializeNativeSector() public {
        Sector storage nativeSector = sectors[msg.sender];

        if (!nativeSector.initialized) {
            nativeSector.initialized = true;
            nativeSector.owner = msg.sender;

            (   uint xAngle,
                uint zAngle
            ) = convertAddressToCordinateTuple(nativeSector.owner);

            nativeSector.cordinates = SphereCordinate(xAngle, zAngle);
        }
    }
    function craftInputPlaceable() private {
        
    }
    function craftInputNonPlaceable() private {

    }
    function craftOutputPlaceable() private {

    }
    function craftOutputNonPlaceable() private {

    }
    function craftRecipeElement(Sector memory sector, bool isInput, uint itemId, uint quantity) private pure returns (bool) {
        if(isInput){
            // Determine if sector has something then su
        }else{
            // Store or place element
        }
    }

    function craftRecipe(address sectorAddress, uint recipeId) public {
        (   uint itemCount,
            uint recipeCount
        ) = getCraftingMapRanges();
        require(recipeId < recipeCount, "Require recipeId to be in valid range.");

        Sector memory sector = sectors[sectorAddress];
        //require(sector.owner == msg.sender, "Require that the caller is the owner of the sector.");

        (
            uint inputCounts,
            uint[50] memory inputItemIds,
            uint[50] memory inputQuantities,
            uint outputCounts,
            uint[50] memory outputItemIds,
            uint[50] memory outputQuantities
        ) = getRecipeProperties(recipeId);

        for(uint i = 0; i < inputCounts; i++){
            
        }
        for(uint i = 0; i < outputCounts; i++){

        }

    }

    function tickSector(address sectorAddress) public {

    }

    /**************************************************************
    Public Views/Pure
    **************************************************************/
    function getSectorAttributes(address sectorAddress) public view returns (
        bool initialized,
        address owner,
        uint xAngle,
        uint zAngle ){

        Sector memory selSector = sectors[sectorAddress];

        return (
            selSector.initialized,
            selSector.owner,
            selSector.cordinates.xAngle,
            selSector.cordinates.zAngle
        );
    }
}