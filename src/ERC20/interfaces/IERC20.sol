// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    // Variables
    function name() external returns (string memory);
    function symbol() external returns (string memory);
    function decimals() external returns (uint8);
    function balanceOf(address user) external returns (uint256);
    function allowance(address user, address allowedUser) external returns (uint256);
    function totalSupply() external returns (uint256);

    // Functions
    function transfer(address to, uint256 value) external;
    function transferFrom(address from, address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
}
