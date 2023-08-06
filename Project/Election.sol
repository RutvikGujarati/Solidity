// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Create {
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public votingOrganizer;

    //Candidate voting

    struct Candidate{
        uint256 candidateId;
        string age;
        string name;
        string image;
        uint256 voteCount;
        address _address;
        string ipfs;
    }

    event CandidateCreate (
        uint256 indexed candidateId,
        string age,
        string name,
        string image,
        uint256 voteCount,
        address _address,
        string ipfs
    );

    address[] public CandidateAdress;

    mapping (address=> Candidate) public candidates;
    //Ends with candidate data
    
    //Now starts with Voterdata

    address[]  public votedVoters;

    address[]  public  votersAddress;

    mapping (address=> Voter)public voters;


    struct Voter{
        uint256 voter_voterId;
        string voter_name;
        string voter_image;
        address voter_address;
        uint256 voter_allowed;  
        bool voter_voted;
        uint256 voter_vote;
        string voter_ipfs;
    }

    event vote_Create (
        uint256 indexed voter_voterId,
        string voter_name,
        string voter_image,
        address voter_address,
        uint256 voter_allowed,
        bool voter_voted,
        uint256 voter_vote,
        string voter_ipfs
    );
    //End of all details about voters 


    constructor(){
        votingOrganizer= msg.sender;
    }

    
    function setCandidate(address _address, string memory _age, string memory _name,  string memory _image, string memory _ipfs) public {
        require(votingOrganizer == msg.sender, "Only organizer can create candidates");  //condition...

        //condition about who can create candidates 

        _candidateId.increment();

        //get current id number of candidate

        uint256 idNumber = _candidateId.current();
    
        Candidate storage candidate = candidates[_address];

        candidate.age  = _age;
        candidate.name = _name;
        candidate.candidateId = idNumber;
        candidate.image = _image;
        candidate.voteCount = 0;
        candidate._address = _address;
        candidate.ipfs = _ipfs;
        

        CandidateAdress.push(_address);


        emit CandidateCreate(idNumber, _age, _name, _image, candidate.voteCount, _address, _ipfs); 
     }

    function getCandidates() public view returns(address[] memory) {
        return CandidateAdress;
    }

    function getCandidateLength() public view returns(uint256){
        return CandidateAdress.length;
    }

    function getCandidateData(address _address) public view returns(string memory, string memory, uint256, string memory, uint256, string memory , address) {
        return (
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].candidateId,
            candidates[_address].image,
            candidates[_address].voteCount,
            candidates[_address].ipfs,
            candidates[_address]._address
        );
    }


            //voter section...

     function voterRight(address _address, string memory _name, string memory _image, string memory _ipfs) public{
        require(votingOrganizer == msg.sender,"only owner can create voter");


        _voterId.increment();

        uint256 idNumber = _voterId.current();    

        Voter storage voter = voters[_address];

        //for registration process
       require(voter.voter_allowed == 0);

       //update and check that voter is registered or not?

       voter.voter_allowed = 1;
       voter.voter_name = _name;
       voter.voter_image = _image;
       voter.voter_address= _address;
     voter.voter_voterId == idNumber;
       voter.voter_vote = 1000;
       voter.voter_voted= false;
       voter.voter_ipfs = _ipfs;


     votersAddress.push(_address);
    

    emit vote_Create(
        idNumber, _name, _image, _address, voter.voter_allowed,  voter.voter_voted, voter.voter_vote, _ipfs);

  }

     function vote (address  _candidateAddress, uint256 _candidateVotedId) external{

        Voter storage voter = voters [msg.sender];

        require(!voter.voter_voted, "you have already voted");
        require(voter.voter_allowed != 0 , "you have no opermission to vote" ); //if he/she not connected

        voter.voter_voted = true;
        voter.voter_vote = _candidateVotedId;

        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voteCount += voter.voter_allowed;
     }


  function getVoterLength() public view returns(uint256)
  {
    return votersAddress.length;
  }


    function getVoterdata(address _address) public view returns(
        uint256, string memory,  string memory,  address, string memory, uint256, bool
    ){
    return(
        voters[_address].voter_voterId,
        voters[_address].voter_name,
        voters[_address].voter_image,
        voters[_address].voter_address,
        voters[_address].voter_ipfs,
        voters[_address].voter_allowed,
        voters[_address].voter_voted    
    );
    }

    function getvotedvoterList() public view returns(address[] memory) {

        return votedVoters;
        
    }

    function getvoterList() public view returns(address[] memory){
    return votersAddress;
    }

}
