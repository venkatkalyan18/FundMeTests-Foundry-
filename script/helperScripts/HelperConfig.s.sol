//SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {Script} from 'forge-std/Script.sol';
import {MockV3Aggregator} from './MockV3Aggregator.sol';

contract HelperConfig is Script{
    
    NetworkConfig public config;
    struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if(block.chainid == 11155111){
            config = getSepoliaAggrigatorv3Address();
        }else{
            config = getAnvilEthConfig();
        }
    }

    function getSepoliaAggrigatorv3Address() pure public returns(NetworkConfig memory){
        NetworkConfig memory networkConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
         return networkConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory) {
        vm.startBroadcast();
            MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(4,1e18);
         vm.stopBroadcast();

         NetworkConfig memory availConfig = NetworkConfig({priceFeed: address(mockV3Aggregator)});
         return availConfig ;
    }
   
}