// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Strings.sol";
import {Player, Game, Winner} from "./Entities.sol";

contract Lotto {
    address public owner;
    Game public game;
    Player[] private players;
    string[] private pastGames;
    mapping(string => Winner) private history;

    constructor() {
        owner = msg.sender;
        game = Game({id: Strings.toString(block.timestamp), total: 0});
    }

    function getPastGamesIds() public view returns (string[] memory) {
        return pastGames;
    }

    function getPastGameWinner(
        string memory gameId
    ) public view returns (string memory) {
        return history[gameId].player.username;
    }

    function getGameJackpot() public view returns (uint256) {
        return game.total;
    }

    function countGamePlayers() public view returns (uint) {
        return players.length;
    }

    function bet(string memory _username, string memory _email) public {
        address _wallet = msg.sender;
        game.total += 2e16;
        players.push(
            Player({wallet: _wallet, username: _username, email: _email})
        );
    }

    function pickWinner() public onlyowner returns (string memory) {
        uint256 winnerIndex = getWinnerIndex();
        string memory message = string.concat(
            "El usuario ",
            players[winnerIndex].username,
            " con email ",
            players[winnerIndex].email,
            " ha ganado ",
            Strings.toString(game.total),
            "ETH"
        );
        archiveFinishedGame(winnerIndex);
        resetGame();
        return message;
    }

    function archiveFinishedGame(uint256 winnerIndex) private {
        history[game.id] = Winner({
            player: players[winnerIndex],
            total: game.total
        });
        pastGames.push(game.id);
    }

    function resetGame() private {
        game = Game({id: Strings.toString(block.timestamp), total: 0});
        delete players;
    }

    function getWinnerIndex() private view returns (uint256) {
        return getRandomNumber() % players.length;
    }

    function getRandomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }
}
