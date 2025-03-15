# The-Incomplete-Repository-of-Decentralized-Finance

> [!CAUTION]
> This code is NOT safe for production.

This repository is created with the intent to provide simple and comprehensive examples of common DeFi protocols.

You will find simplified versions of some common decentralized applications, created to help you understand how they work under the hood.

These applications are intentionally created with flaws, as the purpose of this repository is to show basic implementations to strengthen the understanding of these protocols.

Once you have learned the concepts taught here, I invite you to use audited versions of these implementations if you want to create your own project, such as by using OpenZeppelin's libraries.

If you are interested in one kind of contract present in this repository, I invite you to read the implementation to understand how it is made, then read the test to see interaction examples.


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
