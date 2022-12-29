// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface INFT {
    function mint(address _recipient) external returns (uint256);
}

contract NFT is INFT, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string tokenLevelURI;

    constructor(string memory level, string memory _tokenURI) ERC721("NFT", level) {
        tokenLevelURI = _tokenURI;
    }

    function mint(address _recipient) external onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint256 uniqueID = _tokenIds.current();
        _mint(_recipient, uniqueID);
        _setTokenURI(uniqueID, tokenLevelURI);

        return uniqueID;
    }
}