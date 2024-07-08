//SPDX-License-Identifier: MIT 
// important to mention for to be able to use pragma
pragma solidity ^0.8.0; // version of solidity needs to be mentioned ^ this is for version or above

/*
contract SimpleStorage {
    // boolean , uint , int , address, bytes
    bool hasFavoriteNumber = true;
    uint256 favoriteNumber = 5;
    string favoriteNumberInText = "Five";
    int256 favoriteInt = -5;
    address myAddress = 0x5d49B0B4B0FDFD25b5E4aFE38B30C34A6c4168bb;
    bytes32 favoriteBytes = "cat";// strings and bytes are almost same , just string is only for text 

}

*/


// EVM , Ethereum Virtual machine
// avalanche ,fantom , polygon ... blockchain that support evm

contract SimpleStorage {
    uint256   favoriteNumber;// default value is assigned as 0
    // default visibilty for any variable is internal

    mapping(string => uint256) public nameToFavoriteNumber; 

    struct People{
        uint256 favoriteNumber;
        string name; 
    }

    People[] public people;// creating an array of type public

    function store(uint256 _favoriteNumber) public virtual {// virtual mentions that if inheirted this funciton is overridable
        favoriteNumber = _favoriteNumber;  
    }
    
    // view and pure disallow modification of state
    // no gas fee charged
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    } // if retrieve is called in a function that cost gas then even retrieve will cost gas

    function addPerson(string memory _name , uint256 _favoriteNumber ) public {
       People memory newPerson = People({favoriteNumber: _favoriteNumber,name: _name});//People(_favoriteNumber,_name)
        people.push(newPerson);
        nameToFavoriteNumber[_name]=_favoriteNumber;

    // uint256 favorite Number  is default storage type
    // calldata temporary immutable
    // memory temporary mutable
    // storage permanent

    // array struct mapping object memory has to be mentioned , string is also a type of array
}
}





