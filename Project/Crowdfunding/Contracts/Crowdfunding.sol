// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Crowdfunding {
    mapping(address => uint256) public funders; //mapp address with funders that will fund in contract
    uint256 public deadline; //last date or termination of session
    uint256 public targetFunds;
    string public name;
    address public owner; // owner .
    bool public fundsWithdraw; // funds will withdrawn or not?

    //now create an events...

    event Funded(address _funder, uint256 _amount);
    event OwnerWithdraw(uint256 _amount);
    event FunderWithdraw(address _funder, uint256 _amount);

    //now create a constructor of contract..

    constructor(string memory _name, uint256 _targetFunds, uint256 _deadline) {
        owner = msg.sender; // check the owner is original or not?
        name = _name; //passing the all values in ccontructor that are declared as a global varibale
        targetFunds = _targetFunds;
        deadline = _deadline;
    }

    function fund() public payable {
        require(isFundEnabeled() == true, "Funding is now disabled!"); //checking the avalibility of funds...

        funders[msg.sender] += msg.value; //enables the funders mappings..
        emit Funded(msg.sender, msg.value); // emiting the Funded event
    }

    // to withdraw a funds...
    function Withdrawowner() public {
        require(msg.sender == owner, "ownership required");
        require(isFundsuccess() == true, "cannot withdraw!");

        uint256 amountToSend = address(this).balance;

        (bool success, ) = msg.sender.call{value: amountToSend}("");
        require(success, "unable to send!");
        fundsWithdraw = true;
        emit OwnerWithdraw(amountToSend);
    }

    function Withdrawfunder() public {
        require(
            isFundEnabeled() == false && isFundsuccess() == false,
            "not eligible"
        );

        uint256 amountToSend = funders[msg.sender];

        (bool success, ) = msg.sender.call{value: amountToSend}("");

        require(success, "unable to transfer");

        funders[msg.sender] = 0;  // it can help to not call function repetadly
        emit FunderWithdraw(msg.sender, amountToSend);
    }

    //helper functions that are help to see the funds and owner kind of stuff..

    function isFundEnabeled() public view returns (bool) {
        //no gas fees are required
        if ((block.timestamp > deadline || fundsWithdraw)) {
            // using block.timestamp is to check the validity of funds...
            return false;
        } else {
            return true;
        }
    }

    //another helper function to know funds will be successsfully transfered.. or not?
    function isFundsuccess() public view returns (bool) {
        if (address(this).balance >= targetFunds || fundsWithdraw) {
            //check for time out or not
            return true;
        } else {
            return false;
        }
    }
}
