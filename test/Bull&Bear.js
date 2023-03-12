const BullBear = artifacts.require("BullBear");

contract("BullBear", () => {
    let bullBear = null;
    let primaryAccount = null;
    before(async () => {
        bullBear = await BullBear.deployed();
        [primaryAccount] = await web3.eth.getAccounts();
    });

    it("Contract deployed", () => {
        assert(bullBear.address != "");
    });

    it("Mint to primary address", async () => {
        const tx = await bullBear.safeMint(primaryAccount);
        assert(tx != null);
    });

    it("Check balance of primary", async () => {
        const result = await bullBear.balanceOf(primaryAccount);
        assert(result.toNumber() == 1);
    });

    it("Check total supply", async () => {
        const result = await bullBear.totalSupply();
        assert(result.toNumber() == 1);
    });

    it("Check currentPrice", async () => {
        const result = await bullBear.currentPrice();
        assert(result.toString() == "3034715771688");
    });

    it("Check priceFeed", async () => {
        const result = await bullBear.priceFeed();
        assert(result);
    });

    it("Check tokenURI (0)", async () => {
        const result = await bullBear.tokenURI(0);
        assert(
            result ==
                "https://cloudflare-ipfs.com/ipfs/QmRXyfi3oNZCubDxiVFre3kLZ8XeGt6pQsnAQRZ7akhSNs"
        );
    });

    it("Check ownerOf (0)", async () => {
        const result = await bullBear.ownerOf(0);
        assert(result == primaryAccount);
    });
});
