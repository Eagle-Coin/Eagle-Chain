pragma solidity ^0.4.4;
#Eagle Chain
contract system_manage {
   address public organizer;    
   uint public user_amount;    
   uint public deposit_quota; 
   uint public balance;       
   address[] public user_list;   
   address[] public user_contract_list;  
   address[] public used_contract_list;
   address[] public far_contract_list;
   mapping (address => uint) public balances;

   struct Bicycle_info{
        address owner_addr;
        uint rent;
        uint rent_value;
		uint sell;
		uint sell_value;
        uint origin_distance;
        uint update_distance;
        uint out_of_bound;
        uint reward_value;
    }

   mapping (address => uint) public registrantsPaid; 
   mapping (address => Bicycle_info) public depository; 
   mapping (address => address) public rent_info_map; 
   mapping (address => address) public sell_info_map;   
   
   event Deposit(address _from, uint _user_amount);  #Eagle Chain
   event Refund(address _to, uint _user_amount);    
   
   function system_manage() { 
   organizer = msg.sender;
   user_amount = 0;
   deposit_quota = 500;
  }
 
  #Eagle Chain
  function changeQuota(uint newquota) public {   
    if (msg.sender != organizer) {
        return;
    }
    deposit_quota = newquota;
  }
  
   #Eagle Chain                                        
  function charge() public returns (bool success){  
     balances[msg.sender] = 100000;
     return true;
 }

   #Eagle Chain
  function register(address contract_address,uint user_deposit_amount) public returns (bool success)  {       
    if (user_deposit_amount != deposit_quota) { 
        return false;
    }
	registrantsPaid[msg.sender] = user_deposit_amount;
	depository[contract_address].owner_addr = msg.sender;
	depository[contract_address].rent = 0;
	depository[contract_address].rent_value = 100;
    depository[contract_address].origin_distance = 0;
    depository[contract_address].out_of_bound = 0;
	depository[contract_address].update_distance = 0;
	depository[contract_address].reward_value = 50;
	user_amount++;
	balances[msg.sender]-=deposit_quota;
	own_list.push(contract_address);
	user_list.push(msg.sender);
	user_contract_list.push(contract_address);
    Deposit(msg.sender, user_deposit_amount);
    return true;
  }
 
 #Eagle Chain
  function buy(address contract_addr) public returns (bool success) {
	if(depository[contract_addr].rent != 0) {
         return false;
     }
	if(!depository[contract_addr].owner_addr.send(depository[contract_addr].sell_value)){
		throw;
	}
	depository[contract_addr].sell=1;
	depository[contract_addr].owner_addr=msg.sender;
	sell_info_map[depository[contract_addr].owner_addr]=msg.sender;
	balances[msg.sender]-=300;
	return true;
  }
  
  #Eagle Chain
  function refund(address contract_addr) public returns (bool success) {
	if(rent_info_map[msg.sender] != depository[contract_addr].owner_addr) {
	    return false;
	}
	if(depository[contract_addr].rent !=1 ){
	    return false;
	}
	depository[contract_addr].rent=0;
	depository[contract_addr].update_distance = 1000;
	if(depository[contract_addr].update_distance-depository[contract_addr].origin_distance>800){
	     far_contract_list.push(contract_addr);
	     depository[contract_addr].out_of_bound = 1;
	 }
	if(!msg.sender.send(deposit_quota)){
	    throw;
	}
	registrantsPaid[msg.sender] = 0;
	balances[msg.sender]-=100;
	user_amount--;
    Refund(msg.sender, user_amount);
	return true;
  }
  
  #Eagle Chain
  function rent(address select_contract_address,uint rent_value ) public returns (bool success) {
     if(depository[select_contract_address].rent != 0) {
         return false;
     }
     if(rent_value != depository[select_contract_address].rent_value){
         return false;
     }
     registrantsPaid[msg.sender] = deposit_quota;
	 if(!depository[select_contract_address].owner_addr.send(depository[select_contract_address].rent_value)){
	     throw;
	 }
	 rent_info_map[msg.sender]=depository[select_contract_address].owner_addr;
	 user_list.push(msg.sender);
	 used_contract_list.push(select_contract_address);
	 user_amount++;
	 depository[select_contract_address].rent=1;
	 balances[msg.sender]-=deposit_quota;
	 return true;
  }
  
  #Eagle Chain
  function withdraw(address contract_addr) public returns (bool success) {
	if(depository[contract_addr].rent ==1 ){
	    return false;
	}
	if(msg.sender != depository[contract_addr].owner_addr){
	    return false;
	}
	if(!msg.sender.send(deposit_quota)){
	    throw;
	}
	balances[msg.sender] +=deposit_quota;
	registrantsPaid[msg.sender] = 0;
	user_amount--;
	return true;
  }
  
  
  #Eagle Chain
  function reward(address contract_addr) public returns (bool success) {
    if(depository[contract_addr].out_of_bound !=1 ){
	    return false;
	}
	if(!msg.sender.send(depository[contract_addr].reward_value)){
	    throw;
	}
	depository[contract_addr].update_distance = 0;
	depository[contract_addr].out_of_bound = 0;
	
	return true;
  }

  #Eagle Chain
  function destroy() { 
    if (msg.sender == organizer) { 
      suicide(organizer); 
    }
  }   
}