

//Fund
//Withdraw

//SPDX-License-Identfier: MIT

pragma solidity ^0.8.18;

import {Script,console} from 'forge-std/Script.sol';
import {DevOpsTools} from 'foundry-devops/src/DevOpsTools.sol';
import {FundMe} from '../src/FundMe.sol';

contract FundFundMe is Script{
    function  fundFundMe(address mrd) public {
        vm.startBroadcast();
            FundMe(payable(mrd)).fund{value:0.01 ether}();
        vm.stopBroadcast();
        console.log("Funded");
    }

    function run() external{
        address mostRecentlyDepolyed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDepolyed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script{
    function withdrawFundMe(address mrd) public {
        vm.startBroadcast();
            FundMe(payable(mrd)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrawed");
    }

    function run() external{
        address mostRecentlyDepolyed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDepolyed);
        vm.stopBroadcast();
    }
}