// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

 function getPrice() internal view returns (uint256) {
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

    function getVersion() internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }    

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
       uint256 ethAmountInUsd = (ethPrice* ethAmount)/1e18; //both have 18 so becomes 36 need to remove extra
       return ethAmountInUsd; 
    }


}
// library should always have function declares as internal 












