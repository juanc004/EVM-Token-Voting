// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenVoting} from "../src/TokenVoting.sol";

contract TokenVotingTest is Test {
    TokenVoting public tokenVoting;

    function setUp() public {
        // Deploy the TokenVoting contract
        tokenVoting = new TokenVoting();
    }

    function test_RegisterToken() public {
        // Register a new token
        tokenVoting.registerToken(address(1), "TestToken");
        
        // Verify the token is registered
        (address tokenAddress, string memory name, uint256 voteCount) = tokenVoting.tokens(address(1));
        assertEq(tokenAddress, address(1));
        assertEq(name, "TestToken");
        assertEq(voteCount, 0);
    }

    function test_Vote() public {
        // Register a new token
        tokenVoting.registerToken(address(1), "TestToken");
        
        // Vote for the token
        tokenVoting.vote(address(1));
        
        // Verify the vote count is incremented
        uint256 voteCount = tokenVoting.getVoteCount(address(1));
        assertEq(voteCount, 1);
        
        // Verify the user has voted for the token
        bool hasVoted = tokenVoting.hasVoted(address(this), address(1));
        assertTrue(hasVoted);
    }

    function test_CannotVoteTwice() public {
        // Register a new token
        tokenVoting.registerToken(address(1), "TestToken");
        
        // Vote for the token
        tokenVoting.vote(address(1));
        
        // Try to vote again and expect a revert
        vm.expectRevert("You have already voted for this token");
        tokenVoting.vote(address(1));
    }

    function testFuzz_RegisterToken(address tokenAddress, string memory name) public {
        // Register a new token with fuzzed inputs
        tokenVoting.registerToken(tokenAddress, name);
        
        // Verify the token is registered
        (address registeredAddress, string memory registeredName, uint256 voteCount) = tokenVoting.tokens(tokenAddress);
        assertEq(registeredAddress, tokenAddress);
        assertEq(registeredName, name);
        assertEq(voteCount, 0);
    }

    function testFuzz_Vote(address tokenAddress) public {
        // Register a new token with fuzzed input
        tokenVoting.registerToken(tokenAddress, "FuzzToken");
        
        // Vote for the token with fuzzed input
        tokenVoting.vote(tokenAddress);
        
        // Verify the vote count is incremented
        uint256 voteCount = tokenVoting.getVoteCount(tokenAddress);
        assertEq(voteCount, 1);
        
        // Verify the user has voted for the token
        bool hasVoted = tokenVoting.hasVoted(address(this), tokenAddress);
        assertTrue(hasVoted);
    }
}