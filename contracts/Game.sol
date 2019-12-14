pragma solidity ^0.5.0;

import "./types/TypesItem.sol";
import "./types/TypesTransformation.sol";
import "./types/TypesSector.sol";

import "./ProductionManager.sol";

contract Game is
    TypesItem, TypesTransformation, TypesSector,
    ProductionManager
    {
    constructor() ProductionManager() public  {

    }
    /**************************************************************
    Data
    **************************************************************/

    mapping (address => Sector) sectors;

    /**************************************************************
    External functions - full
    **************************************************************/

    /**
    A primary game function that is called to make a sector's buildings act.
    */
    function tickSector(
        address sectorAddress
    ) external callerOwnsSector(sectorAddress) {
        Sector storage sector = sectors[sectorAddress];

        for(uint i = 0; i < sector.extractors.length; i++){
            proccessTransformation(
                sector,
                transformations[sector.extractors[i].targetTransformationId]
            );
        }

        for(uint i = 0; i < sector.assemblers.length; i++){
            proccessTransformation(
                sector,
                transformations[sector.assemblers[i].targetTransformationId]
            );
        }
    }

    /**
    Native sector is one with the same key address as the caller. If this
    sector hasn't been annexed or initialized this will do so .
    */
    function initializeNativeSector() external {
        Sector storage nativeSector = sectors[msg.sender];
        if(!nativeSector.initialized){
            initializeSector(
                nativeSector,
                msg.sender,
                msg.sender,
                itemIdsByType
            );
        }
    }

    /**
    This function attempts to execute a transformation that was externally
    called. Intended for building placeable items in a sector.

    */
    function manualTransformation(
        address sectorAddress,
        uint transformationId
    )
    external callerOwnsSector(sectorAddress)
    returns (bool){
        return proccessTransformation(
            sectors[sectorAddress],
            transformations[transformationId]
        );
    }

    /**************************************************************
    Public functions   - view, pure
    **************************************************************/

    function getSectorAttributes(address sectorAddress) public view returns (
        bool initialized,
        address owner,
        uint xAngle,
        uint zAngle
    ){
        Sector memory sector = sectors[sectorAddress];

        return (
            sector.initialized,
            sector.owner,
            sector.cordinates.xAngle,
            sector.cordinates.zAngle
        );
    }

    function getSectorSilos(address sectorAddress) public view returns (
        uint[] memory itemIds,
        uint[] memory itemQuantities
    ){

        Sector memory sector = sectors[sectorAddress];
        uint siloCount = sector.silos.length;

        itemIds = new uint[](siloCount);
        itemQuantities = new uint[](siloCount);

        for(uint i = 0; i < sector.silos.length; i++){
            itemIds[i] = sector.silos[i].targetItemId;
            itemQuantities[i] = sector.silos[i].curQuantity;
        }

        return (
            itemIds,
            itemQuantities
        );
    }

    function getSectorNaturalResources(
        address sectorAddress
    )
    public view returns (
        uint[] memory itemIds,
        uint[] memory remainingQuantities
    ){
        Sector memory sector = sectors[sectorAddress];
        uint naturalResourceCount = sector.naturalResources.length;

        itemIds = new uint[](naturalResourceCount);
        remainingQuantities = new uint[](naturalResourceCount);

        for(uint i = 0; i < naturalResourceCount; i++){
            itemIds[i] = sector
                .naturalResources[i]
                .itemIntf
                .itemId;

            remainingQuantities[i] = sector
                .naturalResources[i]
                .remainingQuantity;
        }
    }

    /**************************************************************
    Modifiers
    **************************************************************/

    modifier callerOwnsSector(address sectorAddress) {
        require(
            msg.sender == sectors[sectorAddress].owner,
            "Require that sector referenced by address is owned by the caller"
        );
        _;
    }
}