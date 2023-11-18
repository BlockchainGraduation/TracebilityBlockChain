// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SupplyChainLib{
    enum ProductType {None, SeedlingCompany, Farmer, Manufacturer}
    enum ProductStatus {None, Private, Puhlish, Closed}
    enum Role {SeedlingCompany, Farmer, Manufacturer}

    struct ActorInfo {
        string id;
        address owner;
        SupplyChainLib.Role role;
    }

    struct GrowUpDetail {
        string url;
        uint date_update;
    }

    struct ProductInfo {
        string product_id;
        SupplyChainLib.ProductType product_type;
        uint price;
        uint quantity;
        uint created_at;
        uint updated_at;
        string owner_id;
        string transaction_id;
        SupplyChainLib.ProductStatus status;
        string hash_info;
    }

    struct InfoTransaction {
        string id;
        string product_id;
        uint quantity;
        uint created_at;
        string buyer_id;
    }

    struct MarketplaceItem {
        string itemId;
        string product_id;
        string owner_id;
    }

    struct OriginInfo {
        ProductInfo productInfo;
        ActorInfo ownerInfo;
        InfoTransaction transactionInfo;
    }
}