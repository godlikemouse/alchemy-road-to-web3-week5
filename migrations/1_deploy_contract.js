require("dotenv").config();
const { VRF_SUBSCRIPTION_ID } = process.env;

const BullBear = artifacts.require("BullBear");
const MockV3Aggregator = artifacts.require("MockV3Aggregator");

module.exports = function (deployer) {
    deployer.then(async () => {
        // pass mock address into BullBear contructor as _priceFeed
        const mock = await deployer.deploy(MockV3Aggregator, 8, 3034715771688);
        await deployer.deploy(
            BullBear,
            10,
            mock.address /*VRF_SUBSCRIPTION_ID*/
        );
    });
};
