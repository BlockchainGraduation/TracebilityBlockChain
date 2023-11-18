// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../product/Product.sol";
import "../lib/SupplyChainLib.sol";

interface IGrowUpProduct {
    function updateGrowUpProduct(string calldata id, string calldata url) external;
    function getGrowUpProduct(string calldata id) external view returns(SupplyChainLib.GrowUpDetail[] memory);
}

contract GrowUpProduct{


    mapping(string=>SupplyChainLib.GrowUpDetail[]) growUpDetail;

    constructor(){
    }

    function updateGrowUpProduct(string calldata id, string calldata url) public{
        growUpDetail[id].push(SupplyChainLib.GrowUpDetail(url, block.timestamp));
    }

    function getGrowUpProduct(string calldata id) public view returns(SupplyChainLib.GrowUpDetail[] memory){
        return growUpDetail[id];
    }

}