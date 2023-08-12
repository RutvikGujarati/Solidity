// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SendEther {
    function sendEth(address payable _to) public payable {
        // Just forward the ETH received in this payable function
        // to the given address
        uint amountToSend = msg.value;
        // call returns a bool value specifying success or failure
        (bool success, bytes memory data) = _to.call{value: msg.value}("");
        require(success == true, "Failed to send ETH");
    }
}

contract SendEther2 {
    function sendEth(address payable _to) public payable {
        // Just forward the ETH received in this payable function
        // to the given address
        uint amountToSend = msg.value;
  
        bool sent = _to.send(amountToSend);
        require(sent == true, "Failed to send ETH");
    }
}

contract SendEther3 {
    function sendEth(address payable _to) public payable {
        // Just forward the ETH received in this payable function
        // to the given address
        uint amountToSend = msg.value;
        
        // Use the transfer method to send the ETH.
        _to.transfer(msg.value);
    }
}
