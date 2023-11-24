// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";

interface IProduct {
    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string calldata trans_detail_id, SupplyChainLib.ProductStatus status, string calldata owner, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory);
    function update(string calldata id, uint price, uint quantity, string calldata hash_info) external returns (SupplyChainLib.ProductInfo memory );
    function readOneProduct(string calldata id) external view returns (SupplyChainLib.ProductInfo memory );
    function burn(string calldata id, uint quantity, string calldata id_type) external returns(SupplyChainLib.ProductInfo memory);
    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status) external;
    function update_price_and_type_of_type(string calldata product_id, string calldata id_type, uint price, uint count) external;
    function create_price_detail_of_type(string calldata product_id, string[] calldata id_type, SupplyChainLib.CountDetail[] calldata price_quantity) external;
    function get_price_detail_of_product(string calldata product_id, string calldata id_type) external view returns(SupplyChainLib.CountDetail memory);
    function get_list_type_product(string calldata product_id) external view returns(string[] memory);
}

contract Product is IProduct{
    mapping(string => SupplyChainLib.ProductInfo) private products;
    mapping (string=> mapping (string => SupplyChainLib.ProductInfo)) private products_in_actor;
    mapping (string => mapping (string => SupplyChainLib.CountDetail)) count_detail;
    mapping (string => string[]) type_product_detail;

    constructor(){
    }

    function update_status_product(string calldata id, SupplyChainLib.ProductStatus status)public{
        require(bytes(products[id].product_id).length!=0, "product not found");
        products[id].status = status;
    }

    function create(string calldata id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string calldata trans_detail_id, SupplyChainLib.ProductStatus status, string calldata owner, string calldata hash_info) public returns (SupplyChainLib.ProductInfo memory){

        if (product_type == SupplyChainLib.ProductType.SeedlingCompany){
            products[id]= SupplyChainLib.ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, owner, "", status, hash_info);
        }
        else if (product_type == SupplyChainLib.ProductType.Farmer || product_type == SupplyChainLib.ProductType.Manufacturer){
            products[id] = SupplyChainLib.ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, owner, trans_detail_id, status, hash_info);
        }
        else{
            revert("product type invalid");
        }

        products_in_actor[owner][id] = products[id];
        return (products[id]);
    }

    function create_price_detail_of_type(string calldata product_id, string[] calldata id_type, SupplyChainLib.CountDetail[] calldata price_quantity) public {
        require(id_type.length == price_quantity.length, "Input arrays must have the same length");
        for (uint i=0; i<id_type.length; i++ ){
            count_detail[product_id][id_type[i]] = price_quantity[i];
            type_product_detail[product_id].push(id_type[i]);
        }
    }
    function update_price_and_type_of_type(string calldata product_id, string calldata id_type, uint price, uint count) public {
        count_detail[product_id][id_type] = SupplyChainLib.CountDetail(price, count);
    }

    function get_price_detail_of_product(string calldata product_id, string calldata id_type) public view returns(SupplyChainLib.CountDetail memory){
        return count_detail[product_id][id_type];
    }

    function get_list_type_product(string calldata product_id) public view returns(string[] memory){
        return type_product_detail[product_id];
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

    function burn(string calldata id, uint quantity, string calldata id_type) public returns(SupplyChainLib.ProductInfo memory){
        require(bytes(products[id].product_id).length != 0, "Product not found");
        require(products[id].quantity>= quantity, "Product quantity is not enough");
        if (bytes(id_type).length > 0){
            require(count_detail[id][id_type].quantity >= quantity, "Product quantity is not enough");
        }
        products[id].quantity -= quantity;
        products_in_actor[products[id].owner_id][id] = products[id];
        if (bytes(id_type).length > 0){
            count_detail[id][id_type].quantity -= quantity;
        }
        return (products[id]);
    }

}