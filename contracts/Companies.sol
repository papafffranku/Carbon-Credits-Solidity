// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract SimpleStorage{//adding companies according to struct

    string  CompanyName;
    uint256 Company_Reg_Number;
    address SampleCompanyAddress = 0x985F4aee8897d034112C265B0Dff09FF6F7Ea9c1;
    

    function retrieve_companyNum() public view returns(uint256){
        return Company_Reg_Number;
    }
    
    //mapping
    mapping (uint256 => address) public RegToAddress;//setting company registration number as the primary key to get wallet adresses on the blockchain

    struct Companies{
        string CompanyName;
        uint256 Company_Reg_Number;
        address CompanyAddress;//wallet address
    }

    //create people struct and array
    Companies[] public companies;

    //add to array
    function addCompany(string memory _name, uint256 _Registration, address _CompanyAddress) public {
        companies.push(Companies({CompanyName:_name,Company_Reg_Number:_Registration,CompanyAddress:_CompanyAddress}));
        RegToAddress[_Registration] = _CompanyAddress; //print company wallet address based on its registration number
    }

}
