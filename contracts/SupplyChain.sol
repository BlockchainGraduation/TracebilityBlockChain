// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;

    enum ProductStatus { Created, Purchased, Shipped, Received }

    struct Product {
        string hashed_info;
        ProductStatus status;
        address farmer;
        address distributor;
        address retailer;
        address customer;
    }

    struct Entity{
        string hashed_info;
    }

    mapping (address => Entity) public farmers;
    mapping (address => Entity) public distributors;
    mapping (address => Entity) public retailers;
    mapping (address => Entity) public customers;
    mapping (string => Product) public products;
    // Product[] public products;
    uint256 public productCount = 0;

    event ProductCreated(string id, string hashed_info, address indexed farmer);
    event ProductPurchased(string id, string hashed_info, address indexed distributor);
    event ProductShipped(string id, string hashed_info, address indexed retailer);
    event ProductReceived(string id, string hashed_info, address indexed customer);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier check_farmer() {
        require(bytes(farmers[msg.sender].hashed_info).length > 0, "You are not a registered farmer.");
        _;
    }

    modifier check_distributor() {
        require(bytes(distributors[msg.sender].hashed_info).length > 0, "You are not a registered farmer.");
        _;
    }

    modifier check_retailer() {
        require(bytes(retailers[msg.sender].hashed_info).length > 0, "You are not a registered farmer.");
        _;
    }

    modifier check_customers() {
        require(bytes(customers[msg.sender].hashed_info).length > 0, "You are not a registered farmer.");
        _;
    }

    

    function createProduct(string memory hash_info, string memory id) public check_farmer() {
        Product memory newProduct = Product({
            hashed_info: hash_info,
            status: ProductStatus.Created,
            farmer: msg.sender,
            distributor: address(0),
            retailer: address(0),
            customer: address(0)
        });

        // products.push(newProduct);
        products[id] = newProduct;
        productCount++;

        emit ProductCreated(id, hash_info, newProduct.farmer);
    }

    function purchaseProduct(string memory _productId) public check_distributor(){

        Product storage product = products[_productId];
        require(bytes(product.hashed_info).length > 0, "Product does not exist");

        require(product.status == ProductStatus.Created, "Product is not available for purchase");

        product.status = ProductStatus.Purchased;
        product.distributor = msg.sender;

        emit ProductPurchased(_productId, product.hashed_info, product.distributor);
    }

    function shipProduct(string memory _productId) public {
        Product storage product = products[_productId];
        require(bytes(product.hashed_info).length > 0, "Product does not exist");

        require(product.status == ProductStatus.Purchased, "Product is not purchased yet");
        require(msg.sender == product.farmer || msg.sender == product.distributor, "Only farmer or distributor can call this function");

        product.status = ProductStatus.Shipped;

        emit ProductShipped(_productId, product.hashed_info, msg.sender);
    }

    function receiveProduct(string memory _productId) public {
        
        Product storage product = products[_productId];
        require(bytes(product.hashed_info).length > 0, "Product does not exist");

        require(product.status == ProductStatus.Shipped, "Product is not shipped yet");
        require(msg.sender == product.retailer || msg.sender == product.customer, "Only retailer or customer can call this function");

        product.status = ProductStatus.Received;

        emit ProductReceived(_productId, product.hashed_info, msg.sender);
    }

    function getProductInfo(string memory _productId) public view returns (string memory id, string memory hashed_info, ProductStatus status, address farmer, address distributor, address retailer, address customer) {
       
        Product memory product = products[_productId];
        require(bytes(product.hashed_info).length > 0, "Product does not exist");
        return (_productId, product.hashed_info, product.status, product.farmer, product.distributor, product.retailer, product.customer);
    }
}
