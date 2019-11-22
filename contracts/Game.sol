pragma solidity ^0.5.0;

import "./types/TypesItem.sol";
import "./types/TypesTransformation.sol";
import "./types/TypesSector.sol";

import "./ProductionManager.sol";

contract Game is
    TypesItem, TypesTransformation, TypesSector,
    ProductionManager
    {

    /**************************************************************
    Data
    **************************************************************/
    mapping (address => Sector) sectors;

    /**************************************************************
    Public functions   - full
    **************************************************************/

    /**
    Native sector is one with the same key address as the caller. If this
    sector hasn't been annexed or initialized this will do so.
    */
    function initializeNativeSector() public {
        Sector storage nativeSector = sectors[msg.sender];
        if(!nativeSector.initialized){
            initializeSector(nativeSector, msg.sender, msg.sender);
        }
    }

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
    }

    /**
    This function attempts to execute a transformation that was externally
    called. Intended for building placeable items in a sector.
    */
    function manualTransformation(
        address sectorAddress,
        uint transformationId
    )
    external callerOwnsSector(sectorAddress){
        proccessTransformation(
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
        Sector memory selSector = sectors[sectorAddress];

        return (
            selSector.initialized,
            selSector.owner,
            selSector.cordinates.xAngle,
            selSector.cordinates.zAngle
        );
    }

    function getSectorSilos(address sectorAddress) public view returns (
        uint[] memory itemIds,
        uint[] memory itemQuantities
    ){

        Sector memory selSector = sectors[sectorAddress];
        uint siloCount = selSector.silos.length;

        itemIds = new uint[](siloCount);
        itemQuantities = new uint[](siloCount);

        for(uint i = 0; i < selSector.silos.length; i++){
            itemIds[i] = selSector.silos[i].targetItemId;
            itemQuantities[i] = selSector.silos[i].curQuantity;
        }

        return (
            itemIds,
            itemQuantities
        );
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