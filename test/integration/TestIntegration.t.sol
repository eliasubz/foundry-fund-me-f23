// SPDX-License-Identifier:	MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;

    address USER = makeAddr("User");
    uint256 constant SENT_VALUE = 0.1 ether;
    uint256 constant STARTING_VALUE = 10 ether;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        deployer.run();
        fundMe = deployer.fundMe();
        vm.deal(USER, STARTING_VALUE);
    }

    function testUserCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdraw = new WithdrawFundMe();
        withdraw.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
