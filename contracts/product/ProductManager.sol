// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";
import "./Product.sol";
import "../actor/ActorManager.sol";

interface IProductManager {
    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string memory trans_detail_id, SupplyChainLib.ProductStatus status, string memory owner, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory);
    function update(string calldata id, uint price, uint quantity, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory );
    function readOneProduct(string calldata id) external view returns (SupplyChainLib.ProductInfo memory );
    function burn(string calldata id, uint quantity, string calldata id_type) external returns(uint);
    function check_product_is_exist(string calldata id) external view returns(bool);
    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status) external;
}

contract ProductManager is IProductManager{

    IProduct iProduct;
    IActorManager iActorManager;
    constructor(address ad_Actor){
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

    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status) public{
        iProduct.update_status_product(id, status);
    }
}
