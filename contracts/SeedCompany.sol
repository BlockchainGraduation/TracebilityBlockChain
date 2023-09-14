// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SeedCompany{
    struct Company_info{
        string id;
        address owner;
    }

    struct Categories{
        string id;
        uint128 quantity;
    }

    Company_info company_info;
    

    function get_info() public view returns(string memory id, address owner){
        return (company_info.id, company_info.owner);
    }

}