//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract MockVRFCoordinator {
    uint256 internal counter = 0;

    function requestRandomWords(
        bytes32,
        uint64,
        uint16,
        uint32,
        uint32 numWords
    ) external returns (uint256 requestId) {
        VRFConsumerBaseV2 consumer = VRFConsumerBaseV2(msg.sender);
        uint256[] memory randomWords = new uint256[](numWords);
        counter++;
        for (uint8 i = 0; i < numWords; i++) {
            randomWords[i] = block.timestamp;
        }
        consumer.rawFulfillRandomWords(counter, randomWords);
        return counter;
    }
}
