// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SupplyChainLib.sol";

struct CompanyInfo{
    string id;
    address owner;
}

struct FarmerInfo{
    string id;
    address farmer_ad;
}

struct ManufacturerInfo{
    string id;
    address manufacturer_ad;
}

struct ProductInfo{
    string product_id;
    SupplyChainLib.ProductType product_type;
    uint price;
    uint quantity;
    uint created_at;
    uint updated_at;
    address owner;
    string trans_detail_id;
    SupplyChainLib.ProductStatus status;
}

struct InfoTransaction {
    string id;
    string product_id;
    uint quantity;
    uint created_at;
    address buyer;
}

struct OrderID{
    string id;
    string product_id;
    address created_by;
    uint created_at;
    SupplyChainLib.OrderStatus status;
}