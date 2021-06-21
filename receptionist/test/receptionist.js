const { expect } = require("chai");

describe("Receptionist", function() {
  it("Should return the new greeting once it's changed", async function() {
    const Receptionist = await ethers.getContractFactory("Receptionist");
    const receptionist = await Receptionist.deploy("Hello, world!");
    await receptionist.deployed();

    const checkinTx = await receptionist.claim("Hola, mundo!");
    
    // wait until the transaction is mined
    await checkinTx.wait();

    expect(await checkinTx).to.exist();
  });
});
