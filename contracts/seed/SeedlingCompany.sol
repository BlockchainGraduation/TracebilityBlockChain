// SPDX-License-Identifier: MIT
// import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity ^0.8.0;

import "../lib/Structs.sol";

interface ISeedlingCompany {
    function create(string memory id, address company) external returns(ActorInfo memory);
    function get_seedling_company_by_address(address address_company) external view returns (ActorInfo memory);
    function get_seedling_company_by_id(string memory id) external  view returns (ActorInfo memory);
    function get_list_seedling_company() external view returns(ActorInfo[] memory);
}

contract SeedlingCompany is ISeedlingCompany {

    constructor(){}

    mapping (address => ActorInfo) seedling_companys;
    mapping (string => ActorInfo) companys_ms;
    ActorInfo[] public companys;

    function create(string memory id, address company) public returns(ActorInfo memory) {
        seedling_companys[company] = ActorInfo(id, company);
        companys.push(seedling_companys[company]);
        companys_ms[id] = seedling_companys[company];
        return seedling_companys[company];
    }

    function get_seedling_company_by_address(address address_company) public  view returns (ActorInfo memory){
        return seedling_companys[address_company];
    }

    function get_seedling_company_by_id(string memory id) public  view returns (ActorInfo memory){
        return companys_ms[id];
    }
    function get_list_seedling_company()public view returns(ActorInfo[] memory){
        return companys;
    }
}
