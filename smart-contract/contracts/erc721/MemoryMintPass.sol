// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MemoryMintPassport is ERC721URIStorage {
    uint256 tokenId;
    event MemoryMintDeclared(
        address user,
        uint256 tokenId,
        string city,
        uint256 startTime,
        uint256 endTime
    );
    struct MemoryMint {
        uint256 tokenId;
        string city;
        uint256 startTime;
        uint256 endTime;
    }
    mapping(address => MemoryMint) tokenMemoryMint;

    constructor() ERC721("MemoryMint", "VYG") {}

    function mint(string calldata city, uint256 endtime) public {
        MemoryMint memory trip = MemoryMint(tokenId, city, block.timestamp, endtime);
        _mint(msg.sender, tokenId);
        emit MemoryMintDeclared(msg.sender,tokenId, city, block.timestamp, endtime);
        tokenMemoryMint[msg.sender] = trip;
        tokenId++;
    }

    function getUserCurrentTrip(address user)
        public
        view
        returns (MemoryMint memory)
    {
        return tokenMemoryMint[user];
    }

    function isTripOngoing(uint256 tokenID) public view returns (bool) {
        return tokenMemoryMint[ownerOf(tokenID)].endTime < block.timestamp;
    }

    function isTripOngoing(address user) public view returns (bool) {
        return tokenMemoryMint[user].endTime < block.timestamp;
    }
}
