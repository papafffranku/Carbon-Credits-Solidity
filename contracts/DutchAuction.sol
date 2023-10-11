// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

import "contracts/Mint.sol";

contract GovernmentEnglishAuction is CarbonCreds{

    address public seller;
    ERC20 public token;
    uint256 public clearingPrice;
    uint256 public auctionStart;
    uint256 public auctionEnd;
    uint256 public highestBid;
    address public highestBidder;
    mapping(address => uint256) public bids;
    address[] public bidderAddresses;

    function bid() external payable {
        require(block.timestamp >= auctionStart, "Auction has not started yet");
        require(block.timestamp <= auctionEnd, "Auction has ended");
        require(msg.value >= clearingPrice, "Bid must be greater than or equal to the clearing price");

        if (highestBidder != address(0)) {
            // Refund the previous highest bidder
            payable(highestBidder).transfer(highestBid);
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        bids[msg.sender] += msg.value;
        bidderAddresses.push(msg.sender);
    }

    function getCount() public view returns(uint count) {
    return bidderAddresses.length;
    }

    function claimTokens() external {
        require(block.timestamp > auctionEnd, "Auction has not ended yet");

        // Distribute tokens to the highest bidder and any other bidders who bid above the clearing price
        for (uint256 i = 0; i < getCount(); i++) {
        if (bids[bidderAddresses[i]] >= clearingPrice) {
            uint256 tokensToTransfer = bids[bidderAddresses[i]] - clearingPrice;
            transferfn12(bidderAddresses[i], tokensToTransfer);
            }
        }

        // Refund the seller the remaining tokens
        uint256 remainingTokens = token.balanceOf(address(this));
        transferfn12(seller, remainingTokens);
    }

    function transferfn12(address _to, uint256 _amount) public { //token transfer function
        approve(_to, _amount);
        transfer( _to, _amount);
    }
}
