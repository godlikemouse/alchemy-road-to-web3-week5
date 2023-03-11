const BullBear = artifacts.require("BullBear");
const MockV3Aggregator = artifacts.require("MockV3Aggregator");

module.exports = function (deployer) {
    deployer.deploy(MockV3Aggregator, 8, 3034715771688);
    deployer.deploy(BullBear, 10, "0xB7B67B30F5A84aF11fB98279369913f8fb06da70");
};
