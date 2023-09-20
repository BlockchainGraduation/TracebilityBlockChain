// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IManufacturer {
    function create(string memory id) external returns(ManufacturerInfo memory);
    function get_seedling_manufacturer_by_address(address manu_adress) external view returns (ManufacturerInfo memory);
    function get_seedling_manufacturer_by_id(string memory id) external  view returns (ManufacturerInfo memory);
}

contract Manufacturer is IManufacturer{
    
    constructor(){}

    mapping (address => ManufacturerInfo) manufacturers;
    mapping (string => ManufacturerInfo) manufacturers_ms;
    ManufacturerInfo[] public list_manufacturer;

    function create(string memory id) public returns(ManufacturerInfo memory) {
        manufacturers[msg.sender] = ManufacturerInfo(id, msg.sender);
        list_manufacturer.push(manufacturers[msg.sender]);
        manufacturers_ms[id] = manufacturers[msg.sender];
        return manufacturers[msg.sender];
    }

    function get_seedling_manufacturer_by_address(address manu_adress) public  view returns (ManufacturerInfo memory){
        return manufacturers[manu_adress];
    }
    
    function get_seedling_manufacturer_by_id(string memory id) public  view returns (ManufacturerInfo memory){
        return manufacturers_ms[id];
    }
}