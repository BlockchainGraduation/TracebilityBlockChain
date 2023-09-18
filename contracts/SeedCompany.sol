// SPDX-License-Identifier: MIT
// import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity ^0.8.0;
interface ISeedCompany {
    function add_seed(string memory _id, uint128 _quantity) external;
}
library SupplyChainLib{
    enum typeEntities {Fammer, SeedCompany, Manufacturer}
}
contract SeedCompany is ISeedCompany{

    struct Company_info{
        string id;
        address owner;
        SupplyChainLib.typeEntities companyType;
    }
    struct Categories{
        string id;
        uint128 quantity;
        uint32 created_at;
    }
    string[] public categories_id;
    Company_info public company_info;
    mapping(string => Categories) public categories;
    constructor(string memory id, address owner, SupplyChainLib.typeEntities companyType){
        company_info = Company_info(id, owner, companyType);
    }
    function add_seed(string memory _id, uint128 _quantity) public {
        categories[_id] = Categories(_id,_quantity, uint32(block.timestamp));
        categories_id.push(_id);
    }
}



contract SystemFactory {
    
    // mapping (SupplyChainLib.typeEntities => address[]) public factory;
    address[] public factory;
    uint index = 0;
    SeedCompany[] seedCompanys;
    function deploy(string calldata _id, uint8 entity) public {
        SupplyChainLib.typeEntities temp = hasTypeEntity(entity);
        SeedCompany seedcompany = new SeedCompany(_id, msg.sender, temp);
        factory.push(address(seedcompany));
        seedCompanys.push(seedcompany);
    }
    function hasTypeEntity(uint8 entity) public pure returns(SupplyChainLib.typeEntities result) {
       
        if (entity == 1) {
            result = SupplyChainLib.typeEntities.SeedCompany;
        } 
        else if (entity == 2) {
            result = SupplyChainLib.typeEntities.Fammer;
        } 
        else if (entity == 3){
            result = SupplyChainLib.typeEntities.Manufacturer;
        }
        else {
            revert("entity invalid");
        }

    }
}