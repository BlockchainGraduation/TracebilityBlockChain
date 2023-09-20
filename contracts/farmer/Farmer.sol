// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IFarmer {
    function create(string memory id) external returns(FarmerInfo memory);
    function get_farmer_by_address(address address_farmer) external view returns (FarmerInfo memory);
    function get_farmer_by_id(string memory id) external  view returns (FarmerInfo memory);
    function get_list_farmer() external view returns (FarmerInfo[] memory);
}

contract Farmer is IFarmer{

    constructor(){}

    mapping (address => FarmerInfo) farmers;
    mapping (string => FarmerInfo) farmers_ms;
    FarmerInfo[] list_farmer;

    function create(string memory id) public returns(FarmerInfo memory) {
        farmers[msg.sender] = FarmerInfo(id, msg.sender);
        list_farmer.push(farmers[msg.sender]);
        farmers_ms[id] = farmers[msg.sender];
        return farmers[msg.sender];
    }

    function get_farmer_by_address(address address_farmer) public  view returns (FarmerInfo memory){
        return farmers[address_farmer];
    }
    
    function get_farmer_by_id(string memory id) public  view returns (FarmerInfo memory){
        return farmers_ms[id];
    }

    function get_list_farmer() public view returns (FarmerInfo[] memory){
        return list_farmer;
    }
}