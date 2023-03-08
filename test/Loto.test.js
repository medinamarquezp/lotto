const Lotto = artifacts.require("Lotto");

contract("Lotto", (accounts) => {
  before(async () => {
    instance = await Lotto.deployed();
  });

  it("Should validate initial status", async () => {
    const jackpot = await instance.getGameJackpot();
    const players = await instance.countGamePlayers();
    assert.equal(jackpot, 0, "Initial jackpot should be 0");
    assert.equal(players, 0, "Initial game players should be 0");
  });

  it("History should be cleaned on init game", async () => {
    const pastGamesIds = await instance.getPastGamesIds();
    assert.equal(
      pastGamesIds.length,
      0,
      "History should be cleaned on init game"
    );
  });

  it("Should create first bet", async () => {
    const username = "firstUser";
    const email = "first-user@test.com";
    const { receipt } = await instance.bet(username, email, {
      value: web3.utils.toWei(".001", "ether"),
    });
    assert.equal(receipt.status, true, "Should create first bet");
  });

  it("Status should be updated after first bet", async () => {
    const jackpot = await instance.getGameJackpot();
    const players = await instance.countGamePlayers();
    const expectedJackpot = web3.utils.toBN(web3.utils.toWei(".001", "ether"));
    assert.equal(
      jackpot.toString(),
      expectedJackpot.toString(),
      "Jackpot should be updated after first bet"
    );
    assert.equal(
      players.toString(),
      "1",
      "Players should be updated after first bet"
    );
  });

  it("Should create second bet", async () => {
    const username = "secondUser";
    const email = "second-user@test.com";
    const { receipt } = await instance.bet(username, email, {
      value: web3.utils.toWei(".001", "ether"),
    });
    assert.equal(receipt.status, true, "Should create second bet");
  });

  it("Status should be updated after second bet", async () => {
    const jackpot = await instance.getGameJackpot();
    const players = await instance.countGamePlayers();
    const expectedJackpot = web3.utils.toBN(web3.utils.toWei(".002", "ether"));
    assert.equal(
      jackpot.toString(),
      expectedJackpot.toString(),
      "Jackpot should be updated after second bet"
    );
    assert.equal(
      players.toString(),
      "2",
      "Players should be updated after second bet"
    );
  });

  it("Should pick a winner and close game", async () => {
    const { receipt } = await instance.pickWinner();
    assert.equal(receipt.status, true, "Should pick a winner and close game");
  });

  it("Should obtain past games data", async () => {
    const pastGamesIds = await instance.getPastGamesIds();
    const pastWinner = await instance.getPastGameWinner(pastGamesIds[0]);
    assert.equal(pastGamesIds.length, 1, "It should be only one game");
    assert.equal(
      ["firstUser", "secondUser"].includes(pastWinner),
      true,
      "Last winner should be one of available gamers"
    );
  });

  it("Should reset status after close game", async () => {
    const jackpot = await instance.getGameJackpot();
    const players = await instance.countGamePlayers();
    assert.equal(jackpot, 0, "Reset jackpot should be 0");
    assert.equal(players, 0, "Reset game players should be 0");
  });
});
