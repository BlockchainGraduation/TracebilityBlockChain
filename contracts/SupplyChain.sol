// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./product/Product.sol";
import "./farmer/Farmer.sol";
import "./manufacturer/Manufacturer.sol";
import "./seed/SeedlingCompany.sol";
import "./transaction/Transaction_FM.sol";
import "./transaction/Transaction_SF.sol";
import "./transaction_detail/TransactionDetail_FM.sol";
import "./transaction_detail/TransactionDetail_SF.sol";
import "./lib/Structs.sol";

contract SupplyChain{
    IProduct product;
    IFarmer farmer;
    IManufacturer manufacturer;
    ISeedlingCompany seed_company;
    ITransaction_FM trans_FM;
    ITransaction_SF trans_SF;
    ITransactionDetail detail_trans_FM;
    ITransactionDetail detail_trans_SF;

    constructor(){
        product = IProduct(address(new Product()));
        farmer = IFarmer(address(new Farmer()));
        manufacturer = IManufacturer(address(new Manufacturer()));
        seed_company = ISeedlingCompany(address(new SeedlingCompany()));
        trans_FM = ITransaction_FM(address(new Transaction_FM()));
        trans_SF = ITransaction_SF(address(new Transaction_SF()));
        detail_trans_FM = ITransactionDetail(address(new TransactionDetail_FM()));
        detail_trans_SF = ITransactionDetail(address(new TransactionDetail_SF()));
    }

    function create_farmer(string memory id) public returns(FarmerInfo memory){
        return farmer.create(id);
    }

    function get_list_farmer() public view returns (FarmerInfo[] memory){
        return farmer.get_list_farmer();
    }

    function create_seedling_company(string memory id) public returns (CompanyInfo memory){
        return seed_company.create(id);
    }

    function create_product_seed(string memory id, SupplyChainLib.ProductType product_type, uint price, uint quantity, 
                                string memory trans_detail_id, SupplyChainLib.ProductStatus status) public returns (ProductInfo memory){
        return product.create(id, product_type, price, quantity, trans_detail_id, status);
    }
    
}