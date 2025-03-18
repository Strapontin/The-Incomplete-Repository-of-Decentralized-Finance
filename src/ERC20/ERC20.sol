// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../Constants.sol";

import {IERC20} from "./interfaces/IERC20.sol";

/**
 * This contract represent an ERC-20 fungible token
 * Read the ERC here : https://eips.ethereum.org/EIPS/eip-20
 *
 * These tokens have many uses. The most common use is
 * to represent a user's balance.
 */
/**
 * Variables
 * - name
 * - symbol
 * - decimals
 * - balanceOf
 * - allowance
 * - totalSupply
 *
 * Functions
 * - transfer
 * - transferFrom
 * - approve
 *
 * Helper functions
 * - mint
 * - burn
 */
contract SimpleERC20 is IERC20 {
    // `name` and `symbol` are commonly used to represent a token
    // in a more reable way. The popular USDC token's name is "USD Coin",
    // and its symbol is "USDC"
    string public name;
    string public symbol;

    // Since Solidity does not have decimal variables, we use a variable
    //  that counts the decimals needed for our token.
    // The common decimal value used is 18, but some token can use a different value
    // (eg: USDC uses 6 decimals : https://etherscan.io/token/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48#readProxyContract#F11)
    uint8 public immutable decimals = 18;

    // `balances` represent the amount of tokens a user has
    mapping(address user => uint256) public balanceOf;

    // A user can allow another user (or contract) to spend a maximum of X tokens on their
    // behalf. This amount is represented in the `allowance` variable
    mapping(address user => mapping(address allowedUser => uint256)) public allowance;

    // Represent the sum of all `balances`
    uint256 public totalSupply;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    /**
     * `msg.sender` will send their token to another user
     * @param to The receiver of the tokens
     * @param value The amount of tokens to send
     */
    function transfer(address to, uint256 value) external {
        // If the sender tries to send more tokens than what they own,
        // then the next line will revert (underflow)
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
    }

    /**
     * Transfer tokens from the `from` address, if the `msg.sender` is approved
     * @param from The address to send tokens from
     * @param to The receiver of the tokens
     * @param value The amount of tokens to send
     */
    function transferFrom(address from, address to, uint256 value) external {
        // require(
        //     allowance[from][msg.sender] >= value,
        //     "The from address did not approve the sender for at least this amount of tokens"
        // );

        // If the sender is not allowed by the from for at least the `value` amount
        // to transfer, then the next line will revert
        allowance[from][msg.sender] -= value;
        balanceOf[from] -= value;
        balanceOf[to] += value;
    }

    /**
     * `msg.spender` allows `spender` to use `value` amount of their tokens
     * @param spender Address allowed to spend `msg.sender`'s tokens
     * @param value Amount allowed to be spent
     */
    function approve(address spender, uint256 value) external {
        allowance[msg.sender][spender] = value;
    }

    /**
     * Helper functions
     */
    modifier onlyHelper() {
        require(msg.sender == helperAddress);
        _;
    }

    /**
     * Create tokens out of thin air
     * @param to The address who receives the tokens
     * @param value The amount of tokens to create
     */
    function mint(address to, uint256 value) external onlyHelper {
        _mint(to, value);
    }

    /**
     * Internal implementation of `mint`, so it can be used when inherited
     */
    function _mint(address to, uint256 value) internal {
        balanceOf[to] += value;
        totalSupply += value;
    }

    /**
     * Burns tokens from an address. This means the tokens will be permanently removed
     * @param from The address from which we burn the tokens
     * @param value The amount of tokens to burn
     */
    function burn(address from, uint256 value) external onlyHelper {
        _burn(from, value);
    }

    /**
     * Internal implementation of `burn`, so it can be used when inherited
     */
    function _burn(address from, uint256 value) internal {
        balanceOf[from] -= value;
        totalSupply -= value;
    }
}
