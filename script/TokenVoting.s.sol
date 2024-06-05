// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import { TokenVoting } from "../src/TokenVoting.sol";

contract DeployTokenVoting is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        TokenVoting tokenVoting = new TokenVoting();

        console.log("TokenVoting contract deployed at: ", address(tokenVoting));

        vm.stopBroadcast();
    }
}
