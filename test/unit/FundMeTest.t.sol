// SPDX-License-Identifier:	MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("User");
    uint256 constant SENT_VALUE = 0.1 ether;
    uint256 constant STARTING_VALUE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        deployFundMe.run();
        fundMe = deployFundMe.fundMe();
        vm.deal(USER, STARTING_VALUE);
    }

    function testMinDollarIsFive() public {
        console.log("Hello");
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 verion = fundMe.getVersion();
        console.log(verion);
        console.log("Hello");
        assertEq(fundMe.getVersion(), 4);
    }

    function testFailsWithoutEnoughtETH() public {
        vm.expectRevert();
        console.log("testFails");
        //fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.deal(USER, STARTING_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SENT_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SENT_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.deal(USER, STARTING_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SENT_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.deal(USER, STARTING_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SENT_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SENT_VALUE);
            fundMe.fund{value: SENT_VALUE}();
        }

        uint256 startingOwnerBlance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // test

        assert(address(fundMe).balance == 0);
        assertEq(
            startingFundMeBalance + startingOwnerBlance,
            fundMe.getOwner().balance
        );
    }

    function testWithDrawWithMultipleFundersCheaoer() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SENT_VALUE);
            fundMe.fund{value: SENT_VALUE}();
        }

        uint256 startingOwnerBlance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        // test

        assert(address(fundMe).balance == 0);
        assertEq(
            startingFundMeBalance + startingOwnerBlance,
            fundMe.getOwner().balance
        );
    }
}
