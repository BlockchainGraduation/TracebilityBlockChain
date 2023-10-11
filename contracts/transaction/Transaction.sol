// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";
import "../product/Product.sol";

interface ITransaction {

    function create(string memory id, string memory product_id, uint quantity, string memory buyer) external returns (InfoTransaction memory);

    function get_trans_detail_by_id(string memory id) external view returns (InfoTransaction memory);

    function get_trans_detail_by_product(string memory product_id) external view returns (InfoTransaction[] memory);

    function get_transaction_history_of_buyer(string memory buyer) external view returns (InfoTransaction[] memory);

    function get_trans_of_buyer_by_product(string memory buyer, string memory product_id) external view returns(InfoTransaction memory);
}

contract Transaction is ITransaction{
    
    IProduct product;
    constructor(address product_address){
        product = IProduct(product_address);
    }

    mapping (string => InfoTransaction) public trans_details;
    mapping (string => InfoTransaction[]) public trans_details_of_product;
    mapping (string => mapping(string => InfoTransaction)) public trans_of_buyer;
    mapping (string => InfoTransaction[]) public trans_history_of_buyer;

    function create(string memory id, string memory product_id, uint quantity, string memory buyer) public returns (InfoTransaction memory) {
        product.burn(product_id, quantity);
        trans_details[id]= InfoTransaction(id, product_id, quantity, block.timestamp, buyer);
        trans_details_of_product[product_id].push(trans_details[id]);
        trans_history_of_buyer[buyer].push(trans_details[id]);
        trans_of_buyer[buyer][product_id]=trans_details[id];
        return trans_details[id];
    }

    function get_trans_detail_by_id(string memory id) public view returns (InfoTransaction memory) {
        require(bytes(trans_details[id].id).length != 0, "Transaction detail not found");
        return (trans_details[id]);
    }

    function get_trans_detail_by_product(string memory product_id) public view returns (InfoTransaction[] memory) {
        require(trans_details_of_product[product_id].length > 0, "No transaction details found for this product");
        return trans_details_of_product[product_id];
    }

    function get_transaction_history_of_buyer(string memory buyer) public view returns (InfoTransaction[] memory){
        require(trans_history_of_buyer[buyer].length>0, "No transaction found");
        return trans_history_of_buyer[buyer];
    }

    function get_trans_of_buyer_by_product(string memory buyer, string memory product_id) public view returns(InfoTransaction memory){
        require(bytes(trans_of_buyer[buyer][product_id].id).length != 0, "Transaction detail not found");
        return trans_of_buyer[buyer][product_id];
    }
}
