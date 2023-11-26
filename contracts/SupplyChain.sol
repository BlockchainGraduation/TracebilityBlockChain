// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./transaction/Transaction.sol";
import "./actor/ActorManager.sol";
import "./product/ProductManager.sol";
import "./lib/SupplyChainLib.sol";

contract SupplyChain {
    IProductManager iProduct;
    IActorManager iActor;
    ITransaction iTransaction;

    constructor(address ad_actor, address ad_product) {
        iActor = IActorManager(ad_actor);
        iProduct = IProductManager(ad_product);
        iTransaction = ITransaction(new Transaction());
    }

    function seek_an_origin(
        string calldata product_id
    ) public view returns (SupplyChainLib.OriginInfo[] memory originInfos) {
        SupplyChainLib.ProductInfo memory productInfo = iProduct.readOneProduct(
            product_id
        );

        if (bytes(productInfo.transaction_id).length == 0) {
            // đây là sản phẩm của seedling company nên không cần truy vấn nữa
            SupplyChainLib.ActorInfo memory seedlingCompany = iActor
                .get_Actor_by_id(productInfo.owner_id);
            originInfos = new SupplyChainLib.OriginInfo[](1);
            originInfos[0] = SupplyChainLib.OriginInfo(
                productInfo,
                seedlingCompany,
                SupplyChainLib.TransactionInfo(
                    "",
                    "",
                    0,
                    0,
                    "",
                    SupplyChainLib.TransactionStatus.PENDING
                )
            );
        } else {
            if (productInfo.product_type == SupplyChainLib.ProductType.Retailer) {
                SupplyChainLib.TransactionInfo memory transaction = iTransaction
                    .get_trans_detail_by_id(productInfo.transaction_id);

                SupplyChainLib.ActorInfo memory farmer1 = iActor
                    .get_Actor_by_id(productInfo.owner_id);

                SupplyChainLib.ProductInfo memory originProductInfo = iProduct
                    .readOneProduct(transaction.product_id);

                SupplyChainLib.ActorInfo memory seedlingCompany = iActor
                    .get_Actor_by_id(originProductInfo.owner_id);

                originInfos = new SupplyChainLib.OriginInfo[](2);
                originInfos[0] = SupplyChainLib.OriginInfo(
                    originProductInfo,
                    seedlingCompany,
                    SupplyChainLib.TransactionInfo(
                        "",
                        "",
                        0,
                        0,
                        "",
                        SupplyChainLib.TransactionStatus.PENDING
                    )
                );
                originInfos[1] = SupplyChainLib.OriginInfo(
                    productInfo,
                    farmer1,
                    transaction
                );
            } else {
                // manufacturor
                SupplyChainLib.TransactionInfo memory transaction = iTransaction
                    .get_trans_detail_by_id(productInfo.transaction_id);

                SupplyChainLib.ActorInfo memory manufacturor = iActor
                    .get_Actor_by_id(productInfo.owner_id);
                // famer
                SupplyChainLib.ProductInfo memory famerProduct = iProduct
                    .readOneProduct(transaction.product_id);

                SupplyChainLib.ActorInfo memory farmer = iActor.get_Actor_by_id(
                    famerProduct.owner_id
                );
                SupplyChainLib.TransactionInfo
                    memory transaction_sf = iTransaction.get_trans_detail_by_id(
                        famerProduct.transaction_id
                    );

                // seedling company
                SupplyChainLib.ProductInfo memory originProductInfo = iProduct
                    .readOneProduct(transaction_sf.product_id);

                SupplyChainLib.ActorInfo memory seedlingCompany = iActor
                    .get_Actor_by_id(originProductInfo.owner_id);

                originInfos = new SupplyChainLib.OriginInfo[](3);
                originInfos[0] = SupplyChainLib.OriginInfo(
                    originProductInfo,
                    seedlingCompany,
                    SupplyChainLib.TransactionInfo(
                        "",
                        "",
                        0,
                        0,
                        "",
                        SupplyChainLib.TransactionStatus.PENDING
                    )
                );
                originInfos[1] = SupplyChainLib.OriginInfo(
                    famerProduct,
                    farmer,
                    transaction_sf
                );
                originInfos[2] = SupplyChainLib.OriginInfo(
                    productInfo,
                    manufacturor,
                    transaction
                );
            }
        }
        return originInfos;
    }

    function listing_product(
        string calldata product_id,
        string calldata owner
    ) public {
        SupplyChainLib.ProductInfo memory p = iProduct.readOneProduct(
            product_id
        );
        if (
            keccak256(abi.encodePacked(p.owner_id)) !=
            keccak256(abi.encodePacked(owner))
        ) {
            revert("you not owner");
        }
        iProduct.update_status_product(
            product_id,
            SupplyChainLib.ProductStatus.Puhlish
        );
    }

    function buy_item_on_marketplace(
        string calldata product_id,
        string calldata trans_id,
        string calldata user_id,
        uint quantity,
        string calldata id_type
    ) public {
        SupplyChainLib.ProductInfo memory current_product = iProduct
            .readOneProduct(product_id);
        require(
            bytes(current_product.product_id).length > 0,
            "product not found"
        );
        require(
            current_product.status == SupplyChainLib.ProductStatus.Puhlish,
            "product is not puhlish"
        );
        require(!iActor.check_actor_is_exist(user_id), "User not exsit");
        uint price =  iProduct.burn(product_id, quantity, id_type);
        iActor.withdraw_balance(user_id, (quantity*price));
        iActor.deposited(current_product.owner_id, (quantity*price));
        iTransaction.create(
            trans_id,
            product_id,
            quantity,
            user_id,
            SupplyChainLib.TransactionStatus.PENDING
        );
    }

    function get_transaction_by_id(
        string calldata trans_id
    ) public view returns (SupplyChainLib.TransactionInfo memory) {
        return iTransaction.get_trans_detail_by_id(trans_id);
    }

    function update_status_transaction(string calldata id, SupplyChainLib.TransactionStatus status) public{
        iTransaction.update_status_transaction(id, status);
    }
}
