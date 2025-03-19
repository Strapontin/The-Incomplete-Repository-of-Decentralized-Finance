// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../Constants.sol";

import {IERC20} from "../ERC20/interfaces/IERC20.sol";
import {SimpleERC20} from "../ERC20/ERC20.sol";
import {IERC4626} from "./interfaces/IERC4626.sol";

/**
 * This contract represent an ERC-4626 vault
 * Read the ERC here : https://eips.ethereum.org/EIPS/eip-4626
 */
contract SimpleERC4626 is IERC4626, SimpleERC20 {
    // Represents the underlying token handled by the vault
    IERC20 public immutable asset;

    constructor(address _asset) SimpleERC20("Vault Token (shares)", "VT") {
        asset = IERC20(_asset);
    }

    /**
     * This function returns the amount of the underlying asset managed by this vault
     * This includes any yield/loss
     */
    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    /**
     * Shares are tokens inherited by this contract
     */
    function totalShares() public view returns (uint256) {
        return totalSupply;
    }

    /**
     * Calculate the amount of shares based on the amount of assets
     * @param amount Amount of assets to represent in shares
     */
    function convertToShares(uint256 amount) public view returns (uint256) {
        // If we don't have shares yet, the ratio is 1:1
        if (totalShares() == 0) return amount;

        return amount * totalShares() / totalAssets();
    }

    /**
     * Calculate the amount of assets based on the amount of shares
     * @param amount Amount of shares to represent in assets
     */
    function convertToAssets(uint256 amount) public view returns (uint256) {
        // If we don't have assets yet, the ratio is 1:1
        if (totalAssets() == 0) return amount;

        return amount * totalAssets() / totalShares();
    }

    /**
     * Deposit `amount` of tokens. Earns `shares` amount of shares
     * @param amount Amount of tokens to deposit
     */
    function deposit(uint256 amount) public returns (uint256 shares) {
        // Calculates shares earned
        shares = convertToShares(amount);

        // Creates the shares for the user
        _mint(msg.sender, shares);

        // Transfer the asset from the caller
        asset.transferFrom(msg.sender, address(this), amount);
    }

    /**
     * Withdraws `amount` of tokens
     * @param amount Amount of tokens to withdraw
     */
    function withdraw(uint256 amount) public returns (uint256 shares) {
        // Calculates shares spend
        shares = convertToShares(amount);

        // Burns the shares from the user
        _burn(msg.sender, shares);

        // Transfer the asset to the caller
        asset.transfer(msg.sender, amount);
    }

    /**
     * Creates `amount` of shares by depositing the corresponding amount of assets
     * @param amount Amount of shares to mint
     */
    function mintShares(uint256 amount) public returns (uint256 assets) {
        // Calculate the amount of assets to deposit
        assets = convertToAssets(amount);

        // Creates the shares for the user
        _mint(msg.sender, amount);

        // Transfers the assets
        asset.transferFrom(msg.sender, address(this), assets);
    }

    /**
     * Burns `amount` of shares by withdrawing the corresponding amount of assets
     * @param amount Amount of shares to burn
     */
    function redeem(uint256 amount) public returns (uint256 assets) {
        // Calculate the amount of assets to withdraw
        assets = convertToAssets(amount);

        // Burns the shares from the user
        _burn(msg.sender, amount);

        // Transfers the assets
        asset.transfer(msg.sender, assets);
    }
}
