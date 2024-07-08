// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";
contract ExtraStorage is SimpleStorage{ // inheritance

    // +5
    // override 
    // virtual override needed for manipulating an inherited function

    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber +5;
    }

}


