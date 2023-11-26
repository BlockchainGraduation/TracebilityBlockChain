// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";
import "./Product.sol";
import "../grow_up_product/GrowUpProduct.sol";
import "../actor/ActorManager.sol";

interface IProductManager {
    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string memory trans_detail_id, SupplyChainLib.ProductStatus status, string memory owner, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory);
    function update(string calldata id, uint price, uint quantity, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory );
    function readOneProduct(string calldata id) external view returns (SupplyChainLib.ProductInfo memory );
    function burn(string calldata id, uint quantity, string calldata id_type) external returns(uint);
    function check_product_is_exist(string calldata id) external view returns(bool);
    function updateGrowUpProduct(string calldata id, string calldata url) external;
    function getGrowUpProduct(string calldata id) external view returns(SupplyChainLib.GrowUpDetail[] memory);
    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status) external;
}

contract ProductManager is IProductManager{

    IGrowUpProduct iGUProduct;
    IProduct iProduct;
    IActorManager iActorManager;
    constructor(address ad_Actor){
        iGUProduct = IGrowUpProduct(address(new GrowUpProduct()));
        iProduct = IProduct(address(new Product()));
        iActorManager = IActorManager(ad_Actor);
    }

    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string calldata trans_detail_id, SupplyChainLib.ProductStatus status, string calldata owner, string calldata hash_info) public returns (SupplyChainLib.ProductInfo memory){
        require(iActorManager.check_actor_is_exist(owner), "Actor not exsit.");
        return iProduct.create(id, product_type, price, quantity, trans_detail_id, status, owner, hash_info);
    }

    function update(string calldata id, uint price, uint quantity, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory ){
        return iProduct.update(id, price, quantity, hash_info);
    }

    function readOneProduct(string calldata id) public view returns (SupplyChainLib.ProductInfo memory ){
        return iProduct.readOneProduct(id);
    }

    function burn(string calldata id, uint quantity, string calldata id_type) external returns(uint){
        return iProduct.burn(id, quantity, id_type);
    }

    function check_product_is_exist(string memory id) external view returns(bool){
        string memory product_id = iProduct.readOneProduct(id).product_id;
        if (bytes(product_id).length!=0){
            return true;
        }
        return false;
    }

    function updateGrowUpProduct(string calldata id, string calldata url) external{
        SupplyChainLib.ProductInfo memory product = iProduct.readOneProduct(id);
        require(bytes(product.product_id).length!=0, "product is not exist");
        require(product.product_type == SupplyChainLib.ProductType.Farmer, "product can not update grow up");

        iGUProduct.updateGrowUpProduct(id, url);
    }

    function getGrowUpProduct(string calldata id) external view returns(SupplyChainLib.GrowUpDetail[] memory){
        return iGUProduct.getGrowUpProduct(id);
    }

    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status) public{
        iProduct.update_status_product(id, status);
    }
    function update_price_and_type_of_type(string calldata product_id, string calldata id_type, uint price, uint count) public{
        iProduct.update_price_and_type_of_type(product_id, id_type, price, count);
    }
    function create_price_detail_of_type(string calldata product_id, string[] calldata id_type, SupplyChainLib.CountDetail[] calldata price_quantity) public{
        iProduct.create_price_detail_of_type(product_id, id_type, price_quantity);
    }
    function get_price_detail_of_product(string calldata product_id, string calldata id_type) public view returns(SupplyChainLib.CountDetail memory){
        return iProduct.get_price_detail_of_product(product_id, id_type);
    }
    function get_list_type_product(string calldata product_id) public view returns(string[] memory){
        return iProduct.get_list_type_product(product_id);
    }
}