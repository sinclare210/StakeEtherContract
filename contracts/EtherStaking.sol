// SPDX-License-Identifier: MIT-LICENSE
pragma solidity ^0.8.24;

contract EtherSatking{

event staked(address indexed user, uint256 indexed amount);
event Withdrawn(address indexed user, uint256 indexed amount);
event RewardClaimed(address indexed user, uint256 indexed amount);
event EmergencyWithdrawn(address indexed user, uint256 indexed amount);


    function stake() external{}
    function withdraw() external{}
    function rewardCalc() external{}
    function claimRewards() external{}
    function emergencyWithdraw() external {}
    function viewTotalStaked() external{}
    function viewUserStake() external{}
    function viewRewards() external{}
}