// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "src/ERC20/interfaces/IERC20.sol";

interface IERC4626 {
    // Variables
    function asset() external view returns (IERC20);

    // Functions
    function totalAssets() external view returns (uint256 assets);
    function totalShares() external view returns (uint256 shares);
    function convertToShares(uint256 amount) external view returns (uint256 shares);
    function convertToAssets(uint256 amount) external view returns (uint256 assets);

    function deposit(uint256 amount) external returns (uint256 shares);
    function withdraw(uint256 amount) external returns (uint256 shares);
    function mintShares(uint256 amount) external returns (uint256 assets);
    function redeem(uint256 amount) external returns (uint256 assets);
}
