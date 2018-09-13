//fireball assisted with control unit

module fireballv2(input Clk,                // 50 MHz clock
							 Reset,              // Active-high reset signal
							 frame_clk,          // The clock indicating a new frame (~60Hz)
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [9:0]   Char_X_Pos,		
					input [9:0]   Char_Y_Pos,				
					input         Char_direction,				//facing left: 0; facing: right: 1
               input         fire, reset, disappear,             		// input from control unit: instructions to fire
					output logic  is_fireball,             // Whether current pixel belongs to Mario or background
               output        Ready_to_fire,            //0: already fired, 1: avaliable to fire
					output [9:0]  fbx, fby
				 );
				 

	 parameter [9:0] fireball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] fireball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] fireball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] fireball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] fireball_X_step = 10'd4;      // Step size on the X axis
    parameter [9:0] fireball_size = 10'd4;
    
	 
	 logic [9:0] fireball_X_Pos, fireball_X_Motion, fireball_Y_Pos, fireball_Y_Motion;
    logic [9:0] fireball_X_Pos_in, fireball_X_Motion_in, fireball_Y_Pos_in, fireball_Y_Motion_in;
    logic Ready_to_fire_in;
    
	 assign fbx = fireball_X_Pos;
	 assign fby = fireball_Y_Pos;
	 
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            fireball_X_Pos <= Char_X_Pos;
            fireball_Y_Pos <= Char_Y_Pos;
            fireball_X_Motion <= 10'd0;
            fireball_Y_Motion <= 10'd0;
            Ready_to_fire <= 1'b1; // first press shoots all five overlapping. Afterwards they cascade (2-5 balls will flash to shooter's location)
        end
        else
        begin
            fireball_X_Pos <= fireball_X_Pos_in;
            fireball_Y_Pos <= fireball_Y_Pos_in;
            fireball_X_Motion <= fireball_X_Motion_in;
            fireball_Y_Motion <= 10'd0;
            Ready_to_fire <= Ready_to_fire_in;
        end
    end
	 
always_comb
begin
	  fireball_X_Pos_in = fireball_X_Pos;
     fireball_Y_Pos_in = fireball_Y_Pos;
     fireball_X_Motion_in = fireball_X_Motion;
     fireball_Y_Motion_in = 10'd0;
     Ready_to_fire_in = Ready_to_fire;

	 if (frame_clk_rising_edge)
    begin
        //default values
        fireball_X_Pos_in = fireball_X_Pos + fireball_X_Motion;
        fireball_Y_Pos_in = fireball_Y_Pos;
        fireball_X_Motion_in = fireball_X_Motion;
        fireball_Y_Motion_in = 10'd0;
		  Ready_to_fire_in = Ready_to_fire;
		 
				
		  //right boundary
        if((fireball_X_Pos + 10'd16) > 10'd639)
        begin
            fireball_X_Pos_in = Char_X_Pos;                            //reset position of fireball after disappears into boundary
            fireball_X_Motion_in = 10'd0;
				Ready_to_fire_in = 1'b1;
        end
        //left boundary
        else if(fireball_X_Pos < 10'd16)
        begin
            fireball_X_Pos_in = Char_X_Pos;                            //reset position of fireball after disappears into boundary
            fireball_X_Motion_in = 10'd0;
				Ready_to_fire_in = 1'b1;
        end
		  
		  if(fire) 			//pressed
        begin                      
				Ready_to_fire_in = 1'b0;
				if(Char_direction == 1'b1)
				begin
					 fireball_Y_Pos_in = Char_Y_Pos;
                fireball_X_Motion_in = 10'd8;
				end
			   else
				begin
					 fireball_Y_Pos_in = fireball_Y_Pos;
                fireball_X_Motion_in = (~10'd8) + 1'b1;
				end
        end 																							//if(fire)   
		  else if(Ready_to_fire)
		  begin
				fireball_X_Pos_in = Char_X_Pos;
				fireball_Y_Pos_in = Char_Y_Pos;
		  end
		  
		  if((reset && (fireball_X_Pos != Char_X_Pos)) || disappear)
		  begin
				fireball_X_Motion_in = 10'd0;
				fireball_X_Pos_in = Char_X_Pos;
				fireball_Y_Pos_in = Char_Y_Pos;
				Ready_to_fire_in = 1'b1;
		  end
	 end 																								//if(frame clk....)
	
 
end																									//always_comb

//is_fireball
int DistX, DistY, Size;
assign DistX = DrawX - fireball_X_Pos;
assign DistY = DrawY - fireball_Y_Pos;
assign Size = 10'd16;
always_comb
begin
    if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) && Ready_to_fire == 1'b0 && reset == 1'b0)
	 begin
        is_fireball = 1'b1;
	 end
    else
        is_fireball = 1'b0;
end

endmodule
	  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
	 