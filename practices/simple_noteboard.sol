pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;


contract SimpleNoteBoard {
    
    struct Memo {
        string title;
        string content;
    }
    
    
    address public owner;
    Memo[] memos;
    
    
    event NewMemoAdded(string title);
    
    
    modifier onlyOwner() { require(msg.sender == owner, "Access denied"); _; }
    
    
    constructor() public {
        owner = msg.sender;
    }
    
    function addNewMemo(string _title, string _content) public onlyOwner() {
        memos.push(Memo({title: _title, content: _content}));
        emit NewMemoAdded(_title);
    }
    
    function getMemoAt(uint i) public view onlyOwner() returns (Memo) {
        return memos[i];
    }
    
    function compareString(string _a, string _b) internal pure returns (bool) {
        (bytes memory ba, bytes memory bb) = (bytes(_a), bytes(_b));
        require(ba.length == bb.length);
        
        for (uint i = 0; i < ba.length; i++) {
            if (ba[i] == bb[i]) continue;
            return false;
        }
        
        return true;
    }
    
}