// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";

interface IProduct {
    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string calldata trans_detail_id, SupplyChainLib.ProductStatus status, string calldata owner, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory);
    function update(string calldata id, uint price, uint quantity, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory );
    function readOneProduct(string calldata id) external view returns (SupplyChainLib.ProductInfo memory );
    function burn(string calldata id, uint quantity) external returns(uint);
    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status) external;

}

contract Product is IProduct{
    mapping(string => SupplyChainLib.ProductInfo) private products;
    mapping (string=> mapping (string => SupplyChainLib.ProductInfo)) private products_in_actor;

    constructor(){
    }

    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status)public{
        require(bytes(products[id].product_id).length!=0, "product not found");
        products[id].status = status;
    }

    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string calldata trans_detail_id, SupplyChainLib.ProductStatus status, string calldata owner, string calldata hash_info) public returns (SupplyChainLib.ProductInfo memory){

        if (product_type == SupplyChainLib.ProductType.Manufacturer){
            products[id]= SupplyChainLib.ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, owner, "", status, hash_info);
        }
        else if (product_type == SupplyChainLib.ProductType.Retailer || product_type == SupplyChainLib.ProductType.Manufacturer){
            products[id] = SupplyChainLib.ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, owner, trans_detail_id, status, hash_info);
        }
        else{
            revert("product type invalid");
        }

        products_in_actor[owner][id] = products[id];
        return (products[id]);
    }


    function update(string calldata id,  uint price, uint quantity, string calldata hash_info) public returns (SupplyChainLib.ProductInfo memory ){
        products[id].price = price;
        products[id].quantity = quantity;
        products[id].hash_info = hash_info;
        products_in_actor[products[id].owner_id][id] = products[id];
        return (products[id]);
    }

    function deleteProduct(string calldata id) public {

        delete products[id];
    }

    function readOneProduct(string calldata id) public view returns (SupplyChainLib.ProductInfo memory ) {
        return products[id];
    }

    function burn(string calldata id, uint quantity) public returns(uint){
        require(bytes(products[id].product_id).length != 0, "Product not found");
        require(products[id].quantity>= quantity, "Product quantity is not enough");
        products[id].quantity -= quantity;
        products_in_actor[products[id].owner_id][id] = products[id];
        return products[id].price;
    }

}