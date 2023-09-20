// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lib/SupplyChainLib.sol";

contract Product{
    struct ProductInfo{
        string product_id;
        SupplyChainLib.ProductType product_type;
        uint price;
        uint quantity;
        uint created_at;
        uint updated_at;
        address owner;
    }
    mapping(string => ProductInfo) products;
    mapping (address=> mapping (string => ProductInfo)) products_in_company;
    // address[] companys;

    constructor(){
    }

    function create(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity) public returns (string memory, ProductInfo memory){
        ProductInfo memory new_product = ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, msg.sender);
        products[id] = new_product;
        products_in_company[msg.sender][id] = new_product;
        return ((id), new_product);
    }

    function update(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity) public returns (string memory, ProductInfo memory ){
        ProductInfo memory current_product = products[id];
        require(msg.sender == current_product.owner, "can not update");
        current_product.product_type = product_type;
        current_product.price = price;
        current_product.quantity = quantity;
        products[id] = current_product;
        return (id, current_product);
    }

    function deleteProduct(string memory id) public {
        // require(id < current_index, "Product with this ID does not exist"); 
        if (products[id].owner != msg.sender) {
            revert("You don't have permission to delete this product");
        }

        delete products[id];
    }

    function readOneProduct(string memory id) public view returns (string memory,string memory, SupplyChainLib.ProductType, uint, uint, uint, uint, address) {
        // require(id < current_index, "Product with this ID does not exist");

        ProductInfo memory product = products[id];
        return (id,product.product_id, product.product_type, product.price, product.quantity, product.created_at, product.updated_at, product.owner);
    }

}