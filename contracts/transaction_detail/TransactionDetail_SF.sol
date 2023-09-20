// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface ITransactionDetail {

    function create(string memory id, string memory trans_id, string memory product_id, uint quantity) external returns (InfoTransDetail memory);

    function get_trans_detail_by_id(string memory id) external view returns (string memory, string memory, string memory, uint, uint);

    function get_trans_detail_by_product(string memory product_id) external view returns (InfoTransDetail[] memory);

    function get_trans_detail_by_trans(string memory trans_id) external view returns (InfoTransDetail[] memory);
}

contract TransactionDetail_SF is ITransactionDetail{
    
    constructor(){}

    mapping (string => InfoTransDetail) internal trans_details;
    mapping (string => InfoTransDetail[]) internal trans_details_of_trans;
    mapping (string => InfoTransDetail[]) internal trans_details_of_product;

    function create(string memory id, string memory trans_id, string memory product_id, uint quantity) public returns (InfoTransDetail memory) {
        InfoTransDetail memory new_trans = InfoTransDetail(id, trans_id, product_id, quantity, block.timestamp);
        trans_details[id] = new_trans;
        trans_details_of_product[product_id].push(new_trans);
        trans_details_of_trans[trans_id].push(new_trans);
        return new_trans;
    }

    function get_trans_detail_by_id(string memory id) public view returns (string memory, string memory, string memory, uint, uint) {
        InfoTransDetail memory detail = trans_details[id];
        require(bytes(detail.id).length != 0, "Transaction detail not found");
        return (detail.id, detail.trans_id, detail.product_id, detail.quantity, detail.created_at);
    }

    function get_trans_detail_by_product(string memory product_id) public view returns (InfoTransDetail[] memory) {
        InfoTransDetail[] memory details = trans_details_of_product[product_id];
        require(details.length > 0, "No transaction details found for this product");
        return details;
    }

    function get_trans_detail_by_trans(string memory trans_id) public view returns (InfoTransDetail[] memory) {
        InfoTransDetail[] memory details = trans_details_of_trans[trans_id];
        require(details.length > 0, "No transaction details found for this transaction");
        return details;
    }
}
