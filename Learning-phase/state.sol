//SPDX-License-Identifier:GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;


/** using constructor
contract state{
    string public name;

 constructor() public{
     name= "ok";
 }
}*/

/** using inner state value
contract state{
    uint age= 47;
}*/

/** using state with set function*/

contract state{
    string public name;

    function setName() public{
        name= "Gujarati";
    }
}
