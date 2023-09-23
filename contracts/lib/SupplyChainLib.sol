// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SupplyChainLib{
    enum ProductType {Seedling, fruit}
    enum ProductStatus {Open, Closed}
    enum Role {SeedlingCompany, Farmer, Manufacturer}
    enum OrderStatus {Publish, Private, Closed}
}