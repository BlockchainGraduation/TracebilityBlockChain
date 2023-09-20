// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface ITransaction_SF {

    function create(string memory id, address farmer) external returns (InfoTransaction_SF memory);

    function get_one_by_id(string memory id) external view returns (string memory, address, uint);

    function get_transactions_by_address(address farmer) external view returns (InfoTransaction_SF[] memory);
}


contract Transaction_SF is ITransaction_SF {

    constructor(){}

    mapping (string => InfoTransaction_SF) transactions;
    mapping (address => mapping(string => InfoTransaction_SF)) trans_of_farmer;
    mapping (address => InfoTransaction_SF[]) transactions_of_farmer;

    function create(string memory id, address farmer) public returns (InfoTransaction_SF memory) {
        InfoTransaction_SF memory new_trans = InfoTransaction_SF(id, farmer, block.timestamp);
        transactions[id] = new_trans;
        trans_of_farmer[farmer][id] = new_trans;
        transactions_of_farmer[farmer].push(new_trans);
        return new_trans;
    }   

    function get_one_by_id(string memory id) public view returns (string memory, address, uint) {
        InfoTransaction_SF memory detail = transactions[id];
        require(bytes(detail.id).length != 0, "Transaction not found");
        return (detail.id, detail.farmer_address, detail.created_at);
    }

    function get_transactions_by_address(address farmer) public view returns (InfoTransaction_SF[] memory) {
        InfoTransaction_SF[] memory details = transactions_of_farmer[farmer];
        require(details.length > 0, "No transactions found for this farmer");
        return details;
    }
}
