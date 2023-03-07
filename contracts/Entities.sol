// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

struct Player {
    address wallet;
    string username;
    string email;
}

struct Winner {
    Player player;
    uint256 total;
}

struct Game {
    uint256 id;
    uint256 total;
}
