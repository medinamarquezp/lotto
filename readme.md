# Lotto data management

This repository provides a basic example of a lotto data management with Solidity.

## Prerequisites

- Node JS installed: https://nodejs.org/en/download/
- Truffle suite installed: https://trufflesuite.com/docs/truffle/how-to/install/

## Testnet network

### Ethereum Goerli (testnet) information

- **Network:** Ethereum Goerli
- **New RPC URL:** https://goerli.infura.io/v3/
- **Chain ID:** 5
- **Currency symbol:** ETH
- **Block explorer:** https://goerli.etherscan.io/
- **Faucet:** https://goerlifaucet.com/

## Truffle

#### Deployment

```sh
truffle compile
truffle migrate --network DESIRED_NETWORK
```

#### Verification

```sh
truffle run verify DEPLOYED_CONTRACT_NAME@DEPLOYED_CONTRACT_ADDRESS --network DESIRED_NETWORK
```

#### Example with Goerli Network

```sh
truffle compile
truffle migrate --network ethereum_goerli_testnet
truffle run verify Lotto@0x... --network ethereum_goerli_testnet
```
