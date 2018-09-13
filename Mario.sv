//-------------------------------------------------------------------------
//    Mario.sv                                                            --
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


module  Mario ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY, LuigiX, LuigiY,       // Current pixel coordinates
					input [7:0]	  keycode,
					input         press, x_collision, y_collision, dead, dead_opponent,
               output logic  is_Mario,             // Whether current pixel belongs to Mario or background
					output logic  Direction, 
					output logic [3:0]  Behavior,
					output [9:0]  X_pos, Y_pos,
					output [1:0]  animation,
					output frame_clk_edge
              );
    
    parameter [9:0] Mario_X_initial = 10'd120;  // Center position on the X axis
    parameter [9:0] Mario_Y_initial = 10'd451;  // Center position on the Y axis
    parameter [9:0] Mario_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Mario_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Mario_Y_Min = 10'd0;       // Topmost point on the Y axis
  //  parameter [9:0] Mario_Y_Max = 10'd400;     // Bottommost point on the Y axis
    parameter [9:0] Mario_X_Step = 10'd4;      // Step size on the X axis
    parameter [9:0] Mario_Y_Step = 10'd20;      // Step size on the Y axis
    parameter [9:0] Mario_width = 10'd26;        // Mario size
	 parameter [9:0] Mario_height = 10'd28;
    
	assign frame_clk_edge = frame_clk_rising_edge;
	
    logic [9:0] Mario_X_Pos, Mario_X_Motion, Mario_Y_Pos, Mario_Y_Motion;
    logic [9:0] Mario_X_Pos_in, Mario_X_Motion_in, Mario_Y_Pos_in, Mario_Y_Motion_in, Mario_Y_Max, Mario_Y_Max_in;
	 logic [3:0] Mario_behavior_in;
	 logic Mario_direction_in, on_ledge, on_ledge_in;
	 
//	 assign Direction = 1'b1;
//	 assign Behavior  = 4'b0000;
	 assign X_pos = Mario_X_Pos;
	 assign Y_pos = Mario_Y_Pos;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 assign frame_clk_edge = frame_clk_rising_edge;

	 // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Mario_X_Pos <= Mario_X_initial;
            Mario_Y_Pos <= Mario_Y_initial;
            Mario_X_Motion <= 10'd0;
            Mario_Y_Motion <= 10'd0;
				Direction <= 1'b1;
				Behavior  <= 4'b0000; 
				Mario_Y_Max <= 10'd479;
        end
        else
        begin
            Mario_X_Pos <= Mario_X_Pos_in;
            Mario_Y_Pos <= Mario_Y_Pos_in;
            Mario_X_Motion <= Mario_X_Motion_in;
            Mario_Y_Motion <= Mario_Y_Motion_in;
				Direction     <= Mario_direction_in;
				Behavior      <= Mario_behavior_in;
				Mario_Y_Max   <= Mario_Y_Max_in;
        end
    end
	 logic [9:0] newPos_x, newPox_y;
	 always_comb
	 begin
	 //default values
	 Mario_X_Pos_in = Mario_X_Pos;
	 Mario_X_Motion_in = Mario_X_Motion;
	 Mario_Y_Pos_in = Mario_Y_Pos;
	 Mario_Y_Motion_in = Mario_Y_Motion;
	 Mario_direction_in = Direction;
	 Mario_behavior_in = Behavior; 
	 on_ledge_in = on_ledge;
	 Mario_Y_Max_in = Mario_Y_Max;
	 
	 if (frame_clk_rising_edge)
	 begin
	 //default case
	 Mario_X_Pos_in = Mario_X_Pos + Mario_X_Motion;
    Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;	
	 Mario_direction_in = Direction;
	 Mario_behavior_in = Behavior; 
	 on_ledge_in = on_ledge;
	 
	  //collision detection with characters
//	 if(x_collision)
//	 begin
//		Mario_X_Motion_in = 10'd0;
//		Mario_X_Pos_in = (Direction ? (Mario_X_Pos + (~10'd20 + 1'b1)) : (Mario_X_Pos + 10'd20));
//		if(Mario_X_Motion == 1'b0 && Mario_Y_Motion == 1'b0)
//			Mario_X_Pos_in = Mario_X_Pos;
//		Mario_Y_Pos_in = Mario_Y_Pos - 10'd10;	
//			
//	 if((Mario_X_Pos_in + Mario_width + Mario_X_Motion) > Mario_X_Max)
//	 begin
//		Mario_X_Pos_in = Mario_X_Max - Mario_width;
//	 end
//	 if((Mario_X_Pos_in + Mario_X_Motion) < Mario_X_Min + Mario_width)
//	 begin
//		Mario_X_Pos_in = Mario_X_Min + Mario_width;	
//	 end
//	 end
	 
	 if((Mario_X_Pos + Mario_width + Mario_X_Motion) > Mario_X_Max)
	 begin
		Mario_X_Pos_in = Mario_X_Max - Mario_width;
	 end
	 if((Mario_X_Pos + Mario_X_Motion) < Mario_X_Min + Mario_width)
	 begin
		Mario_X_Pos_in = Mario_X_Min + Mario_width;	
		
	 end
 

	 
// default gravity
	 if(((Mario_Y_Pos + Mario_height + Mario_Y_Motion) < Mario_Y_Max))
	 begin
		Mario_Y_Motion_in = Mario_Y_Motion + 1'b1;
		Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;
	 end
	 
	 else if((Mario_Y_Pos_in) < Mario_width) //lol bug?
	 begin
		Mario_Y_Pos_in = Mario_width;
		Mario_Y_Motion_in = Mario_Y_Motion + 1'b1;
	 end

	 else
	 begin
		Mario_Y_Motion_in = 0;
		Mario_Y_Pos_in = (Mario_Y_Max - Mario_height);
		
	 end
	 
	 if(((Mario_Y_Pos - Mario_height + Mario_Y_Motion) <= 10'd10))
	 begin
		Mario_Y_Pos_in = Mario_height + 10'd11;
		Mario_Y_Motion_in = 10'd0;
	 end
	 
	 	case(press)
		//key pressed
		1'b1:
		begin
			case(keycode)
			//left
			8'h1C:
			begin
				if(Mario_X_Pos  <= Mario_X_Min + Mario_width && !dead)
				begin	
						//maintian current direction
					Mario_X_Motion_in = 1'b0;
					Mario_X_Pos_in = Mario_X_Min + Mario_width;
					Mario_behavior_in = 4'b0000;
				end
				else
				begin
					Mario_X_Motion_in = ((~Mario_X_Step)+1'b1);
					Mario_behavior_in = 4'b0001;						//running
					Mario_direction_in = 1'b0;
				end
			end
			//right
			8'h23:
			begin
				if(Mario_X_Pos + Mario_width >= Mario_X_Max && !dead)
				begin
					Mario_X_Motion_in = 1'b0;	
					Mario_X_Pos_in = Mario_X_Max - Mario_width;
					Mario_behavior_in = 4'b0000;
				end
				else
				begin
					Mario_X_Motion_in = Mario_X_Step;		
					Mario_behavior_in = 4'b0001;
					Mario_direction_in = 1'b1;				//running
				end
			end
			//up
			8'h1D:
			begin
				//when Mario is on the ground
				if (((Mario_Y_Pos + Mario_height) >= Mario_Y_Max) && !dead)
				 //give an upward (negative) initial velocity
				 Mario_Y_Motion_in = (~Mario_Y_Step) + 1'b1;  
			
				//when Mario falls back down
			   else if ((Mario_Y_Pos + Mario_height) == Mario_Y_Max)
				 //stop falling
				 Mario_Y_Motion_in = 0;  
			   //if Mario is below ground. force to ground
			   else if((Mario_Y_Pos + Mario_Y_Motion + Mario_height) > Mario_Y_Max)
				begin
				 Mario_Y_Pos_in = (Mario_Y_Max-Mario_height);
				 Mario_Y_Motion_in = 0;
				end
				else
				 // Update Mario position normally
				 begin
					Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion; 
				end
				//ceiling
				 if(((Mario_Y_Pos_in - Mario_height) <= 10'd10))
				 begin
					Mario_Y_Pos_in = Mario_height + 10'd11;
					Mario_Y_Motion_in = 10'd0;
				 end
			end
			//down
			//shoot button
			8'h29:
			begin
				Mario_X_Motion_in = Mario_X_Motion;
				Mario_behavior_in = 4'b0010;
			end
		endcase
		end
		//key released	
		1'b0 :
		begin
			case(keycode)
			//stop moving left
			8'h1C:
			begin
				Mario_X_Motion_in = 1'b0;
				Mario_behavior_in = 4'b0000;
			end
			//stop moving right
			8'h23:
			begin
				Mario_X_Motion_in = 1'b0;	
				Mario_behavior_in = 4'b0000;
			end
			//up
			8'h1D:
			begin
				if ((Mario_Y_Pos + Mario_height) == Mario_Y_Max)
					 //stop falling
				begin
					 Mario_Y_Motion_in = 0;  
				end
					//if Mario is below ground. force to ground
				else if((Mario_Y_Pos + Mario_Y_Motion + Mario_height) > Mario_Y_Max)
				begin
					 Mario_Y_Pos_in = (Mario_Y_Max-Mario_height);
					 Mario_Y_Motion_in = 1'b0;
				end
				else
					 // Update Mario position normally
				begin
					Mario_Y_Pos_in =(Mario_Y_Pos + Mario_Y_Motion); 
				end		
				//ceiling detection
				 if(((Mario_Y_Pos_in - Mario_height) <= 10'd10))
				 begin
					Mario_Y_Pos_in = Mario_height + 10'd11;
					Mario_Y_Motion_in = 10'd0;
				 end
			end
			//down
			//stop shooting
			8'h29:
			begin
				Mario_X_Motion_in = Mario_X_Motion;
				Mario_behavior_in = 4'b0000;
			end
		endcase
		end
	endcase
		if(dead)
		begin
			Mario_behavior_in = 4'b0100;
			Mario_X_Motion_in = 0;
			Mario_X_Pos_in = Mario_X_Pos;
		end
		
		if(dead_opponent)
		begin
			Mario_behavior_in = 4'b0011;
			Mario_X_Motion_in = 0;
			Mario_X_Pos_in = Mario_X_Pos;
		end
		//left ledge detection
		Mario_Y_Max_in = 10'd479;

		if(((Mario_Y_Pos + Mario_height) <= 10'd279) && ((Mario_X_Pos + Mario_width) >= 10'd113) && ((Mario_X_Pos - Mario_width) <= 10'd247) && Mario_Y_Motion_in >= 10'd0)
		begin
			//Mario_Y_Pos_in = 10'd228 - Mario_height;
			//Mario_Y_Motion_in = 10'd0;
			Mario_Y_Max_in = 10'd279;
		end
			
		//right ledge detection
		if(((Mario_Y_Pos + Mario_height) <= 10'd279) && ((Mario_X_Pos + Mario_width) >= 10'd394) && ((Mario_X_Pos - Mario_width) <= 10'd528) && Mario_Y_Motion_in >= 10'd0)
		begin
			//Mario_Y_Pos_in = 10'd228 - Mario_height;
			//Mario_Y_Motion_in = 10'd0;
			Mario_Y_Max_in = 10'd279;
		end
			
			
		//pipe collision
		if(((Mario_X_Pos_in + Mario_width + Mario_X_Motion) >= 10'd297) && ((Mario_X_Pos_in - Mario_width + Mario_X_Motion) <= 10'd297) && ((Mario_Y_Pos_in + Mario_height + Mario_Y_Motion) >= 10'd386))
		begin
			Mario_X_Pos_in = 10'd297 - Mario_width;
		end
		if(((Mario_X_Pos_in - Mario_width + Mario_X_Motion) <= 10'd343) && ((Mario_X_Pos_in + Mario_width + Mario_X_Motion) >= 10'd343) && ((Mario_Y_Pos_in + Mario_height + Mario_Y_Motion) >= 10'd386))
		begin
			Mario_X_Pos_in = 10'd343 + Mario_width;
		end
		
		if(((Mario_Y_Pos + Mario_height) <= 10'd386) && ((Mario_X_Pos + Mario_width) >= 10'd297) && ((Mario_X_Pos - Mario_width) <= 10'd343) && Mario_Y_Motion_in >= 10'd0)
		begin
			Mario_Y_Max_in = 10'd386;
			Mario_X_Pos_in = Mario_X_Pos + Mario_X_Motion;
		end
			
		//character-character collisions
		if(((Mario_X_Pos_in + Mario_width + Mario_X_Motion) >= (LuigiX - Mario_width)) && ((Mario_X_Pos_in - Mario_width + Mario_X_Motion) <= (LuigiX - Mario_width)) && 
			((Mario_Y_Pos_in + Mario_height + Mario_Y_Motion) >= (LuigiY - Mario_height)) && ((Mario_Y_Pos_in - Mario_height + Mario_Y_Motion) <= (LuigiY + Mario_height)))
		begin
			Mario_X_Pos_in = (LuigiX - Mario_width) - Mario_width;
		end
		if(((Mario_X_Pos_in - Mario_width + Mario_X_Motion) <= (LuigiX + Mario_width)) && ((Mario_X_Pos_in + Mario_width + Mario_X_Motion) >= (LuigiX + Mario_width)) && 
			((Mario_Y_Pos_in + Mario_height + Mario_Y_Motion) >= (LuigiY - Mario_height)) && ((Mario_Y_Pos_in - Mario_height + Mario_Y_Motion) <= (LuigiY + Mario_height)))
		begin
			Mario_X_Pos_in = (LuigiX + Mario_width) + Mario_width;
		end
		
//		if(((Mario_Y_Pos + Mario_height) <= (LuigiY - Mario_height)) && ((Mario_X_Pos + Mario_width) >= (LuigiX - Mario_width)) && 
//		((Mario_X_Pos - Mario_width) <= (LuigiX + Mario_width)) && Mario_Y_Motion_in >= 10'd0 && ((Mario_Y_Pos - Mario_height) >= (10'd252)))
//		begin
//			Mario_Y_Max_in = LuigiY - Mario_height;
//			Mario_X_Pos_in = Mario_X_Pos + Mario_X_Motion;
//		end
			
			
			
	end							//frame clk
end								//always_comb


	always_comb begin
	  if ( (DrawX >= (Mario_X_Pos-Mario_width)) && (DrawX <= (Mario_X_Pos+Mario_width)) &&
				(DrawY >= (Mario_Y_Pos-Mario_height)) && (DrawY <= (Mario_Y_Pos+Mario_height)) ) 
			is_Mario = 1'b1;
	  else
			is_Mario = 1'b0;
	  /* The Mario's (pixelated) circle is generated using the standard circle formula.  Note that while 
		  the single line is quite powerful descriptively, it causes the synthesis tool to use up three
		  of the 12 available multipliers on the chip! */
	end
logic [7:0] counter_val;
//animation  counter
counter cM(.Clk(frame_clk), .Reset, .count(counter_val));

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

    // Compute whether the pixel corresponds to Mario or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
//    int DistX, DistY, Size;
//    assign DistX = DrawX - Mario_X_Pos;
//    assign DistY = DrawY - Mario_Y_Pos;
//    assign Size = Mario_size;
//    always_comb begin
//        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
//            is_Mario = 1'b1;
//        else
//            is_Mario = 1'b0;
//        /* The Mario's (pixelated) circle is generated using the standard circle formula.  Note that while 
//           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
//           of the 12 available multipliers on the chip! */
//    end
    
endmodule
