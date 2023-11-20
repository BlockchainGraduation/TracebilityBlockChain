// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";


interface IMarketplace {

    function create_item_marketplace(string calldata id, string calldata product_id, string calldata owner) external returns(SupplyChainLib.MarketplaceItem memory);

    function get_item_by_id(string calldata item_id) external view returns(SupplyChainLib.MarketplaceItem memory);

    function get_ids()external view returns(string[] memory);
}

contract Marketplace is IMarketplace{


    mapping(string => SupplyChainLib.MarketplaceItem) public idToMarketplaceItem;
    string[] public idItems;

    constructor(){
    }

    function create_item_marketplace(string calldata id, string calldata product_id, string calldata owner)public returns(SupplyChainLib.MarketplaceItem memory){
        idToMarketplaceItem[id] = SupplyChainLib.MarketplaceItem(id, product_id, owner);
        idItems.push(id);
        return idToMarketplaceItem[id];
    }

    function get_item_by_id(string calldata item_id) public view returns(SupplyChainLib.MarketplaceItem memory){
        return idToMarketplaceItem[item_id];
    }

    function get_ids()public view returns(string[] memory){
        return idItems;
    }


}