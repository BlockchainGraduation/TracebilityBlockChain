// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./product/Product.sol";
import "./farmer/Farmer.sol";
import "./manufacturer/Manufacturer.sol";
import "./seed/SeedlingCompany.sol";
import "./transaction/Transaction.sol";
import "./lib/Structs.sol";

contract SupplyChain{
    IProduct product;
    IFarmer farmer;
    IManufacturer manufacturer;
    ISeedlingCompany seed_company;
    ITransaction trans_FM;
    ITransaction trans_SF;


    constructor(){
        address product_ad = (address(new Product()));
        product = IProduct(product_ad);
        farmer = IFarmer(address(new Farmer()));
        manufacturer = IManufacturer(address(new Manufacturer()));
        seed_company = ISeedlingCompany(address(new SeedlingCompany()));
        trans_FM = ITransaction(address(new Transaction(product_ad)));
        trans_SF = ITransaction(address(new Transaction(product_ad)));
    }

    mapping (address => SupplyChainLib.Role) role_users;

    modifier role_farmer(){
        require(role_users[msg.sender] == SupplyChainLib.Role.Farmer, "only farmer access");
        _;
    }
    modifier role_seedling_company(){
        require(role_users[msg.sender] == SupplyChainLib.Role.SeedlingCompany, "only seedling company access");
        _;
    }
    modifier role_manufacturer(){
        require(role_users[msg.sender] == SupplyChainLib.Role.Manufacturer, "only manufacturer access");
        _;
    }

    function create_farmer(string memory id, address ad_farmer) public returns(FarmerInfo memory){
        role_users[ad_farmer] = SupplyChainLib.Role.Farmer;
        return farmer.create(id, ad_farmer);
    }

    function get_list_farmer() public view returns (FarmerInfo[] memory){
        return farmer.get_list_farmer();
    }

    function create_seedling_company(string memory id, address ad_company) public returns (CompanyInfo memory){
        role_users[msg.sender] = SupplyChainLib.Role.SeedlingCompany;
        return seed_company.create(id, ad_company);
    }

    function create_manufacturer(string memory id, address ad_man) public returns(ManufacturerInfo memory){
        return manufacturer.create(id, ad_man);
    }

    function create_product_seed(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity, 
                                SupplyChainLib.ProductStatus status, address owner) public role_seedling_company returns (ProductInfo memory){
        require(product.check_product_is_exist(id), "id product is already exist");                           
        return product.create(id, product_type, price, quantity, "" , status, owner);
    }

    function create_product_fruit(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity,string memory trans_detail_id, 
                                SupplyChainLib.ProductStatus status, address owner) public returns(ProductInfo memory){
        require(product.check_product_is_exist(id), "id product is already exist");
        return product.create(id, product_type, price, quantity, trans_detail_id, status, owner);
    }

    function create_transaction_SF(string memory id, string memory product_id, uint quantity, address buyer) public returns(InfoTransaction memory){
        require(role_users[buyer] == SupplyChainLib.Role.Farmer, "only farmer access");
        require(product.check_product_is_exist(id), "id product is already exist");
        return trans_SF.create(id, product_id, quantity, buyer);
    }

    function create_transaction_FM(string memory id, string memory product_id, uint quantity, address buyer) public returns(InfoTransaction memory){
        require(role_users[buyer] == SupplyChainLib.Role.Farmer, "only farmer access");
        require(product.check_product_is_exist(id), "id product is already exist");
        return trans_FM.create(id, product_id, quantity, buyer);
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

    function get_trans_SF_history_of_buyer(address buyer) public view returns (InfoTransaction[] memory){
        return trans_SF.get_transaction_history_of_buyer(buyer);
    }

    function get_trans_SF_of_buyer_by_product(address buyer, string memory product_id) public view returns(InfoTransaction memory){
        return trans_SF.get_trans_of_buyer_by_product(buyer, product_id);
    }

    function get_trans_FM_detail_by_id(string memory id) public view returns (InfoTransaction memory) {
        return trans_FM.get_trans_detail_by_id(id);
    }

    function get_trans_FM_detail_by_product(string memory product_id) public view returns (InfoTransaction[] memory) {
        return trans_FM.get_trans_detail_by_product(product_id);
    }

    function get_trans_FM_history_of_buyer(address buyer) public view returns (InfoTransaction[] memory){
        return trans_FM.get_transaction_history_of_buyer(buyer);
    }

    function get_trans_FM_of_buyer_by_product(address buyer, string memory product_id) public view returns(InfoTransaction memory){
        return trans_FM.get_trans_of_buyer_by_product(buyer, product_id);
    }
}