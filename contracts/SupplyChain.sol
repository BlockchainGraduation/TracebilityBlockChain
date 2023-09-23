// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./product/Product.sol";
import "./farmer/Farmer.sol";
import "./manufacturer/Manufacturer.sol";
import "./seed/SeedlingCompany.sol";
import "./transaction/Transaction.sol";
import "./lib/Structs.sol";
import "./Marketplace.sol";

contract SupplyChain{
    IProduct product;
    IFarmer farmer;
    IManufacturer manufacturer;
    ISeedlingCompany seed_company;
    ITransaction trans_FM;
    ITransaction trans_SF;
    IMarketplace marketplace;


    constructor(){
        address product_ad = (address(new Product()));
        product = IProduct(product_ad);
        farmer = IFarmer(address(new Farmer()));
        manufacturer = IManufacturer(address(new Manufacturer()));
        seed_company = ISeedlingCompany(address(new SeedlingCompany()));
        address ad_trans_FM = address(new Transaction(product_ad));
        address ad_trans_SF = address(new Transaction(product_ad));
        trans_FM = ITransaction(ad_trans_FM);
        trans_SF = ITransaction(ad_trans_SF);
        marketplace = IMarketplace(address(new Marketplace(product_ad, ad_trans_SF, ad_trans_FM)));
    }

    mapping (string => SupplyChainLib.Role) role_users;
    

    function create_actor(string memory id, address ad_actor, SupplyChainLib.Role type_actor) public returns (ActorInfo memory){
        if (type_actor == SupplyChainLib.Role.SeedlingCompany){
            role_users[id] = type_actor;
            return seed_company.create(id, ad_actor);
        }
        else if (type_actor == SupplyChainLib.Role.Farmer){
            role_users[id] = type_actor;
            return farmer.create(id, ad_actor);
        }
        else if (type_actor == SupplyChainLib.Role.Manufacturer){
            role_users[id] = type_actor;
            return manufacturer.create(id, ad_actor);
        }
        else{
            revert("type_actor is not exist");
        }
    }

    function create_product(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity,string memory trans_detail_id, 
                            SupplyChainLib.ProductStatus status, string memory owner) public returns (ProductInfo memory){
        require(product.check_product_is_exist(id), "id product is already exist");
        if (product_type == SupplyChainLib.ProductType.Seedling){
            return product.create(id, product_type, price, quantity, "" , status, owner);
        }
        else if (product_type == SupplyChainLib.ProductType.Fruit){
            return product.create(id, product_type, price, quantity, trans_detail_id, status, owner);
        }
        else{
            revert("ProductType is not exist");
        }
    }


    function get_list_actor(uint type_actor) public view returns (ActorInfo[] memory){
        if (type_actor == 0) {
            return seed_company.get_list_seedling_company();
        }
        else if (type_actor ==1 ){
            return farmer.get_list_farmer();
        }
        else if (type_actor ==2){
            return manufacturer.get_list_manufactuter();
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

            ActorInfo memory seedlingCompany = seed_company.get_seedling_company_by_id(productInfo.owner_id);

            return (
            productInfo,
            seedlingCompany,
            InfoTransaction("", "", 0, 0, ""),
            ProductInfo("", SupplyChainLib.ProductType.None, 0, 0, 0, 0, "", "", SupplyChainLib.ProductStatus.None ),
            ActorInfo("", address(0))  
            );

        } else {

            InfoTransaction memory transaction = trans_SF.get_trans_detail_by_id(productInfo.transaction_id);

            ActorInfo memory farmer1 = farmer.get_farmer_by_id(productInfo.owner_id);

            ProductInfo memory originProductInfo = product.readOneProduct(transaction.product_id);

            ActorInfo memory seedlingCompany = seed_company.get_seedling_company_by_id(originProductInfo.owner_id);

            return (
            productInfo,
            farmer1,
            transaction,
            originProductInfo,
            seedlingCompany
            );
        
        }

    }

    function get_detail_product(string memory id) public view returns(ProductInfo memory){
        return product.readOneProduct(id);
    }

    function get_trans_SF_detail_by_id(string memory id) public view returns (InfoTransaction memory) {
        return trans_SF.get_trans_detail_by_id(id);
    }

    function get_trans_SF_detail_by_product(string memory product_id) public view returns (InfoTransaction[] memory) {
        return trans_SF.get_trans_detail_by_product(product_id);
    }

    function get_trans_SF_history_of_buyer(string memory buyer) public view returns (InfoTransaction[] memory){
        return trans_SF.get_transaction_history_of_buyer(buyer);
    }

    function get_trans_SF_of_buyer_by_product(string memory buyer, string memory product_id) public view returns(InfoTransaction memory){
        return trans_SF.get_trans_of_buyer_by_product(buyer, product_id);
    }

    function get_trans_FM_detail_by_id(string memory id) public view returns (InfoTransaction memory) {
        return trans_FM.get_trans_detail_by_id(id);
    }

    function get_trans_FM_detail_by_product(string memory product_id) public view returns (InfoTransaction[] memory) {
        return trans_FM.get_trans_detail_by_product(product_id);
    }

    function get_trans_FM_history_of_buyer(string memory buyer) public view returns (InfoTransaction[] memory){
        return trans_FM.get_transaction_history_of_buyer(buyer);
    }

    function get_trans_FM_of_buyer_by_product(string memory buyer, string memory product_id) public view returns(InfoTransaction memory){
        return trans_FM.get_trans_of_buyer_by_product(buyer, product_id);
    }
}