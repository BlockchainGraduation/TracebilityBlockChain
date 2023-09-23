// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IManufacturer {
    function create(string memory id, address ad_man) external returns(ManufacturerInfo memory);
    function get_seedling_manufacturer_by_address(address manu_adress) external view returns (ManufacturerInfo memory);
    function get_seedling_manufacturer_by_id(string memory id) external  view returns (ManufacturerInfo memory);
}

contract Manufacturer is IManufacturer{
    
    constructor(){}

    mapping (address => ManufacturerInfo) manufacturers;
    mapping (string => ManufacturerInfo) manufacturers_ms;
    ManufacturerInfo[] public list_manufacturer;

    function create(string memory id, address ad_man) public returns(ManufacturerInfo memory) {
        manufacturers[ad_man] = ManufacturerInfo(id, ad_man);
        list_manufacturer.push(manufacturers[ad_man]);
        manufacturers_ms[id] = manufacturers[ad_man];
        return manufacturers[ad_man];
    }

    function get_seedling_manufacturer_by_address(address manu_adress) public  view returns (ManufacturerInfo memory){
        return manufacturers[manu_adress];
    }
    
    function get_seedling_manufacturer_by_id(string memory id) public  view returns (ManufacturerInfo memory){
        return manufacturers_ms[id];
    }
}