// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
contract SimpleStorage {
    uint256   favoriteNumber;

    mapping(string => uint256) public nameToFavoriteNumber; 
       
    struct People{
        uint256 favoriteNumber;
        string name; 
    }
        
    People[] public people;

    function store(uint256 _favoriteNumber) public{ 
        favoriteNumber = _favoriteNumber;  
    }  
      
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    } 

    function addPerson(string memory _name , uint256 _favoriteNumber ) public {
       People memory newPerson = People({favoriteNumber: _favoriteNumber,name: _name});
        people.push(newPerson);
        nameToFavoriteNumber[_name]=_favoriteNumber;
        }
}

*/  //we can either redeclare the entire contract to be used 

import "./SimpleStorage.sol"; // we can also import the file
// for importing the version of solidity should lie in same range or must have a common

/*
contract StorageFactory {

    SimpleStorage public simpleStorage; // we are declaring a variable which is simpleStorage contract type
    function createSimpleStorageContract() public {
        simpleStorage = new SimpleStorage(); // with this solidity will know we are deploying a new solidity contract
    }

}
*/

contract StorageFactory {
    SimpleStorage[] public simpleStorageArray; // decalring array of type SimpleStorage contract

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage(); // creating a new  contract of type SimpleStorage
        simpleStorageArray.push(simpleStorage);// pushing contract into array 
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)public {
        // address 
        // ABI - Application Binary Interface
      //  SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStorageIndex]) ;// we want to create an object of SimpleStorage contract
        // for that we need to declare address of contract to SimpleStorage , which we get directly from contract stored in array at given index
        // but since our array contains entire contract and not just address thus we can declare object in a different way as shown below

        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber); // accessing function using object variable
    } // this function only accesses function cannot dsiplay it

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        // SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
         //return simpleStorage.retrieve();
         return simpleStorageArray[_simpleStorageIndex].retrieve();
    }// this funciton will display as a button


}

