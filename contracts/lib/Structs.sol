// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SupplyChainLib.sol";

struct ActorInfo{
    string id;
    address owner;
}

struct ProductInfo{
    string product_id;
    SupplyChainLib.ProductType product_type;
    uint price;
    uint quantity;
    uint created_at;
    uint updated_at;
    string owner_id;
    string transaction_id;
    SupplyChainLib.ProductStatus status;
}

struct InfoTransaction {
    string id;
    string product_id;
    uint quantity;
    uint created_at;
    string buyer_id;
}

struct OrderID{
    string id;
    string product_id;
    string created_by;
    uint created_at;
    SupplyChainLib.OrderStatus status;
}

struct MarketplaceItem {
    string itemId;
    string product_id;
    string owner_id;
    SupplyChainLib.OrderStatus status;
}