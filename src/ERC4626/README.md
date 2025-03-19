# ERC-4626 Description :

An ERC-4626 is a contract implementing the eip-4626 that can be found here : https://eips.ethereum.org/EIPS/eip-4626

This eip describes a standard for tokenized vaults representing shares of an amount of a single underlying [ERC-20](../ERC20/README.md) (also called asset). In DeFi, we see this standard in different kinds of contracts, such as lending markets, aggregators, or also intrinsically interest bearing tokens.

## How does it work ?

A vault gives a user shares for depositing an amount of the underlying token. While the ratio shares/underlying may be 1:1 at the beginning, this will change when the vault earns profit, or lose some (this can happen in a slashing where applicable, or if the vault gets hacked).

> If a vault has 200 total tokens to back 100 total shares, then each share is worth 2 tokens.

After understand how vaults work in this code, I suggest you get familiar with the EIP, which is not entirely implemented in this project. You may try to implement what's left if you feel like it would strengthen your understanding of this EIP.

Then, you should find some common vulnerabilities related to vaults, like the infamous Inflation Attack.