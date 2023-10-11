// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./product/Product.sol";
import "./transaction/Transaction.sol";
import "./lib/Structs.sol";
import "./marketplace/Marketplace.sol";
import "./actor/Actor.sol";

contract SupplyChain{
    IProduct product;
    IActor farmer;
    IActor manufacturer;
    IActor seed_company;
    ITransaction trans_FM;
    ITransaction trans_SF;
    IMarketplace marketplace;
    mapping (string =>address) public map_address;


    constructor(){
        map_address["product"] = (address(new Product()));
        map_address["seedCompany"] = address(new Actor());
        map_address["farmer"] = address(new Actor());
        map_address["manufacture"] = address(new Actor());
        map_address["ad_trans_FM"] = address(new Transaction(map_address["product"]));
        map_address["ad_trans_SF"] = address(new Transaction(map_address["product"]));
        map_address["marketplace"] = address(new Marketplace(map_address["product"], map_address["ad_trans_SF"], map_address["ad_trans_FM"]));

        product = IProduct(map_address["product"]);
        farmer = IActor(map_address["farmer"]);
        manufacturer = IActor(map_address["manufacture"]);
        seed_company = IActor(map_address["seedCompany"]);
        trans_FM = ITransaction(map_address["ad_trans_FM"]);
        trans_SF = ITransaction(map_address["ad_trans_SF"]);
        marketplace = IMarketplace(map_address["marketplace"]);
    }
    mapping (string => SupplyChainLib.Role) role_users;
    

    function create_actor(string memory id, address ad_actor, SupplyChainLib.Role type_actor) public returns (ActorInfo memory){
        if (type_actor == SupplyChainLib.Role.SeedlingCompany){
            require(!seed_company.check_actor_is_exist(id),"id user is already exist");
            role_users[id] = type_actor;
            return seed_company.create(id, ad_actor, type_actor);
        }
        else if (type_actor == SupplyChainLib.Role.Farmer){
            require(!farmer.check_actor_is_exist(id),"id user is already exist");
            role_users[id] = type_actor;
            return farmer.create(id, ad_actor, type_actor);
        }
        else if (type_actor == SupplyChainLib.Role.Manufacturer){
            require(!manufacturer.check_actor_is_exist(id),"id user is already exist");
            role_users[id] = type_actor;
            return manufacturer.create(id, ad_actor, type_actor);
        }
        else{
            revert("type_actor is not exist");
        }
    }

    function create_product(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity,string memory trans_detail_id, 
                            SupplyChainLib.ProductStatus status, string memory owner) public returns (ProductInfo memory){
        require(!product.check_product_is_exist(id), "id product is already exist");
        if (product_type == SupplyChainLib.ProductType.Seedling){
            require(seed_company.check_actor_is_exist(owner),"id user is not exist");
            return product.create(id, product_type, price, quantity, "" , status, owner);
        }
        else if (product_type == SupplyChainLib.ProductType.Fruit){
            require(farmer.check_actor_is_exist(owner),"id user is not exist");
            return product.create(id, product_type, price, quantity, trans_detail_id, status, owner);
        }
        else{
            revert("ProductType is not exist");
        }
    }


    function get_list_actor(uint type_actor) public view returns (ActorInfo[] memory){
        if (type_actor == 0) {
            return seed_company.get_list_Actor();
        }
        else if (type_actor ==1 ){
            return farmer.get_list_Actor();
        }
        else if (type_actor ==2){
            return manufacturer.get_list_Actor();
        }
        else{
            revert("type actor not exist");
        }
    }

    function create_transaction(string memory id, string memory product_id, uint quantity, string memory buyer, int type_trans) public returns(InfoTransaction memory){
        if (type_trans == 0){
            require(role_users[buyer] == SupplyChainLib.Role.Farmer, "only farmer access");
            require(product.check_product_is_exist(id), "id product is already exist");
            return trans_SF.create(id, product_id, quantity, buyer);
        }
        else if (type_trans == 1){
            require(role_users[buyer] == SupplyChainLib.Role.Manufacturer, "only Manufacturer access");
            require(product.check_product_is_exist(id), "id product is already exist");
            return trans_FM.create(id, product_id, quantity, buyer);
        }
        else{
            revert("type transaction is not exist");
        }
        
    }

    function seek_an_origin(string memory product_id) 
        public 
        view
        returns (
            ProductInfo memory, 
            ActorInfo memory,
            InfoTransaction memory,
            ProductInfo memory,
            ActorInfo memory
        ) 
        {

        ProductInfo memory productInfo = product.readOneProduct(product_id);

        if (bytes(productInfo.transaction_id).length == 0) {

            ActorInfo memory seedlingCompany = seed_company.get_Actor_by_id(productInfo.owner_id);

            return (
            productInfo,
            seedlingCompany,
            InfoTransaction("", "", 0, 0, ""),
            ProductInfo("", SupplyChainLib.ProductType.None, 0, 0, 0, 0, "", "", SupplyChainLib.ProductStatus.None ),
            ActorInfo("", address(0), SupplyChainLib.Role.SeedlingCompany)  
            );

        } else {

            InfoTransaction memory transaction = trans_SF.get_trans_detail_by_id(productInfo.transaction_id);

            ActorInfo memory farmer1 = farmer.get_Actor_by_id(productInfo.owner_id);

            ProductInfo memory originProductInfo = product.readOneProduct(transaction.product_id);

            ActorInfo memory seedlingCompany = seed_company.get_Actor_by_id(originProductInfo.owner_id);

            return (
            productInfo,
            farmer1,
            transaction,
            originProductInfo,
            seedlingCompany
            );
        
        }

    }

    function listing_product(string memory id,string memory product_id, string memory owner,SupplyChainLib.OrderStatus status) public returns(MarketplaceItem memory){
        ProductInfo memory p = product.readOneProduct(product_id);
        if (keccak256(abi.encodePacked(p.owner_id)) != keccak256(abi.encodePacked(owner))){
            revert("you not owner");
        }
        return marketplace.create_item_marketplace(id, product_id, owner, status);
    }

    function buy_product_in_market(string memory id, uint quantity, string memory buyer, string memory id_trans) public returns(InfoTransaction memory){
        return marketplace.buy_item_marketplace(id, quantity, buyer, id_trans);
    }


    function get_list_item_in_marketplace()public view returns (string[] memory){
        return marketplace.get_ids();
    }
}