// SPDX-License-Identifier: MIT-LICENSE
pragma solidity ^0.8.24;

contract EtherStaking{

   error  TimeNotExceeded();
   error ZeroAddressDetected();
   error AlreadyClaimed();
   error TimeExceededGoClaimRewards();
   error AlreadyStaked();
    error JustGoAndClaim();
   error CantStakeZero();

    event staked(address indexed user, uint256 indexed amount, uint256 indexed period);
    event Withdrawn(address indexed user, uint256 indexed amount);
    event RewardClaimed(address indexed user, uint256 indexed amount);
    event EmergencyWithdrawn(address indexed user, uint256 indexed amount);


    address  public owner;
    uint256 public startTime;

    constructor(){
        owner = msg.sender;
       
        
    }

    struct StakingInfo{
        uint256 amount;
        uint256 period;
        bool stillStaked;
    }

    uint256 private totalStaked;

    mapping (address => StakingInfo) public stakers;
    function stake(uint256 _periodInDays) external payable{
        if(msg.sender == address(0)){revert ZeroAddressDetected();}
        if(stakers[msg.sender].stillStaked == true){revert AlreadyStaked();}
        if(msg.value <= 0){revert CantStakeZero();}
         startTime = block.timestamp;
       
        totalStaked += msg.value;
        stakers[msg.sender].amount = msg.value;  
        stakers[msg.sender].period = (_periodInDays * 1 days) + block.timestamp;
        stakers[msg.sender].stillStaked = true;  
     
    }

    function rewardCalc() public view returns (uint256) {
    if (totalStaked == 0) return 0; 
    
        return  (((stakers[msg.sender].period - startTime)) * stakers[msg.sender].amount * (totalStaked/stakers[msg.sender].amount));
    
 
    }


    function withdraw() external {
   
    if (msg.sender == address(0)) {revert ZeroAddressDetected();}
    if (block.timestamp < stakers[msg.sender].period) {revert TimeNotExceeded();}

    if (stakers[msg.sender].stillStaked == true) {
              
        totalStaked -= stakers[msg.sender].amount;
        stakers[msg.sender].amount = 0;
         stakers[msg.sender].stillStaked = false;

    
         

        (bool success, ) = msg.sender.call{value: stakers[msg.sender].amount + rewardCalc()}("");
        require(success);

   

        emit Withdrawn(msg.sender, stakers[msg.sender].amount);
        emit RewardClaimed(msg.sender, rewardCalc());
        
        }else {
               totalStaked -= stakers[msg.sender].amount;
            stakers[msg.sender].amount = 0;
            (bool success, ) = msg.sender.call{value: stakers[msg.sender].amount}("");
            require(success);
             emit Withdrawn(msg.sender, stakers[msg.sender].amount);
        }


}

   
    function claimRewards() external{
         if (stakers[msg.sender].stillStaked == false) {revert AlreadyClaimed();} 
          if (msg.sender == address(0)) {revert ZeroAddressDetected();}
       if (block.timestamp < stakers[msg.sender].period) {revert TimeNotExceeded();}

        stakers[msg.sender].stillStaked = false;
       stakers[msg.sender].amount += rewardCalc();

        
    }

    function emergencyWithdraw() external {
         if (msg.sender == address(0)) {revert ZeroAddressDetected();}
          if (stakers[msg.sender].stillStaked == false) {revert AlreadyClaimed();} 
             if (block.timestamp > stakers[msg.sender].period) {revert JustGoAndClaim();}

            totalStaked -= stakers[msg.sender].amount;
            stakers[msg.sender].amount = 0;
            (bool success, ) = msg.sender.call{value: stakers[msg.sender].amount}("");
            require(success);
             emit EmergencyWithdrawn(msg.sender, stakers[msg.sender].amount);
        
    }
    function viewTotalStaked() external view returns(uint256){
      return  totalStaked;
    }
    function viewUsersStake(address _user) external view returns(uint256){
        _onlyOwner();
        return stakers[_user].amount;
        
    }
    

    function _onlyOwner() private view{
        require(msg.sender == owner);
    }
}