# ERC20 Description :

An ERC20 is a contract implementing the eip-20 that can be found here : https://eips.ethereum.org/EIPS/eip-20

This eip describes a standard interface for tokens. All tokens in a single eip have the same value : they are fungible tokens.

Since the EVM has no variable type to handle float numbers, a [`decimals`](./ERC20.sol#L43) variable is used to do so. 

## Creating and Destroying tokens

The action of creating tokens out of thin air is called "minting". The action of destroying existing tokens is called "burning". In most cases, these actions will not be available directly to users, or at least not for free.

Sometimes, tokens are created with an initial balance that doesn't change, and some other times it can be dynamically increased or decreased, like by using `mint` and `burn` in [our contract](./ERC20.sol#L113).