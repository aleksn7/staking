// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.9;

import "./NFT.sol";

contract NFTMinter {
    INFT immutable bronze;
    INFT immutable silver;
    INFT immutable gold;

    uint constant threshold = 1 ether;

    constructor(address _bronze, address _silver, address _gold) {
        bronze = INFT(_bronze);
        silver = INFT(_silver);
        gold = INFT(_gold);
    }

    function _mintForAmount(address _sender, uint _amount) internal returns (address, uint) {
        uint level = _amount / threshold;

        address addr;
        if (level < 1) {
            addr = address(bronze);
        } else if (level < 2) {
            addr = address(silver);
        } else {
            addr = address(gold);
        }

        uint tokenID = INFT(addr).mint(_sender);
        return (addr, tokenID);
    }
}