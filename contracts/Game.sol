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

    mapping (address => Sector) private sectors;

    /**************************************************************
    External functions - full
    **************************************************************/

    /**

    */
    function getSectorAp(address sectorAddress) external view returns(uint) {
        return sectors[sectorAddress].ap;
    }

    /**
    A primary game function that is called to make a sector's buildings act.
    */
    function tickSector(
        address sectorAddress
    ) external callerOwnsSector(sectorAddress) returns(
        bool wasSuccessful,bool wasSuccessful1,bool wasSuccessful2
    ){
        Sector storage sector = sectors[sectorAddress];

        bool extractorsSuccesful = true;
        for(uint i = 0; i < sector.extractors.length; i++){
            extractorsSuccesful = proccessTransformation(
                sector,
                transformations[sector.extractors[i].targetTransformationId]
            );
        }

        bool assemberlsSuccesful = true;
        for(uint i = 0; i < sector.assemblers.length; i++){
            assemberlsSuccesful = proccessTransformation(
                sector,
                transformations[sector.assemblers[i].targetTransformationId]
            );
        }

        bool bridgesSuccesful = true;
        for(uint i = 0; i < sector.bridges.length; i++){
            bridgesSuccesful = processBridge(
                sector,
                i
           );
        }

        return (
            extractorsSuccesful,
            assemberlsSuccesful,
            bridgesSuccesful
        );

    }

    function createBridge(
        address sectorAddressSource,
        address sectorAddressTarget,
        uint targetItemId
    )
        external
        callerOwnsSector(sectorAddressSource)
    {

        Sector storage sector = sectors[sectorAddressSource];

        if(sectors[sectorAddressTarget].owner != msg.sender){
            require(
                targetItemId == getApItem().id,
                "Require bridge to be moving AP when ending at an unowned sector"
            );
        }

        Bridge memory bridge;
        bridge.targetItemId = targetItemId;
        bridge.endSector = sectorAddressTarget;

        bridge.curRate = 0;
        bridge.maxRate = 0;

        sector.bridges.push(bridge);

    }

    function setBridge(
        address sectorAddress,
        uint bridgeId,
        uint newRate
    )
        external
        callerOwnsSector(sectorAddress)
        returns(bool)
    {
        Sector storage sector = sectors[sectorAddress];

        require(
            bridgeId < sector.bridges.length,
            "Require valid bridgeId"
        );

        Bridge storage bridge = sector.bridges[bridgeId];

        if(bridge.maxRate >= newRate){
            bridge.curRate = newRate;
        }else{
            if(consumeItem(sector, getApItem(), newRate - bridge.maxRate)){
                bridge.maxRate = newRate;
                bridge.curRate = newRate;
            }else{
                return false;
            }
        }
        return true;
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
    Internal functions - full
    **************************************************************/
    function processBridge(
        Sector storage startSector,
        uint bridgeId
    ) internal returns (bool wasSuccessful){
        Bridge memory bridge = startSector.bridges[bridgeId];
        Sector storage endSector = sectors[bridge.endSector];

        if(startSector.owner != endSector.owner){
            attackSector(startSector, endSector, bridge);
        }else{
            return transferItem(
                startSector,
                sectors[bridge.endSector],
                items[bridge.targetItemId],
                bridge.curRate
            );
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