// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/SupplyChainLib.sol";
// import "../product/Product.sol";
import "../actor/ActorManager.sol";

interface ITransaction {

    function create(string calldata id, string calldata product_id, uint quantity, string calldata buyer, SupplyChainLib.TransactionStatus status) external;

    function update_status_transaction(string calldata id, SupplyChainLib.TransactionStatus status) external;

    function get_trans_detail_by_id(string calldata id) external view returns (SupplyChainLib.TransactionInfo memory);

    function get_trans_detail_by_product(string calldata product_id) external view returns (SupplyChainLib.TransactionInfo[] memory);

    function get_transaction_history_of_buyer(string calldata buyer) external view returns (SupplyChainLib.TransactionInfo[] memory);

    function get_trans_of_buyer_by_product(string calldata buyer, string calldata product_id) external view returns(SupplyChainLib.TransactionInfo memory);
}

contract Transaction is ITransaction{

    constructor(){
    }
    IActorManager iActor;
    mapping (string => SupplyChainLib.TransactionInfo) public trans_details;
    mapping (string => SupplyChainLib.TransactionInfo[]) public trans_details_of_product;
    mapping (string => mapping(string => SupplyChainLib.TransactionInfo)) public trans_of_buyer;
    mapping (string => SupplyChainLib.TransactionInfo[]) public trans_history_of_buyer;

    function create(string calldata id, string calldata product_id, uint quantity, string calldata buyer, SupplyChainLib.TransactionStatus status) public {
        trans_details[id]= SupplyChainLib.TransactionInfo(id, product_id, quantity, block.timestamp, buyer, status);
        trans_details_of_product[product_id].push(trans_details[id]);
        trans_history_of_buyer[buyer].push(trans_details[id]);
        trans_of_buyer[buyer][product_id]=trans_details[id];
    }

    function update_status_transaction(string calldata id, SupplyChainLib.TransactionStatus status) public{
        trans_details[id].status = status;
        trans_of_buyer[trans_details[id].buyer_id][trans_details[id].product_id] = trans_details[id];
    }

    function get_trans_detail_by_id(string calldata id) public view returns (SupplyChainLib.TransactionInfo memory) {
        require(bytes(trans_details[id].id).length != 0, "Transaction detail not found");
        return (trans_details[id]);
    }

    function get_trans_detail_by_product(string calldata product_id) public view returns (SupplyChainLib.TransactionInfo[] memory) {
        require(trans_details_of_product[product_id].length > 0, "No transaction details found for this product");
        return trans_details_of_product[product_id];
    }

    function get_transaction_history_of_buyer(string calldata buyer) public view returns (SupplyChainLib.TransactionInfo[] memory){
        require(trans_history_of_buyer[buyer].length>0, "No transaction found");
        return trans_history_of_buyer[buyer];
    }

    function get_trans_of_buyer_by_product(string calldata buyer, string calldata product_id) public view returns(SupplyChainLib.TransactionInfo memory){
        require(bytes(trans_of_buyer[buyer][product_id].id).length != 0, "Transaction detail not found");
        return trans_of_buyer[buyer][product_id];
    }
}
