// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lib/Structs.sol";
import "./lib/SupplyChainLib.sol";

contract MarketPlace{
    mapping(string => OrderID) orders;
    mapping(address =>mapping(string => OrderID)) order_of_entity;
    mapping(SupplyChainLib.OrderStatus => mapping(string => OrderID)) orders_of_status;
    

}