// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SupplyChainLib{
    enum ProductType {None, Manufacturer, Retailer, EndUser}
    enum ProductStatus {None, Private, Puhlish, Closed}
    enum Role {Manufacturer, Retailer, EndUser}
    enum TransactionStatus{PENDING, DONE, UNSUCCESSFUL}

    struct ActorInfo {
        string id;
        address owner;
        Role role;
        string hash_info;
        uint balance;
    }

    struct CountDetail{
        uint price;
        uint quantity;
    }

    struct ProductInfo {
        string product_id;
        ProductType product_type;
        uint price;
        uint quantity;
        uint created_at;
        uint updated_at;
        string owner_id;
        string transaction_id;
        ProductStatus status;
        string hash_info;
    }

    struct TransactionInfo {
        string id;
        string product_id;
        uint quantity;
        uint created_at;
        string buyer_id;
        TransactionStatus status;
    }


    struct OriginInfo {
        ProductInfo productInfo;
        ActorInfo ownerInfo;
        TransactionInfo transactionInfo;
    }
}