// SPDX-License-Identifier:	MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        deployFundMe.run();
        fundMe = deployFundMe.fundMe();
    }

    function testMinDollarIsFive() public {
        console.log("Hello");
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 verion = fundMe.getVersion();
        console.log(verion);
        console.log("Hello");
        assertEq(fundMe.getVersion(), 4);
    }
}
