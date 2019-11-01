pragma solidity ^0.5.0;

import "./types/TypesItem.sol";
import "./types/TypesTransformation.sol";
import "./types/TypesSector.sol";

import "./ProductionManager.sol";

contract Game is
    TypesItem, TypesTransformation, TypesSector,
    ProductionManager
    {

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
    function tickSector(address sectorAddress) public {

    }
    function manualTransformation(address sectorAddress, uint transformationId) public returns (
        bool successful
    ){

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

    /**************************************************************
    Modifiers
    **************************************************************/
    modifier callerOwnsSector(address sectorAddress) {
        require(
            msg.sender == sectors[sectorAddress].owner,
            "Require that sector reference by address is owned by the caller"
        );
        _;
    }
}