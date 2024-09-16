// SPDX-License-Identifier: MIT-LICENSE
pragma solidity ^0.8.24;

contract EtherStaking{

   error  TimeNotExceeded();
   error ZeroAddressDetected();
   error AlreadyClaimed();
   error TimeExceededGoClaimRewards();

    event staked(address indexed user, uint256 indexed amount, uint256 indexed period);
    event Withdrawn(address indexed user, uint256 indexed amount);
    event RewardClaimed(address indexed user, uint256 indexed amount);
    event EmergencyWithdrawn(address indexed user, uint256 indexed amount);

    address public owner;

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



    function stake(uint256 _periodInDays) external payable{

        _onlyOwner();
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        stakers[msg.sender].amount = msg.value;
        stakers[msg.sender].period = (_periodInDays * 1 days) + block.timestamp;
        stakers[msg.sender].stillStaked = true;
        emit staked(msg.sender, msg.value, _periodInDays);
        totalStaked += msg.value;
    }

     function rewardCalc() private view returns(uint256){
        return ((stakers[msg.sender].amount * (stakers[msg.sender].period/31557600) * 20/100) / 100);
     }

    function withdraw() external{
        _onlyOwner();
         if(msg.sender == address(0)){revert ZeroAddressDetected();}
        if(block.timestamp <= stakers[msg.sender].period){revert TimeNotExceeded();}
        stakers[msg.sender].amount = 0;
        if(stakers[msg.sender].stillStaked == true){
            (bool success,) = msg.sender.call{value: stakers[msg.sender].amount + rewardCalc()}("");
            require(success);
            emit Withdrawn(msg.sender, stakers[msg.sender].amount + rewardCalc());
        }else{
            (bool success,) = msg.sender.call{value: stakers[msg.sender].amount}("");
            require(success);
            emit Withdrawn(msg.sender, stakers[msg.sender].amount);
        }
       

        

    }
   
    function claimRewards() external{
         _onlyOwner();
        if( stakers[msg.sender].stillStaked == false){revert AlreadyClaimed();}
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        if(block.timestamp <= stakers[msg.sender].period){revert TimeNotExceeded();}
        stakers[msg.sender].stillStaked = false;
        stakers[msg.sender].amount = stakers[msg.sender].amount + rewardCalc();
        emit RewardClaimed(msg.sender, rewardCalc());
    }

    function emergencyWithdraw() external {
        _onlyOwner();
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        if(block.timestamp >= stakers[msg.sender].period){revert TimeExceededGoClaimRewards();}
        stakers[msg.sender].amount = 0;
        (bool success,) = msg.sender.call{value: stakers[msg.sender].amount}("");
        require(success);
        emit EmergencyWithdrawn(msg.sender,stakers[msg.sender].amount);

    }
    function viewTotalStaked() external view returns(uint256){
        
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        return totalStaked;
    }
    function viewUserStake() external view returns(uint256){
        _onlyOwner();
          if(msg.sender == address(0)){revert ZeroAddressDetected();}
        return stakers[msg.sender].amount;
    }
    function viewRewards() external view returns(uint256){
     
    if(msg.sender == address(0)){revert ZeroAddressDetected();}
      return  rewardCalc();
    }

    function _onlyOwner() public view{
       require(  owner == msg.sender);
    }
}