// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IFarmer {
    function create(string memory id, address ad_farmer) external returns(FarmerInfo memory);
    function get_farmer_by_address(address address_farmer) external view returns (FarmerInfo memory);
    function get_farmer_by_id(string memory id) external  view returns (FarmerInfo memory);
    function get_list_farmer() external view returns (FarmerInfo[] memory);
}

contract Farmer is IFarmer{

    constructor(){}

    mapping (address => FarmerInfo) farmers;
    mapping (string => FarmerInfo) farmers_ms;
    FarmerInfo[] list_farmer;

    function create(string memory id, address ad_farmer) public returns(FarmerInfo memory) {
        farmers[ad_farmer] = FarmerInfo(id, ad_farmer);
        list_farmer.push(farmers[ad_farmer]);
        farmers_ms[id] = farmers[ad_farmer];
        return farmers[ad_farmer];
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