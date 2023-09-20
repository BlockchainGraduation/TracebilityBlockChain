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
    address Manufacturer_ad;
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

struct InfoTransaction_SF {
        string id;
        address farmer_address;
        uint created_at;
    }

struct InfoTransaction_FM{
        string id;
        address manufacturer_ad;
        uint created_at;
    }  

struct InfoTransDetail {
        string id;
        string trans_id;
        string product_id;
        uint quantity;
        uint created_at;
    }