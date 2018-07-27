pragma solidity ^0.4.24;


contract Auction {
    
    address public host;
    uint public endTime;
    
    bool public ended;
    
    address public highestBidder;
    uint public highestBid;
    
    mapping (address => uint) pendingReturns;
    
    
    constructor(uint _endTime) public {
        host = msg.sender;
        endTime = now + _endTime;
    }
    
    function bid() public payable {
        require(!ended, "Auction ended");
        require(msg.value > highestBid, "Higher bid already exists");
        
        if (highestBid != 0) pendingReturns[highestBidder] = highestBid;
        
        highestBidder = msg.sender;
        highestBid = msg.value;
    }
    
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No withdrawable funds exist");
        
        pendingReturns[msg.sender] = 0;
        
        if (!msg.sender.send(amount)) {
            pendingReturns[msg.sender] = amount;
            return false;
        }
        
        return true;
    }
    
    function endAuction() public {
        require(msg.sender == host, "Only the host can end the auction");
        require(!ended, "Auction already ended");
        require(now >= endTime, "Auction not yet ended");
        
        ended = true;
        host.transfer(highestBid);
    }
    
}