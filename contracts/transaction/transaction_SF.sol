// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Transaction_SF{
    struct InfoTransaction_SF{
        string id;
        address farmer_address;
        uint created_at;
    }

    mapping (string => InfoTransaction_SF) transactions;
    mapping(address => mapping(string => InfoTransaction_SF)) trans_of_farmer;
    mapping(address => InfoTransaction_SF[]) transactions_of_farmer;

    function create(string memory id, address farmer) public returns (InfoTransaction_SF memory){
        InfoTransaction_SF memory new_trans = InfoTransaction_SF(id, farmer, block.timestamp);
        transactions[id] = new_trans;
        trans_of_farmer[farmer][id] = new_trans;
        transactions_of_farmer[farmer].push(new_trans);
        return new_trans;
    }   
    function get_one_by_id(string memory id) public view returns(InfoTransaction_SF memory){
        return transactions[id];
    }

    function get_transactions_by_address(address farmer) public view returns(InfoTransaction_SF[] memory){
        return transactions_of_farmer[farmer];
    }
}