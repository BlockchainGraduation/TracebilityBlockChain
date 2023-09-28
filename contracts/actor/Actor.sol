// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface IActor {
    function create(string memory id, address ad_Actor, SupplyChainLib.Role role) external returns(ActorInfo memory);
    function get_Actor_by_address(address address_Actor) external view returns (ActorInfo memory);
    function get_Actor_by_id(string memory id) external  view returns (ActorInfo memory);
    function get_list_Actor() external view returns (ActorInfo[] memory);
}

contract Actor is IActor{

    constructor(){}

    mapping (address => ActorInfo) Actors;
    mapping (string => ActorInfo) Actors_ms;
    ActorInfo[] list_Actor;

    function create(string memory id, address ad_Actor, SupplyChainLib.Role role) public returns(ActorInfo memory) {
        Actors[ad_Actor] = ActorInfo(id, ad_Actor, role);
        list_Actor.push(Actors[ad_Actor]);
        Actors_ms[id] = Actors[ad_Actor];
        return Actors[ad_Actor];
    }

    function get_Actor_by_address(address address_Actor) public  view returns (ActorInfo memory){
        return Actors[address_Actor];
    }
    
    function get_Actor_by_id(string memory id) public  view returns (ActorInfo memory){
        return Actors_ms[id];
    }

    function get_list_Actor() public view returns (ActorInfo[] memory){
        return list_Actor;
    }
}