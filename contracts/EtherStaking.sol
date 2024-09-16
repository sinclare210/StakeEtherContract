// SPDX-License-Identifier: MIT-LICENSE
pragma solidity ^0.8.24;

contract EtherSatking{

    event staked(address indexed user, uint256 indexed amount, uint256 indexed period);
    event Withdrawn(address indexed user, uint256 indexed amount);
    event RewardClaimed(address indexed user, uint256 indexed amount);
    event EmergencyWithdrawn(address indexed user, uint256 indexed amount);

    address immutable owner;

    constructor(){
        owner = msg.sender;
    }

    struct StakingInfo{
        uint256 amount;
        uint256 period;
    }

    mapping (address => StakingInfo) private stakers;



    function stake(uint256 _amount, uint256 _periodInDays) external{
        _onlyOwner();
        stakers[msg.sender].amount = _amount;
        stakers[msg.sender].period = (_periodInDays * 24 * 60 * 60) + block.timestamp;
        emit staked(msg.sender, _amount, _periodInDays);
    }

     function rewardCalc() external{
        
     }

    function withdraw() external{}
   
    function claimRewards() external{}
    function emergencyWithdraw() external {}
    function viewTotalStaked() external{}
    function viewUserStake() external{}
    function viewRewards() external{}

    function _onlyOwner() private view{
        msg.sender == owner;
    }
}