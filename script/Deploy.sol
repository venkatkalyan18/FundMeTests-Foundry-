//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from '../src/FundMe.sol';
import {HelperConfig} from './helperScripts/HelperConfig.s.sol';

contract Deploy is Script{

    function run() public returns(FundMe){

        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.config();
        vm.startBroadcast();
            FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }

}