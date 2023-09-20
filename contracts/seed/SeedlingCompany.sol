// SPDX-License-Identifier: MIT
// import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity ^0.8.0;

library SupplyChainLib{
    enum typeEntities {Fammer, SeedCompany, Manufacturer}
}
contract SeedlingCompany {

    struct CompanyInfo{
        string id;
        address owner;
        // SupplyChainLib.typeEntities companyType;
    }
    constructor(){}

    mapping (address => CompanyInfo) seedling_companys; 
    function create(string memory id) public returns(CompanyInfo memory) {
        seedling_companys[msg.sender] = CompanyInfo(id, msg.sender);
        return seedling_companys[msg.sender];
    }

    function get_seedling_company(address address_company) public  view returns (CompanyInfo memory){
        return seedling_companys[address_company];
    }

}
