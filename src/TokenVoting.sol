// src/TokenVoting.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenVoting {
    // Define a structure for the Token
    struct Token {
        address tokenAddress; // Address of the ERC20 token
        string name;          // Name of the token
        uint256 voteCount;    // Number of votes the token has received
    }

    // Mapping to store registered tokens by their address
    mapping(address => Token) public tokens;
    // Mapping to check if a token is registered
    mapping(address => bool) public isTokenRegistered;
    // Mapping to track votes by user and token
    mapping(address => mapping(address => bool)) public hasVoted;

    // Admin address, only the admin can register tokens
    address public admin;

    // Events to log actions
    event TokenRegistered(address tokenAddress, string name);
    event Voted(address voter, address tokenAddress);

    // Constructor to set the admin as the contract deployer
    constructor() {
        admin = msg.sender;
    }

    // Modifier to restrict functions to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // Function to register a token for voting
    function registerToken(address _tokenAddress, string memory _name) public onlyAdmin {
        require(!isTokenRegistered[_tokenAddress], "Token is already registered");

        // Add the token to the tokens mapping
        tokens[_tokenAddress] = Token({
            tokenAddress: _tokenAddress,
            name: _name,
            voteCount: 0
        });

        // Mark the token as registered
        isTokenRegistered[_tokenAddress] = true;

        // Emit an event that the token has been registered
        emit TokenRegistered(_tokenAddress, _name);
    }

    // Function to vote for a registered token
    function vote(address _tokenAddress) public {
        require(isTokenRegistered[_tokenAddress], "Token is not registered");
        require(!hasVoted[msg.sender][_tokenAddress], "You have already voted for this token");

        // Increment the vote count for the token
        tokens[_tokenAddress].voteCount += 1;
        // Mark that the user has voted for this token
        hasVoted[msg.sender][_tokenAddress] = true;

        // Emit an event that the user has voted
        emit Voted(msg.sender, _tokenAddress);
    }

    // Function to get the vote count for a specific token
    function getVoteCount(address _tokenAddress) public view returns (uint256) {
        require(isTokenRegistered[_tokenAddress], "Token is not registered");

        // Return the vote count of the token
        return tokens[_tokenAddress].voteCount;
    }
}