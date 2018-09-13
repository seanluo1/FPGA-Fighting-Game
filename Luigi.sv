//-------------------------------------------------------------------------
//    Luigi.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  Luigi ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY, MarioX, MarioY,       // Current pixel coordinates
					input [7:0]	  keycode,
					input         press, x_collision, y_collision, dead, dead_opponent,
               output logic  is_Luigi,             // Whether current pixel belongs to Luigi or background
					output logic  Direction, 
					output logic [3:0]  Behavior,
					output [9:0]  X_pos, Y_pos,
					output [1:0]  animation
              );
    
    parameter [9:0] Luigi_X_initial = 10'd520;  // Center position on the X axis
    parameter [9:0] Luigi_Y_initial = 10'd396;  // Center position on the Y axis
    parameter [9:0] Luigi_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Luigi_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Luigi_Y_Min = 10'd0;       // Topmost point on the Y axis
//    parameter [9:0] Luigi_Y_Max = 10'd400;     // Bottommost point on the Y axis
    parameter [9:0] Luigi_X_Step = 10'd4;      // Step size on the X axis
    parameter [9:0] Luigi_Y_Step = 10'd20;      // Step size on the Y axis
	 //parameter [9:0] Luigi_size   = 10'd4;
    parameter [9:0] Luigi_width = 10'd26;        // Luigi size
	 parameter [9:0] Luigi_height = 10'd28;
    
    logic [9:0] Luigi_X_Pos, Luigi_X_Motion, Luigi_Y_Pos, Luigi_Y_Motion;
    logic [9:0] Luigi_X_Pos_in, Luigi_X_Motion_in, Luigi_Y_Pos_in, Luigi_Y_Motion_in, Luigi_Y_Max, Luigi_Y_Max_in;
	 logic [3:0] Luigi_behavior_in;
	 logic Luigi_direction_in;
	 
//	 assign Direction = 1'b1;
//	 assign Behavior  = 4'b0000;
	 assign X_pos = Luigi_X_Pos;
	 assign Y_pos = Luigi_Y_Pos;
    
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
            Luigi_X_Pos <= Luigi_X_initial;
            Luigi_Y_Pos <= Luigi_Y_initial;
            Luigi_X_Motion <= 10'd0;
            Luigi_Y_Motion <= 10'd0;
				Direction <= 1'b0;
				Behavior  <= 4'b0000;
				Luigi_Y_Max <= 10'd479;
        end
        else
        begin
            Luigi_X_Pos <= Luigi_X_Pos_in;
            Luigi_Y_Pos <= Luigi_Y_Pos_in;
            Luigi_X_Motion <= Luigi_X_Motion_in;
            Luigi_Y_Motion <= Luigi_Y_Motion_in;
				Direction     <= Luigi_direction_in;
				Behavior      <= Luigi_behavior_in;
				Luigi_Y_Max   <= Luigi_Y_Max_in;
        end
    end
	 logic [9:0] newPos_x, newPox_y;
	 always_comb
	 begin
	 //default values
	 Luigi_X_Pos_in = Luigi_X_Pos;
	 Luigi_X_Motion_in = Luigi_X_Motion;
	 Luigi_Y_Pos_in = Luigi_Y_Pos;
	 Luigi_Y_Motion_in = Luigi_Y_Motion;
	 Luigi_direction_in = Direction;
	 Luigi_behavior_in = Behavior; 
	 Luigi_Y_Max_in    = Luigi_Y_Max;
		
	 
	 if (frame_clk_rising_edge)
	 begin
	 //default case
	 Luigi_X_Pos_in = Luigi_X_Pos + Luigi_X_Motion;
    Luigi_Y_Pos_in = Luigi_Y_Pos + Luigi_Y_Motion;	
	 Luigi_direction_in = Direction;
	 Luigi_behavior_in = Behavior;  
	 Luigi_Y_Max_in    = Luigi_Y_Max;

	
	 
	 if((Luigi_X_Pos + Luigi_width + Luigi_X_Motion) > Luigi_X_Max)
	 begin
		Luigi_X_Pos_in = Luigi_X_Max - Luigi_width;
	 end
	 if((Luigi_X_Pos + Luigi_X_Motion) < Luigi_X_Min + Luigi_width)
	 begin
		Luigi_X_Pos_in = Luigi_X_Min + Luigi_width;	
	 end
	 

	
	 // default gravity
	 if((Luigi_Y_Pos + Luigi_height + Luigi_Y_Motion) < Luigi_Y_Max)
	 begin
		Luigi_Y_Motion_in = Luigi_Y_Motion + 1'b1;
		Luigi_Y_Pos_in = Luigi_Y_Pos + Luigi_Y_Motion;
	 end
	 
	 else if((Luigi_Y_Pos_in) < Luigi_width)
	 begin
		Luigi_Y_Pos_in = Luigi_width;
		Luigi_Y_Motion_in = Luigi_Y_Motion + 1'b1;
	 end
	 
	 else
	 begin
		Luigi_Y_Motion_in = 0;
		Luigi_Y_Pos_in = (Luigi_Y_Max - Luigi_height);
	 end
	 
	 if(((Luigi_Y_Pos - Luigi_height + Luigi_Y_Motion) <= 10'd10))
	 begin
		Luigi_Y_Pos_in = Luigi_height + 10'd11;
		Luigi_Y_Motion_in = 10'd0;
	 end
	 
	 	case(press)
		//key pressed
		1'b1:
		begin
			case(keycode)
			//left(J)
			8'h69:
			begin
				if(Luigi_X_Pos  <= Luigi_X_Min + Luigi_width && !dead)
				begin	
						//maintian current direction
					Luigi_X_Motion_in = 1'b0;
					Luigi_X_Pos_in = Luigi_X_Min + Luigi_width;
					Luigi_behavior_in = 4'b0000;
				end
				else
				begin
					Luigi_X_Motion_in = ((~Luigi_X_Step)+1'b1);
					Luigi_behavior_in = 4'b0001;
					Luigi_direction_in = 1'b0;//running
				end
			end
			//right(L)
			8'h7A:
			begin
				if(Luigi_X_Pos + Luigi_width >= Luigi_X_Max && !dead)
				begin
					Luigi_X_Motion_in = 1'b0;	
					Luigi_X_Pos_in = Luigi_X_Max - Luigi_width;
					Luigi_behavior_in = 4'b0000;
				end
				else
				begin
					Luigi_X_Motion_in = Luigi_X_Step;	
					Luigi_behavior_in = 4'b0001;
					Luigi_direction_in = 1'b1;					//running
				end
			end
			//up(I)
			8'h73:
			begin
				//when Luigi is on the ground
				if ((Luigi_Y_Pos + Luigi_height) >= Luigi_Y_Max && !dead)
				 //give an upward (negative) initial velocity
				 Luigi_Y_Motion_in = (~Luigi_Y_Step) + 1'b1;  
			
				//when Luigi falls back down
			   else if ((Luigi_Y_Pos + Luigi_height) == Luigi_Y_Max)
				 //stop falling
				 Luigi_Y_Motion_in = 0;  
			   //if Luigi is below ground. force to ground
			   else if((Luigi_Y_Pos + Luigi_Y_Motion + Luigi_height) > Luigi_Y_Max)
				begin
				 Luigi_Y_Pos_in = (Luigi_Y_Max-Luigi_height);
				 Luigi_Y_Motion_in = 0;
				end
				else
				 // Update Luigi position normally
				 begin
					Luigi_Y_Pos_in = Luigi_Y_Motion + Luigi_Y_Pos; 
				end
			   if(((Luigi_Y_Pos - Luigi_height + Luigi_Y_Motion) <= 10'd10))
				 begin
					Luigi_Y_Pos_in = Luigi_height + 10'd11;
					Luigi_Y_Motion_in = 10'd0;
				 end
			end
			//down
			//shoot button
			8'h59:
			begin
				Luigi_X_Motion_in = Luigi_X_Motion;
				Luigi_behavior_in = 4'b0010;
			end
		endcase
		end
		//key released	
		1'b0 :
		begin
			case(keycode)
			//stop moving left
			8'h69:
			begin
				Luigi_X_Motion_in = 1'b0;
				Luigi_behavior_in = 4'b0000;
			end
			//stop moving right
			8'h7A:
			begin
				Luigi_X_Motion_in = 1'b0;
				Luigi_behavior_in = 4'b0000;
			end
			//up
			8'h73:
			begin
				if ((Luigi_Y_Pos + Luigi_height) == Luigi_Y_Max)
					 //stop falling
				begin
					 Luigi_Y_Motion_in = 0;  
				end
					//if Luigi is below ground. force to ground
				else if((Luigi_Y_Pos + Luigi_Y_Motion + Luigi_height) > Luigi_Y_Max)
				begin
					 Luigi_Y_Pos_in = (Luigi_Y_Max-Luigi_height);
					 Luigi_Y_Motion_in = 1'b0;
				end
				else
					 // Update Luigi position normally
				begin
					Luigi_Y_Pos_in =(Luigi_Y_Pos + Luigi_Y_Motion); 
				end
			   if(((Luigi_Y_Pos - Luigi_height + Luigi_Y_Motion) <= 10'd10))
				 begin
					Luigi_Y_Pos_in = Luigi_height + 10'd11;
					Luigi_Y_Motion_in = 10'd0;
				 end		
			end
			//down
			//stop shooting
			8'h59:
			begin
				Luigi_X_Motion_in = Luigi_X_Motion;
				Luigi_behavior_in = 4'b0000;
			end
		endcase
		end
	endcase
			if(dead)
			begin
				Luigi_behavior_in = 4'b0100;
				Luigi_X_Motion_in = 0;
				Luigi_X_Pos_in = Luigi_X_Pos;
			end
			
		if(dead_opponent)
		begin
			Luigi_behavior_in = 4'b0011;
			Luigi_X_Motion_in = 0;
			Luigi_X_Pos_in = Luigi_X_Pos;
		end
			
		//left ledge detection
		Luigi_Y_Max_in = 10'd479;

		if(((Luigi_Y_Pos + Luigi_height) <= 10'd279) && ((Luigi_X_Pos + Luigi_width) >= 10'd113) && ((Luigi_X_Pos - Luigi_width) <= 10'd247) && Luigi_Y_Motion_in >= 10'd0)
		begin
			//Luigi_Y_Pos_in = 10'd228 - Luigi_height;
			//Luigi_Y_Motion_in = 10'd0;
			Luigi_Y_Max_in = 10'd279;
		end
			
		//right ledge detection
		if(((Luigi_Y_Pos + Luigi_height) <= 10'd279) && ((Luigi_X_Pos + Luigi_width) >= 10'd394) && ((Luigi_X_Pos - Luigi_width) <= 10'd528) && Luigi_Y_Motion_in >= 10'd0)
		begin
			//Luigi_Y_Pos_in = 10'd228 - Luigi_height;
			//Luigi_Y_Motion_in = 10'd0;
			Luigi_Y_Max_in = 10'd279;
		end
			
			
		//pipe collision
		if(((Luigi_X_Pos_in + Luigi_width + Luigi_X_Motion) >= 10'd297) && ((Luigi_X_Pos_in - Luigi_width + Luigi_X_Motion) <= 10'd297) && ((Luigi_Y_Pos_in + Luigi_height + Luigi_Y_Motion) >= 10'd386))
		begin
			Luigi_X_Pos_in = 10'd297 - Luigi_width;
		end
		if(((Luigi_X_Pos_in - Luigi_width + Luigi_X_Motion) <= 10'd343) && ((Luigi_X_Pos_in + Luigi_width + Luigi_X_Motion) >= 10'd343) && ((Luigi_Y_Pos_in + Luigi_height + Luigi_Y_Motion) >= 10'd386))
		begin
			Luigi_X_Pos_in = 10'd343 + Luigi_width;
		end
		
		if(((Luigi_Y_Pos + Luigi_height) <= 10'd386) && ((Luigi_X_Pos + Luigi_width) >= 10'd297) && ((Luigi_X_Pos - Luigi_width) <= 10'd343) && Luigi_Y_Motion_in >= 10'd0)
		begin
//			Luigi_Y_Pos_in = 10'd303 - Luigi_height;
//			Luigi_Y_Motion_in = 10'd0;
			Luigi_Y_Max_in = 10'd386;
			Luigi_X_Pos_in = Luigi_X_Pos + Luigi_X_Motion;
		end
		
		//character-character collisions
		if(((Luigi_X_Pos_in + Luigi_width + Luigi_X_Motion) >= (MarioX - Luigi_width)) && ((Luigi_X_Pos_in - Luigi_width + Luigi_X_Motion) <= (MarioX - Luigi_width)) && 
			((Luigi_Y_Pos_in + Luigi_height + Luigi_Y_Motion) >= (MarioY - Luigi_height)) && ((Luigi_Y_Pos_in - Luigi_height + Luigi_Y_Motion) <= (MarioY + Luigi_height)))
		begin
			Luigi_X_Pos_in = (MarioX - Luigi_width) - Luigi_width;
		end
		if(((Luigi_X_Pos_in - Luigi_width + Luigi_X_Motion) <= (MarioX + Luigi_width)) && ((Luigi_X_Pos_in + Luigi_width + Luigi_X_Motion) >= (MarioX + Luigi_width)) && 
			((Luigi_Y_Pos_in + Luigi_height + Luigi_Y_Motion) >= (MarioY - Luigi_height)) && ((Luigi_Y_Pos_in - Luigi_height + Luigi_Y_Motion) <= (MarioY + Luigi_height)))
		begin
			Luigi_X_Pos_in = (MarioX + Luigi_width) + Luigi_width;
		end
		
//		if(((Luigi_Y_Pos + Luigi_height) <= (MarioY - Luigi_height)) && ((Luigi_X_Pos + Luigi_width) >= (MarioX - Luigi_width)) && 
//		((Luigi_X_Pos - Luigi_width) <= (MarioX + Luigi_width)) && Luigi_Y_Motion_in >= 10'd0 && ((Luigi_Y_Pos - Luigi_height) >= (10'd252)))
//		begin
//			Luigi_Y_Max_in = MarioY - Luigi_height;
//			Luigi_X_Pos_in = Luigi_X_Pos + Luigi_X_Motion;
//		end
		
	end													//frame clk
end


	always_comb begin
	  if ( (DrawX >= (Luigi_X_Pos-Luigi_width)) && (DrawX <= (Luigi_X_Pos+Luigi_width)) &&
				(DrawY >= (Luigi_Y_Pos-Luigi_height)) && (DrawY <= (Luigi_Y_Pos+Luigi_height)) ) 
			is_Luigi = 1'b1;
	  else
			is_Luigi = 1'b0;
	  /* The Luigi's (pixelated) circle is generated using the standard circle formula.  Note that while 
		  the single line is quite powerful descriptively, it causes the synthesis tool to use up three
		  of the 12 available multipliers on the chip! */
	end
   
logic [7:0] counter_val;
//animation  counter
counter cL(.Clk(frame_clk), .Reset, .count(counter_val));

always_comb
begin
animation = 2'b00;
if(counter_val % 8'd9 < 8'd3)
	animation = 2'b00;
else if(counter_val % 8'd9 < 8'd6)
	animation = 2'b01;
else if(counter_val % 8'd9 < 8'd9)
	animation = 2'b10;
end
    // Compute whether the pixel corresponds to Luigi or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
//    int DistX, DistY, Size;
//    assign DistX = DrawX - Luigi_X_Pos;
//    assign DistY = DrawY - Luigi_Y_Pos;
//    assign Size = Luigi_size;
//    always_comb begin
//        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
//            is_Luigi = 1'b1;
//        else
//            is_Luigi = 1'b0;
//        /* The Luigi's (pixelated) circle is generated using the standard circle formula.  Note that while 
//           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
//           of the 12 available multipliers on the chip! */
//    end
    
endmodule
