// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

import "contracts/Mint.sol";

contract EnglishAuction is CarbonCreds{ //carbon credit inherited from mint
    address public auctioneer;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public biddingEndTime;
    uint256 public Carbonamount;
    bool public auctionEnded;

    // Constructor to set the auctioneer and bidding duration
    constructor(uint256 _biddingDuration, uint _CarbonCreditAmount) {
        auctioneer = msg.sender;
        biddingEndTime = block.timestamp + _biddingDuration;
        Carbonamount=_CarbonCreditAmount;
    }

    function placeBid() public payable {
        require(!auctionEnded, "Auction has ended");
        require(block.timestamp < biddingEndTime, "Bidding has ended");
        require(
            msg.value > highestBid,
            "Bid amount is not higher than the current highest bid"
        );

        if (highestBid != 0) {
            // Refund the previous highest bidder if there was a bid
            payable(highestBidder).transfer(highestBid);
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function endAuction() public {
        require(!auctionEnded, "Auction has already ended");
        require(
            block.timestamp >= biddingEndTime,
            "Bidding period has not ended"
        );
        auctionEnded = true;
        transferfn(auctioneer, highestBidder, Carbonamount);//transfer of carbon amount
        uint256 auctioneerFee = (highestBid * 1) / 100; // 1% fee
        payable(auctioneer).transfer(highestBid - auctioneerFee);
    }
}
