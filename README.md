# Alchemy's Road to Web3 Week 5

This repository covers the modified code following Alchemy's Road to Web3 Week 5.

## Development Environment Setup

Ensure you have npm installed. Create a `.env` file under the root directory which includes the following keys:

    API_KEY=
    MNEMONIC=
    VRF_SUBSCRIPTION_ID=

The `API_KEY` can be obtained by registering an application with alchemy at https://dashboard.alchemy.com. The `MNEMONIC` is generated when running `truffle develop`.
The `VRF_SUBSCRIPTION_ID` can be obtained by registering a subscription at https://vrf.chain.link/goerli.

#### Install Dependencies

    npm i

### Testing

For local:

    truffle test

For Goerli:

    truffle test --network goerli

### Deployment

For local:

    truffle deploy --reset

For Goerli

    truffle deploy --reset --network goerli
