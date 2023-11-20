// Copyright 2023 luan
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VietNamToken is ERC20, Ownable {
    constructor() ERC20("VietNamToken", "VNDT") Ownable(0xA2cF9F068cE84Cd51dfF616330a5FA9fD7Bff0A3) {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount * (10 ** uint256(decimals())));
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount * (10 ** uint256(decimals())));
    }
}
