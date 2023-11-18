// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./transaction/Transaction.sol";
import "./marketplace/Marketplace.sol";
import "./actor/ActorManager.sol";
import "./product/ProductManager.sol";
import "./lib/SupplyChainLib.sol";

contract SupplyChain {
    IProductManager iProduct;
    IActorManager iActor;
    ITransaction iTransaction;
    IMarketplace marketplace;

    constructor(address ad_actor, address ad_product) {
        iActor = IActorManager(ad_actor);
        iProduct = IProductManager(ad_product);
        iTransaction = ITransaction(new Transaction());
        marketplace = IMarketplace(new Marketplace());
    }

    function seek_an_origin(
        string calldata product_id
    )
        public
        view
        returns (
            SupplyChainLib.OriginInfo[] memory originInfos
        )
    {
        SupplyChainLib.ProductInfo memory productInfo = iProduct.readOneProduct(product_id);

        if (bytes(productInfo.transaction_id).length == 0) { // đây là sản phẩm của seedling company nên không cần truy vấn nữa
            SupplyChainLib.ActorInfo memory seedlingCompany = iActor.get_Actor_by_id(
                productInfo.owner_id
            );
            originInfos = new SupplyChainLib.OriginInfo[](1);
            originInfos[0]= SupplyChainLib.OriginInfo(productInfo, seedlingCompany, SupplyChainLib.InfoTransaction("", "", 0, 0, ""));
        } else {
            if (productInfo.product_type == SupplyChainLib.ProductType.Farmer ){
                SupplyChainLib.InfoTransaction memory transaction = iTransaction
                .get_trans_detail_by_id(productInfo.transaction_id);

                SupplyChainLib.ActorInfo memory farmer1 = iActor.get_Actor_by_id(
                    productInfo.owner_id
                );

                SupplyChainLib.ProductInfo memory originProductInfo = iProduct.readOneProduct(
                    transaction.product_id
                );

                SupplyChainLib.ActorInfo memory seedlingCompany = iActor.get_Actor_by_id(
                    originProductInfo.owner_id
                );

                originInfos = new SupplyChainLib.OriginInfo[](2);
                originInfos[0]= SupplyChainLib.OriginInfo(originProductInfo, seedlingCompany, SupplyChainLib.InfoTransaction("", "", 0, 0, ""));
                originInfos[1]= SupplyChainLib.OriginInfo(productInfo, farmer1,transaction);
            }
            else{
                // manufacturor
                SupplyChainLib.InfoTransaction memory transaction = iTransaction
                .get_trans_detail_by_id(productInfo.transaction_id);

                SupplyChainLib.ActorInfo memory manufacturor = iActor.get_Actor_by_id(
                    productInfo.owner_id
                );
                // famer
                SupplyChainLib.ProductInfo memory famerProduct = iProduct.readOneProduct(
                    transaction.product_id
                );

                SupplyChainLib.ActorInfo memory farmer = iActor.get_Actor_by_id(
                    famerProduct.owner_id
                );
                SupplyChainLib.InfoTransaction memory transaction_sf = iTransaction
                .get_trans_detail_by_id(famerProduct.transaction_id);

                // seedling company
                SupplyChainLib.ProductInfo memory originProductInfo = iProduct.readOneProduct(
                    transaction_sf.product_id
                );

                SupplyChainLib.ActorInfo memory seedlingCompany = iActor.get_Actor_by_id(
                    originProductInfo.owner_id
                );

                originInfos = new SupplyChainLib.OriginInfo[](3);
                originInfos[0]= SupplyChainLib.OriginInfo(originProductInfo, seedlingCompany, SupplyChainLib.InfoTransaction("", "", 0, 0, ""));
                originInfos[1]= SupplyChainLib.OriginInfo(famerProduct, farmer,transaction_sf);
                originInfos[2]= SupplyChainLib.OriginInfo(productInfo, manufacturor,transaction);
            }
        }
        return originInfos;
    }

    function listing_product(
        string calldata id,
        string calldata product_id,
        string calldata owner
    ) public returns (SupplyChainLib.MarketplaceItem memory) {
        SupplyChainLib.ProductInfo memory p = iProduct.readOneProduct(product_id);
        if (
            keccak256(abi.encodePacked(p.owner_id)) !=
            keccak256(abi.encodePacked(owner))
        ) {
            revert("you not owner");
        }
        return
            marketplace.create_item_marketplace(id, product_id, owner);
    }


    function get_list_item_in_marketplace()
        public
        view
        returns (string[] memory)
    {
        return marketplace.get_ids();
    }

    function buy_item_on_marketplace(string calldata product_id, string calldata trans_id, string calldata user_id, uint quantity) public {
        SupplyChainLib.ProductInfo memory current_product = iProduct.readOneProduct(product_id);
        require(bytes(current_product.product_id).length>0, "product not found");
        require(current_product.status == SupplyChainLib.ProductStatus.Puhlish, "product is not puhlish");
        require(!iActor.check_actor_is_exist(user_id), "User not exsit");
        iTransaction.create(trans_id, product_id, quantity, user_id);
        iProduct.burn(product_id, quantity);
    }

    function get_transaction_by_id(string calldata trans_id) public view returns(SupplyChainLib.InfoTransaction memory){
        return iTransaction.get_trans_detail_by_id(trans_id);
    }

}
