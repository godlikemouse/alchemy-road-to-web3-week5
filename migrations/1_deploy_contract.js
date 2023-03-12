require("dotenv").config();
const { VRF_SUBSCRIPTION_ID } = process.env;

const BullBear = artifacts.require("BullBear");
const MockV3Aggregator = artifacts.require("MockV3Aggregator");
const MockVRFCoordinator = artifacts.require("MockVRFCoordinator");

module.exports = function (deployer) {
    deployer.then(async () => {
        // deploy mock aggregator
        const aggregator = await deployer.deploy(
            MockV3Aggregator,
            8,
            3034715771688
        );

        // deploy mock coordinator or use real coordinator
        // depending on network id
        const coordinator =
            deployer.network_id == 5
                ? {
                      address: "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",
                  }
                : await deployer.deploy(MockVRFCoordinator);

        // pass mock aggregator address into BullBear contructor as _priceFeed
        await deployer.deploy(
            BullBear,
            10,
            aggregator.address,
            VRF_SUBSCRIPTION_ID,
            coordinator.address
        );
    });
};
