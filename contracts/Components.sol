pragma solidity ^0.6.1;
pragma experimental ABIEncoderV2;
import './GameLib.sol';

contract CompDefault is ComponentIntf{
    uint placeholder;

    function store(
        GameLib.Sector calldata sector
    ) external override pure returns(bool){
        return true;
    }
}