// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IFarmer {
    function create(string memory id, address ad_farmer) external returns(ActorInfo memory);
    function get_farmer_by_address(address address_farmer) external view returns (ActorInfo memory);
    function get_farmer_by_id(string memory id) external  view returns (ActorInfo memory);
    function get_list_farmer() external view returns (ActorInfo[] memory);
}

contract Farmer is IFarmer{

    constructor(){}

    mapping (address => ActorInfo) farmers;
    mapping (string => ActorInfo) farmers_ms;
    ActorInfo[] list_farmer;

    function create(string memory id, address ad_farmer) public returns(ActorInfo memory) {
        farmers[ad_farmer] = ActorInfo(id, ad_farmer);
        list_farmer.push(farmers[ad_farmer]);
        farmers_ms[id] = farmers[ad_farmer];
        return farmers[ad_farmer];
    }

    function get_farmer_by_address(address address_farmer) public  view returns (ActorInfo memory){
        return farmers[address_farmer];
    }
    
    function get_farmer_by_id(string memory id) public  view returns (ActorInfo memory){
        return farmers_ms[id];
    }

    function get_list_farmer() public view returns (ActorInfo[] memory){
        return list_farmer;
    }
}