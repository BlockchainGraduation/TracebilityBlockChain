// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Farmer{
    struct Info{
        address farmer_ad;
        string id;
    }
    
    mapping(address => Info) farmers;

    function create(string memory id) public returns (Info memory){
        farmers[msg.sender] = Info(msg.sender, id);
        return farmers[msg.sender];
    }
    function read_farmer(address farmer_ad) public view returns (Info memory){
        return farmers[farmer_ad];
    }
}