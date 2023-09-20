// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";



interface ITransaction_FM {

    function create(string memory id, address manufacturer) external returns (InfoTransaction_FM memory);

    function get_one_by_id(string memory id) external view returns (string memory, address, uint);

    function get_transactions_by_address(address manufacturer) external view returns (InfoTransaction_FM[] memory);
}


contract Transaction_FM is ITransaction_FM{

    constructor(){}

    mapping (string => InfoTransaction_FM) trans_FM;
    mapping (address => InfoTransaction_FM[]) trans_of_M;
    mapping(address => mapping(string => InfoTransaction_FM)) trans_of_M_detail;

    function create(string memory id, address manufacturer) public returns (InfoTransaction_FM memory) {
        InfoTransaction_FM memory new_trans = InfoTransaction_FM(id, manufacturer, block.timestamp);
        trans_FM[id] = new_trans;
        trans_of_M_detail[manufacturer][id] = new_trans;
        trans_of_M[manufacturer].push(new_trans);
        return new_trans;
    }   

    function get_one_by_id(string memory id) public view returns (string memory, address, uint) {
        InfoTransaction_FM memory detail = trans_FM[id];
        require(bytes(detail.id).length != 0, "Transaction not found");
        return (detail.id, detail.manufacturer_ad, detail.created_at);
    }

    function get_transactions_by_address(address manufacturer) public view returns (InfoTransaction_FM[] memory) {
        InfoTransaction_FM[] memory details = trans_of_M[manufacturer];
        require(details.length > 0, "No transactions found for this manufacturer");
        return details;
    }
}