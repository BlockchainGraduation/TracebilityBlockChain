// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "../lib/SupplyChainLib.sol";
import "../lib/Structs.sol";

interface IProduct {
    function create(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string memory trans_detail_id, SupplyChainLib.ProductStatus status) external returns (ProductInfo memory);
    function update(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity) external returns (ProductInfo memory );
    function deleteProduct(string memory id) external;
    function readOneProduct(string memory id) external view returns (string memory,string memory, SupplyChainLib.ProductType, uint, uint, uint, uint, address);
}

contract Product is IProduct{
    mapping(string => ProductInfo) products;
    mapping (address=> mapping (string => ProductInfo)) products_in_company;

    constructor(){
    }

    function create(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string memory trans_detail_id, SupplyChainLib.ProductStatus status) public returns (ProductInfo memory){
         ProductInfo memory new_product;
        if (product_type == SupplyChainLib.ProductType.Seedling){
            new_product=ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, msg.sender, "", status);
        }
        else if (product_type == SupplyChainLib.ProductType.fruit){
            new_product = ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, msg.sender, trans_detail_id, status);
        }
        else{
            revert("product type invalid");
        }
        
        products[id] = new_product;
        products_in_company[msg.sender][id] = new_product;
        return (new_product);
    }

    function update(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity) public returns (ProductInfo memory ){
        ProductInfo memory current_product = products[id];
        require(msg.sender == current_product.owner, "can not update");
        current_product.product_type = product_type;
        current_product.price = price;
        current_product.quantity = quantity;
        products[id] = current_product;
        return (current_product);
    }

    function deleteProduct(string memory id) public {
        if (products[id].owner != msg.sender) {
            revert("You don't have permission to delete this product");
        }

        delete products[id];
    }

    function readOneProduct(string memory id) public view returns (string memory,string memory, SupplyChainLib.ProductType, uint, uint, uint, uint, address) {

        ProductInfo memory product = products[id];
        return (id,product.product_id, product.product_type, product.price, product.quantity, product.created_at, product.updated_at, product.owner);
    }

}