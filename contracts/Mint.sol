//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract CarbonCreds is ERC20("CarbonCredits","CC"), Ownable(msg.sender) {


    function mint(uint256 initialsupply) public onlyOwner {//onlyOwner states only contract owner can deploy mint function
        _mint(msg.sender, initialsupply * 10 ** 8); //input is in WEI
    }

    function transferfn(address _from, address _to, uint256 _amount) public { //transfer function
        approve(_from, _amount);
        approve(_to, _amount);
        transferFrom(_from, _to, _amount);//Participant consesus => both parties approve the transaction
    }

    function Burn(address _account, uint256 _value)public onlyOwner{
        //automation via API with a Govt entity to run this function from a trusted machine with the owner wallet address
        _burn(_account, _value);
    }
}


