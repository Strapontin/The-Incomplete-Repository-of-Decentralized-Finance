// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SimpleERC20} from "src/ERC20/ERC20.sol";


/**
 * This test suite will use simple low values for tests.
 * Alice and Bob start both with 200 units of token.
 * 
 * Since decimals are 18 for our tokens, user will need 1e18 units of
 * token to actually own 1 token.
 */
contract ERC20Test is Test {
    address helper;
    SimpleERC20 token;

    address alice;
    address bob;
    address charlie;

    function setUp() public {
        helper = makeAddr("helper");
        token = new SimpleERC20("SimpleTokenName", "STK");

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");

        // Alice and Bob start with 200 tokens each
        vm.startPrank(helper);
        token.mint(alice, 100);
        token.mint(bob, 100);
        vm.stopPrank();
    }

    function testStaticValues() public view {
        assertEq(token.name(), "SimpleTokenName");
        assertEq(token.symbol(), "STK");
        assertEq(token.totalSupply(), 200);
        assertEq(token.decimals(), 18);
    }

    function testTokenTransferSuccess() public {
        // Alice wants to transfer 10 tokens to bob
        vm.prank(alice);
        token.transfer(bob, 10);

        // She now has 10 less tokens, and bob 10 more
        assertEq(token.balanceOf(alice), 90);
        assertEq(token.balanceOf(bob), 110);
    }

    function testTokenTransferFailsWithTooHighAmount() public {
        // Alice wants to transfer more than 100 tokens to bob
        vm.prank(alice);
        vm.expectRevert();
        token.transfer(bob, 101);
    }

    function testTransferFromWorks() public {
        // Alice wants to allow bob to transfer 50 of her tokens
        vm.prank(alice);
        token.approve(bob, 50);

        // Bob can transfer her 50 tokens
        vm.prank(bob);
        token.transferFrom(alice, bob, 50);

        assertEq(token.balanceOf(alice), 50);
        assertEq(token.balanceOf(bob), 150);
    }

    function testAnotherUserCantTransferFromIfNotApprove() public {
        // Alice wants to allow bob to transfer 50 of her tokens
        vm.prank(alice);
        token.approve(bob, 50);

        // Charlie should not be able to transfer anything
        vm.prank(charlie);
        vm.expectRevert();
        token.transferFrom(alice, bob, 10);
    }

    function testTransferFromCantTransferMoreThanApproveAmount() public {
        // Alice wants to allow bob to transfer 50 of her tokens
        vm.prank(alice);
        token.approve(bob, 50);

        // Bob can't transfer more than 50 tokens
        vm.startPrank(bob);
        vm.expectRevert();
        token.transferFrom(alice, bob, 51);

        // Bob can transfer his 50 allowed tokens in multiple transactions
        token.transferFrom(alice, bob, 25);

        assertEq(token.allowance(alice, bob), 25);

        token.transferFrom(alice, bob, 25);

        // Bob can't transfer more tokens
        vm.expectRevert();
        token.transferFrom(alice, bob, 1);
    }
}
