pragma solidity ^0.4.24;


contract VotingApp {
    
    struct Voter {
        uint weight;
        bool voted;
        uint vote;
    }
    
    struct Option {
        bytes32 title;
        uint votes;
    }
    
    
    address public host;
    Option[] public options;
    mapping (address => Voter) public voters;
    
    mapping (address => bool) private voterRequests;
    uint requestCount = 0;
    
    
    constructor(bytes32[] _options) public {
        host = msg.sender;
        
        voters[host].weight = 1;
        
        for (uint i = 0; i < _options.length; i++) {
            addOption(_options[i]);
        }
    }
    
    function addOption(bytes32 _title) public {
        require(msg.sender == host, "Only the host can add new options");
        options.push(Option({title: _title, votes: 0}));
    }
    
    function modifyOption(uint id, bytes32 _title) public {
        require(msg.sender == host, "Only the host can modify options");
        options[id].title = _title;
    }
    
    function addNewVoter(address voterAddr) public {
        require(msg.sender == host, "Only the host can add new voters");
        voters[voterAddr].weight = 1;
    }
    
    function requestVoting() public payable {
        require(!voterRequests[msg.sender], "Address already requested for voting");
        voterRequests[msg.sender] = true;
        requestCount += 1;
    }
    
    function grantVotingRequest() public view {
        require(msg.sender == host, "Access denied");
    }
    
    function vote(uint option) public {
        Voter storage voter = voters[msg.sender];
        
        require(!voter.voted, "Voter already voted");
        require(voter.weight > 0, "Voter not registered");
        
        voter.vote = option;
        voter.voted = true;
        
        options[option].votes += voter.weight;
    }
    
    function getResult() public view returns (uint winner, uint max) {
        for (uint i = 0; i < options.length; i++) {
            if (options[i].votes > max) {
                max = options[i].votes;
                winner = i;
            }
        }
    }
    
    function idToTitle(uint id) public view returns (bytes32) {
        return options[id].title;
    }
    
}