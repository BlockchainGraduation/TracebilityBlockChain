// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IManufacturer {
    function create(string memory id, address ad_man) external returns(ActorInfo memory);
    function get_manufacturer_by_address(address manu_adress) external view returns (ActorInfo memory);
    function get_manufacturer_by_id(string memory id) external  view returns (ActorInfo memory);
    function get_list_manufactuter() external view returns (ActorInfo[] memory);
}

contract Manufacturer is IManufacturer{
    
    constructor(){}

    mapping (address => ActorInfo) manufacturers;
    mapping (string => ActorInfo) manufacturersById;
    ActorInfo[] public list_manufacturer;

    modifier manufacturerExists(string memory id) {
        require(keccak256(abi.encode(manufacturersById[id].id)) != keccak256(abi.encode("")), "Manufacturer does not exist");
        _;
    }

    function create(string memory id, address ad_man) public returns(ActorInfo memory) {
        manufacturers[ad_man] = ActorInfo(id, ad_man);
        list_manufacturer.push(manufacturers[ad_man]);
        manufacturersById[id] = manufacturers[ad_man];
        return manufacturers[ad_man];
    }

    function get_manufacturer_by_address(address manu_adress) public  view returns (ActorInfo memory){
        return manufacturers[manu_adress];
    }
    
    function get_manufacturer_by_id(string memory id) public  view returns (ActorInfo memory){
        return manufacturersById[id];
    }

    function get_list_manufactuter() public view returns (ActorInfo[] memory){
        return list_manufacturer;
    }
}