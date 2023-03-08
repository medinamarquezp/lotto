// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

struct Player {
    address payable wallet;
    string username;
    string email;
}

struct Winner {
    Player player;
    uint256 total;
}

struct Game {
    string id;
    uint256 total;
}
