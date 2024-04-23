//SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {Test, console} from 'forge-std/Test.sol';
import {FundMe} from '../src/FundMe.sol';
import {Deploy} from '../script/Deploy.sol';


contract FundMeTest is Test {
    uint256 number =1;
    FundMe fundMe;
    address user = makeAddr("USER");

    function setUp() external{
        Deploy deploy = new Deploy();
        fundMe = deploy.run();
        vm.deal(user, 10 ether);
    }

    function testMinDollarIsFive() view public{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() view public{
        assertEq(fundMe.getOwner(),msg.sender);
    }

    function testAggrigatorV3VersionIsFour() view public{
        assertEq(fundMe.getVersion(),4);
    }

    function testShouldRevertIfFails() external {
        vm.expectRevert();
        fundMe.fund();
    }

    function testCheckIfBalanceUpdated()  external {
        vm.prank(user);
        console.log(user.balance);
        fundMe.fund{value:0.1 ether}();
        assertEq(1e17,fundMe.getaddressToAmountFunded(user));
        console.log(user.balance);

    }

    function testFunderAddShouldAddtoFundersArray() external {
        console.log(address(fundMe).balance);
        vm.prank(user);
        fundMe.fund{value:0.1 ether}();
         console.log(address(fundMe).balance);
        assertEq(user,fundMe.getFundersAddress(0));
    }

    function testOnlyOwnerCanWithdrawFunds() external view {
         console.log(address(fundMe).balance);
        assertEq(msg.sender,fundMe.getOwner());
    }

    modifier funded {
          vm.prank(user);
        fundMe.fund{value: 0.1 ether}();
        _;
    }

    function testWithdrawFundsToOwner() external  funded{
        address owner = fundMe.getOwner();
        uint256 prevContractBalance = address(fundMe).balance;
        uint256 prevOwnerBalance = fundMe.getOwner().balance;
        vm.prank(owner);
        fundMe.withdraw();
        assertEq(address(fundMe).balance,0);
        assertEq(prevContractBalance  + prevOwnerBalance, owner.balance);
    }


    function testgetWithdrawFromMultipleUsers() external funded{
        for(uint160 index = 1;index<=10;++index){
            hoax(address(index),1e18);
            fundMe.fund{value: 0.1 ether}();
        }
        uint256 prevContractBalance = address(fundMe).balance;
        uint256 prevOwnerBalance = address(fundMe.getOwner()).balance;
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        assertEq(address(fundMe).balance,0);
        assertEq(prevContractBalance + prevOwnerBalance, fundMe.getOwner().balance);
    }
}