pragma solidity ^0.4.11;
// SPDX-License-Identifier: UNLICENSED

contract ShippingAuction {
    address public roasterAddress;
    uint public auctionClose;
    address public bestBidder;
    uint public bestBid;
    mapping(address => uint) returnsPending;
    bool auctionComplete;
    event bestBidDecreased(address bidder, uint bidAmount);
    event auctionResult(address winner, uint bidAmount);


    function SimpleAuction(
        uint _biddingTime,
        address _roaster
    ) {
        roasterAddress = _roaster;
        auctionClose = now + _biddingTime;
    }

    function bid() payable {
        require(now <= auctionClose);
        require(msg.value < bestBid);
        if (bestBidder != 0) {
            returnsPending[bestBidder] += bestBid;
        }
        bestBidder = msg.sender;
        bestBid = msg.value;
        bestBidDecreased(msg.sender, msg.value);
    }

    function withdraw() returns (bool) {
        uint bidAmount = returnsPending[msg.sender];
        if (bidAmount > 0) {
            returnsPending[msg.sender] = 0;

            if (!msg.sender.send(bidAmount)) {
                returnsPending[msg.sender] = bidAmount;
                return false;
            }
        }
        return true;
    }

    function auctionClose() {
        require(now >= auctionClose);
        require(!auctionComplete);
        auctionComplete = true;
        auctionResult(bestBidder, bestBid);
    }
}
