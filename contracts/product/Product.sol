// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "../lib/SupplyChainLib.sol";
import "../lib/Structs.sol";

interface IProduct {
    function create(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string memory trans_detail_id, SupplyChainLib.ProductStatus status, string memory owner) external returns (ProductInfo memory);
    function update(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity) external returns (ProductInfo memory );
    function deleteProduct(string memory id) external;
    function readOneProduct(string memory id) external view returns (ProductInfo memory );
    function burn(string memory id, uint quantity) external returns(ProductInfo memory);
    function check_product_is_exist(string memory) external view returns(bool);
}

contract Product is IProduct{
    mapping(string => ProductInfo) public products;
    mapping (string=> mapping (string => ProductInfo)) public products_in_company;

    constructor(){
    }

    function create(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity, string memory trans_detail_id, SupplyChainLib.ProductStatus status, string memory owner) public returns (ProductInfo memory){
        
        if (product_type == SupplyChainLib.ProductType.Seedling){
            products[id]=ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, owner, "", status);
        }
        else if (product_type == SupplyChainLib.ProductType.Fruit){
            products[id] = ProductInfo(id, product_type, price, quantity, block.timestamp, block.timestamp, owner, trans_detail_id, status);
        }
        else{
            revert("product type invalid");
        }
        
        products_in_company[owner][id] = products[id];
        return (products[id]);
    }

    function update(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity) public returns (ProductInfo memory ){
        products[id].product_type = product_type;
        products[id].price = price;
        products[id].quantity = quantity;
        products_in_company[products[id].owner_id][id] = products[id];
        return (products[id]);
    }

    function deleteProduct(string memory id) public {
        // if (products[id].owner != msg.sender) {
        //     revert("You don't have permission to delete this product");
        // }

        delete products[id];
    }

    function readOneProduct(string memory id) public view returns (ProductInfo memory ) {
        return products[id]; 
    }

    function burn(string memory id, uint quantity) public returns(ProductInfo memory){
        require(bytes(products[id].product_id).length != 0, "Product not found");
        require(products[id].quantity>= quantity, "Product quantity is not enough");
        products[id].quantity -= quantity;
        products_in_company[products[id].owner_id][id] = products[id];
        return (products[id]);
    }
    function check_product_is_exist(string memory id) public view returns(bool){
        if (bytes(products[id].product_id).length != 0){
            return true;
        }
        return false;
    }
    

}