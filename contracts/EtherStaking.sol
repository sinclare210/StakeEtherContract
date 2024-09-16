// SPDX-License-Identifier: MIT-LICENSE
pragma solidity ^0.8.24;

contract EtherSatking{

   error  TimeNotExceeded();
   error ZeroAddressDetected();
   error AlreadyClaimed();

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
        bool stillStaked;
    }

    uint256 totalStaked;

    mapping (address => StakingInfo) private stakers;



    function stake(uint256 _amount, uint256 _periodInDays) external{

        _onlyOwner();
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        stakers[msg.sender].amount = _amount * 10e8;
        stakers[msg.sender].period = (_periodInDays * 24 * 60 * 60) + block.timestamp;
        stakers[msg.sender].stillStaked = true;
        emit staked(msg.sender, _amount, _periodInDays);
        totalStaked += _amount;
    }

     function rewardCalc() private view returns(uint256){
        return ((stakers[msg.sender].amount * (stakers[msg.sender].period/31557600) * 20/10) / 100) * 10e8;
     }

    function withdraw() external{
        _onlyOwner();
         if(msg.sender == address(0)){revert ZeroAddressDetected();}
        if(block.timestamp <= stakers[msg.sender].period){revert TimeNotExceeded();}
        stakers[msg.sender].amount = 0;

        (bool success,) = msg.sender.call{value: stakers[msg.sender].amount + rewardCalc()}("");
        require(success);

    }
   
    function claimRewards() external{
         _onlyOwner();
         if( stakers[msg.sender].stillStaked = false){revert AlreadyClaimed();}
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        if(block.timestamp <= stakers[msg.sender].period){revert TimeNotExceeded();}
        stakers[msg.sender].stillStaked = false;
        stakers[msg.sender].amount = stakers[msg.sender].amount + rewardCalc();
    }

    function emergencyWithdraw() external {}
    function viewTotalStaked() external view returns(uint256){
        _onlyOwner();
        return totalStaked;
    }
    function viewUserStake() external view returns(uint256){
        _onlyOwner();
        return stakers[msg.sender].amount;
    }
    function viewRewards() external{}

    function _onlyOwner() private view{
        msg.sender == owner;
    }
}