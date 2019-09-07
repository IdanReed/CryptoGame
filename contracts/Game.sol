pragma solidity ^0.5.0;

contract NodeStatus {

    struct NodeData {
        uint cash;
    }

    mapping (address => NodeData) allNodes;
    address[] public activeNodes;

    constructor() public {

    }

    function storeETH() public payable {
        allNodes[msg.sender].cash += msg.value;
    }

    function getAllNodes() public view returns (NodeData[] memory){
        NodeData[] memory nodes = new NodeData[](activeNodes.length);

        for (uint i = 0; i < activeNodes.length; i++) {
            nodes[i] = allNodes[activeNodes[i]];
        }
        return nodes;
    }
}
