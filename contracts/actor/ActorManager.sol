// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Actor.sol";
import "../lib/SupplyChainLib.sol";

interface IActorManager {

    function create(string calldata id, address ad_Actor, SupplyChainLib.Role role) external returns(SupplyChainLib.ActorInfo memory);
    function get_Actor_by_id(string calldata id) external  view returns (SupplyChainLib.ActorInfo memory);
    function get_ids_by_role(SupplyChainLib.Role role) external view returns (string[] memory);
    function check_actor_is_exist(string calldata id) external  view returns(bool);
}

contract ActorManager is IActorManager{

    mapping(SupplyChainLib.Role => string[]) ids_actor;
    IActor actor;

    constructor(){
        actor = IActor(address(new Actor()));
    }

    function create(string calldata id, address ad_Actor, SupplyChainLib.Role role) public returns(SupplyChainLib.ActorInfo memory){
        require(!this.check_actor_is_exist(id), "actor is exist");
        ids_actor[role].push(id);
        return actor.create(id, ad_Actor, role);

    }

    function get_Actor_by_id(string calldata id) public  view returns (SupplyChainLib.ActorInfo memory){
        return actor.get_Actor_by_id(id);
    }

    function get_ids_by_role(SupplyChainLib.Role role) public view returns (string[] memory){
        return ids_actor[role];
    }

    function check_actor_is_exist(string calldata id) public view returns(bool){
        string memory actor_id = actor.get_Actor_by_id(id).id;
        if (bytes(actor_id).length!=0){
            return true;
        }
        return false;
    }
}