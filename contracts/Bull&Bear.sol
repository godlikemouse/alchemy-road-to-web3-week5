// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Chainlink Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

//TODO: add random bull/bear selection when bear/bull changes (vrf.chain.link/new)

contract BullBear is
    ERC721,
    ERC721Enumerable,
    ERC721URIStorage,
    Ownable,
    KeeperCompatibleInterface
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public /*immutable*/ interval;
    uint256 public lastTimeStamp;

    AggregatorV3Interface public priceFeed;
    int256 public currentPrice;

    event TokensUpdated(string marketTrend);

    string[] bullUrisIpfs = [
        "https://cloudflare-ipfs.com/ipfs/QmRXyfi3oNZCubDxiVFre3kLZ8XeGt6pQsnAQRZ7akhSNs",
        "https://cloudflare-ipfs.com/ipfs/QmRJVFeMrtYS2CUVUM2cHJpBV5aX2xurpnsfZxLTTQbiD3",
        "https://cloudflare-ipfs.com/ipfs/QmdcURmN1kEEtKgnbkVJJ8hrmsSWHpZvLkRgsKKoiWvW9g"
    ];

    string[] bearUrisIpfs = [
        "https://cloudflare-ipfs.com/ipfs/Qmdx9Hx7FCDZGExyjLR6vYcnutUR8KhBZBnZfAPHiUommN",
        "https://cloudflare-ipfs.com/ipfs/QmTVLyTSuiKGUEmb88BgXG3qNC8YgpHZiFbjHrXKH3QHEu",
        "https://cloudflare-ipfs.com/ipfs/QmbKhBXVWmwrYsTPFYfroR2N7NAekAMxHUVg2CWks7i9qj"
    ];

    constructor(uint256 updateInterval, address _priceFeed) ERC721("Bull&Bear", "BBTK") {
        // Sets the keeper update interval.
        interval = updateInterval;
        lastTimeStamp = block.timestamp;

        // set the price feed address to
        // BTC/USD Price Feed Contract Address on Goerli: https://goerli.etherscan.io/address/0xA39434A63A52E749F02807ae27335515BA4b07F7
        // reference: https://docs.chain.link/data-feeds/price-feeds/addresses/?network=ethereum
        // or the MockPriceFeed Contract
        priceFeed = AggregatorV3Interface(_priceFeed);

        currentPrice = getLatestPrice();
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        // Defaults to gamer bull NFT image
        string memory defaultUri = bullUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);
    }

    function checkUpkeep(bytes calldata /*checkData*/) external view override returns(bool upkeepNeeded, bytes memory /*performData*/) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

    function performUpkeep(bytes calldata /*(performData*/) external override {
        if((block.timestamp - lastTimeStamp) > interval) {
            lastTimeStamp = block.timestamp;
            int256 latestPrice = getLatestPrice();

            if(latestPrice == currentPrice) {
                return;
            }

            if(latestPrice < currentPrice) {
                // bear
                _updateAllTokenUris("bear");
            } else {
                _updateAllTokenUris("bull");
            }

            currentPrice = latestPrice;
        }
    }

    function _updateAllTokenUris(string memory trend) internal {
        if(compareStrings(trend, "bear")) {
             for(uint256 i=0; i<_tokenIdCounter.current(); i++){
                _setTokenURI(i, bearUrisIpfs[0]);
             }
        }
        else {
            for(uint256 i=0; i<_tokenIdCounter.current(); i++){
                _setTokenURI(i, bullUrisIpfs[0]);
             }
        }

        emit TokensUpdated(trend);
    }

    function setInterval(uint256 newInterval) public onlyOwner {
        interval = newInterval;
    }

    function setPriceFeed(address newFeed) public onlyOwner {
        priceFeed = AggregatorV3Interface(newFeed);
    }

    // Helpers
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function getLatestPrice() public view returns(int256) {
        (/*uint80 roundID*/,
        int256 price,
        /*uint startedAt*/,
        /*uint timeStamp*/,
        /*uint80 answeredInRound*/) = priceFeed.latestRoundData();

        return price;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
