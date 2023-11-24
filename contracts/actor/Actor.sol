// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";

interface IActor {
    function create(string calldata id, address ad_Actor, SupplyChainLib.Role role, string calldata hash_info) external returns(SupplyChainLib.ActorInfo memory);
    function get_Actor_by_address(address address_Actor) external view returns (SupplyChainLib.ActorInfo memory);
    function get_Actor_by_id(string calldata id) external  view returns (SupplyChainLib.ActorInfo memory);
    function update_actor_hash_info(string calldata id, string calldata hash_info) external;
}

contract Actor is IActor{

    constructor(){
        owner = msg.sender;
    }
    address private owner;
    mapping (address => SupplyChainLib.ActorInfo) public actors;
    mapping (string => SupplyChainLib.ActorInfo) public actors_ms;
    SupplyChainLib.ActorInfo[] public list_Actor;

    function create(string calldata id, address ad_Actor, SupplyChainLib.Role role, string calldata hash_info) public returns(SupplyChainLib.ActorInfo memory) {
        actors[ad_Actor] = SupplyChainLib.ActorInfo(id, ad_Actor, role, hash_info);
        list_Actor.push(actors[ad_Actor]);
        actors_ms[id] = actors[ad_Actor];
        return actors[ad_Actor];
    }

    function get_Actor_by_address(address address_Actor) public  view returns (SupplyChainLib.ActorInfo memory){
        return actors[address_Actor];
    }

    function get_Actor_by_id(string calldata id) public  view returns (SupplyChainLib.ActorInfo memory){
        return actors_ms[id];
    }

    function get_list_Actor() public view returns (SupplyChainLib.ActorInfo[] memory){
        return list_Actor;
    }

    function update_actor_hash_info(string calldata id, string calldata hash_info) public {
        actors_ms[id].hash_info = hash_info;
        actors[actors_ms[id].owner]= actors_ms[id];
    }

}