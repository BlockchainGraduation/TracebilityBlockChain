// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Structs.sol";
import "../lib/SupplyChainLib.sol";
import "../product/Product.sol";
import "../transaction/Transaction.sol";

interface IMarketplace {

    function create_item_marketplace(string memory id, string memory product_id, string memory owner, SupplyChainLib.OrderStatus status) external returns(MarketplaceItem memory);

    function create_item_marketplace_status(string memory id, SupplyChainLib.OrderStatus status) external returns (MarketplaceItem memory);
        
    function buy_item_marketplace(string memory id, uint quantity, string memory buyer, string memory id_trans) external returns(InfoTransaction memory);

    function get_ids()external view returns(string[] memory);
}

contract Marketplace{


    mapping(string => MarketplaceItem) private idToMarketplaceItem;
    string[] idItems;
    IProduct Iproduct;
    ITransaction Itrans_SF;
    ITransaction Itrans_FM;

    constructor(address product, address trans_SF, address trans_FM){
        Iproduct = IProduct(product);
        Itrans_SF = ITransaction(trans_SF);
        Itrans_FM = ITransaction(trans_FM);
    }

    function create_item_marketplace(string memory id, string memory product_id, string memory owner, SupplyChainLib.OrderStatus status)public returns(MarketplaceItem memory){
        require(Iproduct.check_product_is_exist(product_id), "product is not exist");
        idToMarketplaceItem[id] = MarketplaceItem(id, product_id, owner, status);
        idItems.push(id);
        return idToMarketplaceItem[id];
    }

    function create_item_marketplace_status(string memory id, SupplyChainLib.OrderStatus status) public returns (MarketplaceItem memory){
        require(bytes(idToMarketplaceItem[id].itemId).length ==0, "item marketpalace is not exist");
        idToMarketplaceItem[id].status = status;
        return idToMarketplaceItem[id];
    }

    function buy_item_marketplace(string memory id, uint quantity, string memory buyer, string memory id_trans) public returns(InfoTransaction memory){
        require(bytes(idToMarketplaceItem[id].itemId).length ==0, "item marketpalace is not exist");
        ProductInfo memory p = Iproduct.readOneProduct(idToMarketplaceItem[id].product_id);
        if (p.product_type == SupplyChainLib.ProductType.Seedling){
            return Itrans_SF.create(id_trans, p.product_id, quantity, buyer);
        }
        else{
            return Itrans_FM.create(id_trans, p.product_id, quantity, buyer);
        }

    }

    function get_ids()public view returns(string[] memory){
        return idItems;
    }


}