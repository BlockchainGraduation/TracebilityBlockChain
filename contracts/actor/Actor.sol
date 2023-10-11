// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IActor {
    function create(string memory id, address ad_Actor, SupplyChainLib.Role role) external returns(ActorInfo memory);
    function get_Actor_by_address(address address_Actor) external view returns (ActorInfo memory);
    function get_Actor_by_id(string memory id) external  view returns (ActorInfo memory);
    function get_list_Actor() external view returns (ActorInfo[] memory);
    function check_actor_is_exist(string memory id) external view returns(bool);
}

contract Actor is IActor{

    constructor(){}

    mapping (address => ActorInfo) public actors;
    mapping (string => ActorInfo) public actors_ms;
    ActorInfo[] public list_Actor;

    function create(string memory id, address ad_Actor, SupplyChainLib.Role role) public returns(ActorInfo memory) {
        actors[ad_Actor] = ActorInfo(id, ad_Actor, role);
        list_Actor.push(actors[ad_Actor]);
        actors_ms[id] = actors[ad_Actor];
        return actors[ad_Actor];
    }

    function get_Actor_by_address(address address_Actor) public  view returns (ActorInfo memory){
        return actors[address_Actor];
    }
    
    function get_Actor_by_id(string memory id) public  view returns (ActorInfo memory){
        return actors_ms[id];
    }

    function get_list_Actor() public view returns (ActorInfo[] memory){
        return list_Actor;
    }

    function check_actor_is_exist(string memory id) public  view returns(bool){
        if (bytes(actors_ms[id].id).length!=0){
            return true;
        }
        return false;
    }
}