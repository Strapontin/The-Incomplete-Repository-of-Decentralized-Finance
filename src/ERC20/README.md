# ERC20 Description :

An ERC20 is a contract implementing the eip-20 that can be found here : https://eips.ethereum.org/EIPS/eip-20

This eip describes a standard interface for tokens. All tokens in a single eip have the same value : they are fungible tokens.

Since the EVM has no variable type to handle float numbers, a ‘decimals‘ variable is used to do so. 

The action of creating tokens out of thin air is called "minting". The action of destroying existing tokens is called "burning".