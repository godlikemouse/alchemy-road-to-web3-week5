const MockVRFCoordinator = artifacts.require("MockVRFCoordinator");

contract("MockVRFCoordinator", () => {
    let contract = null;

    before(async () => {
        contract = await MockVRFCoordinator.deployed();
    });

    it("Contract deployed", () => {
        assert(contract.address != "");
    });
});
