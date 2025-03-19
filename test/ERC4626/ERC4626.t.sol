// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SimpleERC20} from "src/ERC20/ERC20.sol";
import {SimpleERC4626} from "src/ERC4626/ERC4626.sol";

/**
 */
contract ERC4626Test is Test {
    address helper;
    SimpleERC20 token;
    SimpleERC4626 vault;

    address alice;
    address bob;
    address charlie;

    function setUp() public {
        helper = makeAddr("helper");
        token = new SimpleERC20("Underlying Token", "UT");
        vault = new SimpleERC4626(address(token));

        alice = makeAddr("alice");
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");

        // Alice and Bob start with 100 underlying tokens each
        vm.startPrank(helper);
        token.mint(alice, 100);
        token.mint(bob, 100);
        vm.stopPrank();

        vm.prank(alice);
        token.approve(address(vault), type(uint256).max);
        vm.prank(bob);
        token.approve(address(vault), type(uint256).max);
    }

    function testAssetAndSharesAreCorrect() public {
        // At vault creation, there are no assets and no shares
        assertEq(vault.totalAssets(), 0);
        assertEq(vault.totalShares(), 0);

        // When we don't have anything in the vault, the ratio is 1:1
        assertEq(vault.convertToShares(100), 100);
        assertEq(vault.convertToAssets(100), 100);

        // Alice deposits 100 token and receives 100 shares
        vm.prank(alice);
        assertEq(vault.deposit(100), 100);
        // Same for bob
        vm.prank(bob);
        assertEq(vault.deposit(100), 100);

        // We now have a total of 200 assets and 200 shares (100 for each actors)
        assertEq(vault.totalAssets(), 200);
        assertEq(vault.totalShares(), 200);
    }

    function testRewardsAccruedCorrectly_OneUser() public {
        // Alice deposits her 100 tokens and get 100 shares
        vm.prank(alice);
        assertEq(vault.deposit(100), 100);

        // This simulates a reward of 100 tokens in the vault
        vm.prank(helper);
        token.mint(address(vault), 100);

        // Alice still has 100 shares, but now when she withdraws she will get 200 tokens
        assertEq(vault.balanceOf(alice), 100);
        assertEq(vault.convertToAssets(100), 200);

        vm.prank(alice);
        assertEq(vault.withdraw(200), 100);

        assertEq(token.balanceOf(alice), 200);
    }

    function testRewardsAccruedCorrectly_MultipleUsers() public {
        // Alice and Bob deposits 100 tokens and get 100 shares
        vm.prank(alice);
        assertEq(vault.deposit(100), 100);
        vm.prank(bob);
        assertEq(vault.deposit(100), 100);

        // This simulates a reward of 100 tokens in the vault
        vm.prank(helper);
        token.mint(address(vault), 100);

        // Alice still has 100 shares, but now when she withdraws she will get 150 tokens
        assertEq(vault.balanceOf(alice), 100);
        assertEq(vault.convertToAssets(100), 150);

        vm.prank(alice);
        assertEq(vault.withdraw(150), 100);
        assertEq(token.balanceOf(alice), 150);

        // When Bob withdraws, he also gets 150 tokens
        vm.prank(bob);
        assertEq(vault.withdraw(150), 100);
        assertEq(token.balanceOf(bob), 150);
    }

    function testMintAndRedeemShares() public {
        // Show with 2 users.
    }

    function testUserDepositingAfterRewardsCantClaimThemAndGetsLessAmountOfShares() public {
        // Show that interacting with the vault after reward does change the shares given
    }

    function testVaultCanLooseTokensAndUsersWillHaveLessAssets() public {
        // Show the loss of rewards
    }
}
