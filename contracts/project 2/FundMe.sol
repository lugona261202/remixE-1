// tasks
// get funds from user 
// withdraw funds
// set a minimum funding values in USD


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner(); 
// just like wallet , even smart contract can hold funds
contract FundMe {

        using PriceConverter for uint256;

        uint256 public constant  MINIMUM_USD = 50* 1e18;// adding constant makes our variable gas efficient , naming convention keeps all cap seperated by _

        address[] public funders; // storing all owners who fund us into array

        mapping(address => uint256) public addressToAmountFunded;

        address public immutable i_owner;// if you are setting a variable only once and then it does not change again we use immutable, this also saves gas 
        // convertion precede the varaible with i_

        constructor(){
            i_owner=msg.sender;// this is done so as to make sure only admin can withdraw money 
        }

    // payable function appear in red
    function  fund()public payable { // we can access value parameter using this payable keyword

        // want to be able to set a minimum fund amount in usd
        // 1. how do we send ETH to this contract

        //require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough"); // 1e18 == 1* 10^18 value of eth in wei
        // above line cannot be used same way after creating library
        
        require(msg.value.getConversionRate()>= MINIMUM_USD,"Didn't send enough!");
        // this require compares condition if not met it send message after,
        // to compare usd and msg.value which is in ether we need to convert our ether into usd 
        funders.push(msg.sender); // msg.sender is address of account who funds into this  
        addressToAmountFunded[msg.sender]=msg.value;
    }
  /*
    function getPrice() public view returns (uint256) {
        // we will now interact with contract outside our system for which we need two things
        // ABI
        // Adress 0x694AA1769357215DE4FAC081bf1f309aDC325306 : obtain from price feeds section chain link
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       // (uint80 roundId,int price, uint startedAt, uint timestamp,uint80 answeredInRound)=priceFeed.latestRoundData();
        // these are the parameters that this function returns but we only need price hence
        (,int256 price,,,)= priceFeed.latestRoundData();
        // now we have eth in USD but we still have to ensure the decimal part
        return uint256(price*1e10); // since msg.value has 18 but price only 8 so to balance
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }    

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
       uint256 ethAmountInUsd = (ethPrice* ethAmount)/1e18; //both have 18 so becomes 36 need to remove extra
       return ethAmountInUsd; 
    }
    */


    function withdraw() public onlyOwner{
        /*starting index , ending index , step amount*/
        for(uint256 funderIndex =0 ; funderIndex< funders.length; funderIndex++){
            // code 
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array 
        funders = new address[](0);// reseting with value 0
         
         //actually withdarawing the funds
        // there are three ways 

        // transfer , above a certain gas limit it simply throws error
        //payable(msg.sender).transfer(address(this).balance)

        // send , above a certain gas limit it returns a boolean
        //bool sendSuccess = payable(msg.sender).send(address(this).balance)
        //require(sendSuccess, "send failed")

        // call , above a certain gas limit it returns a boolean and a data ,but rn we only need boolean
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require (callSuccess,"Call failed");



    }

    modifier onlyOwner{// modifier can simply be added where before execution , function will first follow code of modifier
       // require(msg.sender==i_owner,"sender is not owner");
       if(msg.sender!= i_owner) {revert NotOwner();}
        _;// this is like an instruction to functionnow follow the rest of the code
    }

   // in case a funder simply sends money without first executing fund , we will lose many important details
   // in such cases we add recieve and fallback their execution depends on data flow and input for exact , refer to video
   // in short this is a prevention mechanish
    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }

}

// reverting , important concept 
// if require fails any changes before it are undone
// but that does not imply no gas will be wasted
// instead any remaining gas after require fails is returned back 
// reverting means 2 things , all previous undone and remaining gas returned


//ABI is nothing but a list of description of all functions in a contract
// to obtain ABI we have two methods 
// simply just declare function of a contract without its inner content and then on deploying the code we get the ABI
// the above method is called interfacing , but declaring too many functions can be a hassle 
// our we can easily import the contract from git hub link  