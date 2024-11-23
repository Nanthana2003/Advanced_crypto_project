// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Vote{

    struct Candidate{
        string id;
        string name;
        address add;
        uint votes;

    }
    struct User{
        string id;
        string name;
        address add;
        bool didvote;
        string chosen;
    }

    string winnerAddress;
    string winnerName;
    uint winnerVotes;
    string temp;
    mapping(string => Candidate) candidates;
    mapping(string => User) users;

    event CreateVoter(string id, string name, address sen, bool did, string choose);
    event CreateCandidate(string id, string name, address sen, uint v);
    event VoteCandidate(string senname, string canname, uint v);
    event AnnounceWinner(string winname, uint v, string add);

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }



    function createVoter(string memory _id, string memory _name) public  {
        users[_id].id = _id;
        users[_id].name = _name;
        users[_id].add = msg.sender;
        users[_id].didvote = false;
        users[_id].chosen = "";
        winnerAddress = "";
        winnerName = _name;
        winnerVotes = 0;
        emit CreateVoter(_id, _name, msg.sender, users[_id].didvote, users[_id].chosen);
    }

    function createCandidate(string memory _id, string memory _name) public  {
        candidates[_id].id = _id;
        candidates[_id].name = _name;
        candidates[_id].add = msg.sender;
        candidates[_id].votes = 0;
        emit CreateCandidate(_id, _name, msg.sender, candidates[_id].votes);
    }

    function voteCandidate(string memory _id, string memory voter_id) public  {
        if(users[voter_id].didvote == true) {
            candidates[users[voter_id].chosen].votes--;
            temp = _id;
            if(compareStrings(temp, winnerAddress)){
                winnerVotes--;
            }
            candidates[_id].votes++;
            users[voter_id].chosen = _id;
            if(winnerVotes < candidates[_id].votes){
                winnerAddress = _id;
                winnerName = candidates[_id].name;
                winnerVotes = candidates[_id].votes;
            }
        }
        else{
            users[voter_id].didvote = true;
            users[voter_id].chosen = _id;
            candidates[_id].votes++;
            if(winnerVotes < candidates[_id].votes){
                winnerAddress = _id;
                winnerName = candidates[_id].name;
                winnerVotes = candidates[_id].votes;
            }
        }
        emit VoteCandidate(users[voter_id].name, candidates[_id].name, candidates[_id].votes);
    }

    function announceWinner() public  {

        emit AnnounceWinner(winnerName, winnerVotes, winnerAddress);
    }


    
}