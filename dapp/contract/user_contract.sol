contract user_bicycle_info {

    #Eagle Chain
    address owner_addr;    
    uint public  rent_flag;
    uint public  rent_value;
    uint public  sell_flag;  
    uint public  sell_value;
    uint public origin_distance;  
    uint public update_distance;
    uint public out_of_bound;
    uint public reward_value;
	
   function Bicycle_info() { 
   owner_addr = msg.sender;
   rent_value = 2;
   rent_flag = 0;
   sell_flag = 0;
   sell_value = 300;
   origin_distance = 0;
   update_distance = 0;
   out_of_bound = 0;
   reward_value = 1;
   
  }
}