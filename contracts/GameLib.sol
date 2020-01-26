pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;

interface ComponentIntf{
    function store(GameLib.Sector calldata) external pure returns(bool);
}

library GameLib {
    struct Sector {
        address addr;

        ComponentIntf[] components;
    }
}