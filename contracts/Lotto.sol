// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Strings.sol";
import {Player, Game, Winner} from "./Entities.sol";

contract Lotto {
    address public owner;
    Game public game;
    Player[] private players;
    uint256[] private pastGames;
    mapping(uint256 => Winner) private history;

    constructor() {
        owner = msg.sender;
        game = Game({id: block.timestamp, total: 0});
    }

    function getPastGamesIds() public view returns (uint256[] memory) {
        return pastGames;
    }

    function getPastGameWinner(
        uint256 gameId
    ) public view returns (string memory) {
        return history[gameId].player.username;
    }

    function getGameJackpot() public view returns (uint256) {
        return game.total;
    }

    function countGamePlayers() public view returns (uint) {
        return players.length;
    }

    function bet(
        string memory _username,
        string memory _email,
        uint256 _quantity
    ) public returns (bool) {
        require(
            _quantity < .01 ether,
            "Minimun bet quantity should be .01 ETH"
        );
        address _wallet = msg.sender;
        game.total += _quantity;
        players.push(
            Player({wallet: _wallet, username: _username, email: _email})
        );
        return true;
    }

    function pickWinner() public onlyowner returns (string memory) {
        Player memory winner = getRandomPlayer();
        archiveFinishedGame(winner);
        resetGame();
        return
            string.concat(
                "El usuario ",
                winner.username,
                " con email ",
                winner.email,
                " ha ganado ",
                Strings.toString(game.total),
                "ETH"
            );
    }

    function archiveFinishedGame(Player memory winner) private {
        history[game.id] = Winner({player: winner, total: game.total});
        pastGames.push(game.id);
    }

    function resetGame() private {
        game = Game({id: block.timestamp, total: 0});
        players = new Player[](0);
    }

    function getRandomPlayer() private view returns (Player memory) {
        uint index = getRandomNumber() % players.length;
        return players[index];
    }

    function getRandomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }
}
