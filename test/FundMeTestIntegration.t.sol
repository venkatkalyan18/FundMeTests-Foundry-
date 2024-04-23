//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


import {Test, console} from 'forge-std/Test.sol';
import {FundMe} from '../src/FundMe.sol';
import {Deploy} from '../script/Deploy.sol';
import {FundFundMe,WithdrawFundMe } from '../script/Interactions.s.sol';


contract FundMeIntergration is Test{
    FundMe fundMe;
    function setUp() external {
        Deploy deploy = new Deploy();
        fundMe = deploy.run();
    }

    function testUsersCanFundInteractions() public {
        FundFundMe fundfundMe = new FundFundMe();
        fundfundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assertEq(address(fundMe).balance,0);
    }
}