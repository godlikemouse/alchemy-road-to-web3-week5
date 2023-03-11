const MockV3Aggregator = artifacts.require("MockV3Aggregator");

contract("MockV3Aggregator", () => {
    let contract = null;

    before(async () => {
        contract = await MockV3Aggregator.deployed();
    });

    it("Contract deployed", () => {
        assert(contract.address != "");
    });

    it("latestRoundData() == 3034715771688", async () => {
        const result = await contract.latestRoundData();
        const { roundId, answer, startedAt, updatedAt, answeredInRound } =
            result;
        assert(answer.toString() == "3034715771688");
    });

    it("updateAnswer(2834715771688)", async () => {
        const tx = await contract.updateAnswer(2834715771688);
        assert(tx != null);
    });

    it("latestAnswer() == 2834715771688", async () => {
        const result = await contract.latestAnswer();
        assert(result.toString() == "2834715771688");
    });

    it("latestRoundData() == 2834715771688", async () => {
        const result = await contract.latestRoundData();
        const { roundId, answer, startedAt, updatedAt, answeredInRound } =
            result;
        assert(answer.toString() == "2834715771688");
    });
});
