pragma solidity ^0.4.24;


contract SimpleNote {
    
    address public owner;
    string memoContent;
    
    
    modifier onlyOwner() { require(msg.sender == owner, "Access denied"); _; }
    
    
    constructor(string _memoContent) public {
        owner = msg.sender;
        memoContent = _memoContent;
    }
    
    function getContent() public onlyOwner() view returns (string) {
        return memoContent;
    }
    
    function setContent(string _content) public onlyOwner() {
        memoContent = _content;
    }
    
}