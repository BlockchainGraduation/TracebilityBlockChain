// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MarketPlace{
    enum typeProduct{Seedling, Fruit}
    struct Product{
        string productId;
        uint quantity;
        address productOwner;
        typeProduct productType;
    }
    struct Transaction{
        string transactionId;
        string productId;
        uint quantity;
        address buyer;
    }

    struct OrderID{
        string productId;
        string orderId;
        address orderBy;
    }
    
    mapping (address => Product[]) public listProduct;
    mapping (address=>uint) countProdct;
    mapping (address => Transaction[]) public historyTransaction;

    function listing_product(string memory productId, uint quantity, address companyAddress, typeProduct productType) public {
        listProduct[companyAddress].push(Product(productId, quantity, companyAddress, productType));
    }
    function buyProduct(string memory transactionId, string memory productId, uint quantity) public {
        historyTransaction[msg.sender].push(Transaction(transactionId, productId, quantity, msg.sender)); 
    }
    function unlisting(string memory productId, address companyAddress) public {
        Product[] storage products = listProduct[companyAddress];
        uint productIndex = countProdct[companyAddress];

        Product[] memory newListProduct = new Product[](productIndex);

        uint newProductIndex = 0;
        for (uint i = 0; i < productIndex; i++) {
            if (keccak256(abi.encodePacked(products[i].productId)) != keccak256(abi.encodePacked(productId))) {
                newListProduct[newProductIndex] = products[i];
                newProductIndex++;
            }
        }

        listProduct[companyAddress] = newListProduct;
        countProdct[companyAddress] = newProductIndex;
    }


}