// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SupplyChainLib{
    enum ProductType {None, Seedling, Fruit}
    enum ProductStatus {None, Open, Closed}
    enum Role {SeedlingCompany, Farmer, Manufacturer}
    enum OrderStatus {Publish, Private, Closed}
    enum TransType{SF, FM} //SF: seedling => farmer , FM: Farmer => Manufacturer
}