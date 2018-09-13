//spikey the enemy

module spikey(input Clk, Reset, frame_clk, reset_spikey, lakitu_direction,
						input [9:0] DrawX, DrawY, lakituX, lakituY, lakitu_motion,
						output [9:0] spikeyX, spikeyY,
						output is_spikey, dropped,
						output direction,
						output animation);
						
						
parameter [9:0] spikey_width = 10'd13;
parameter [9:0] spikey_height = 10'd13;

logic [9:0] spikey_X_initial;
logic [9:0] spikey_Y_initial;

assign spikey_X_initial = lakituX + 10'd26;
assign spikey_Y_initial = lakituY + 10'd35;

logic [9:0] spikey_X_in, spikey_Y_in, spikey_Y_Motion, spikey_X_Motion, spikey_Y_Motion_in, spikey_X_Motion_in, spikey_Y_Max_in, spikey_Y_Max;
logic direction_in, dropped_in;


always_ff @ (posedge Clk)
begin
	if(Reset)
	begin
		spikeyX <= spikey_X_initial;
		spikeyY <= spikey_Y_initial;
		spikey_Y_Max <= 10'd386;
		spikey_Y_Motion <= 10'd0;
		spikey_X_Motion <= lakitu_motion;
		direction <= lakitu_direction;
		dropped   <= 1'b0;
	end
	
	else
	begin
		spikeyX <= spikey_X_in;
		spikeyY <= spikey_Y_in;
		spikey_Y_Max <= spikey_Y_Max_in;
		spikey_Y_Motion <= spikey_Y_Motion_in;
		spikey_X_Motion <= spikey_X_Motion_in;
		direction       <= direction_in;
		dropped      <= dropped_in;
	end
end

 //////// Do not modify the always_ff blocks. ////////
 // Detect rising edge of frame_clk
 logic frame_clk_delayed, frame_clk_rising_edge;
 always_ff @ (posedge Clk) begin
	  frame_clk_delayed <= frame_clk;
	  frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
 end
 
 
always_comb
begin
	//default values
	spikey_X_Motion_in = spikey_X_Motion;
	spikey_Y_Motion_in = spikey_Y_Motion;
	spikey_Y_Max_in = spikey_Y_Max;
	spikey_X_in = spikeyX;
	spikey_Y_in = spikeyY;
	direction_in = direction;
	dropped_in   = dropped;
	
	if(frame_clk_rising_edge)
	begin
		//default values
		spikey_X_Motion_in = spikey_X_Motion;
		spikey_Y_Motion_in = spikey_Y_Motion;
		spikey_Y_Max_in = spikey_Y_Max;
		spikey_X_in = (lakitu_direction) ? spikey_X_initial : (lakituX - 10'd26);
		spikey_Y_in = spikey_Y_initial;
		direction_in = lakitu_direction;
		dropped_in   = dropped;
		
		//describe motion below
		// default gravity
	 if(((spikeyY + spikey_height + spikey_Y_Motion) < spikey_Y_Max) && dropped)
	 begin
		spikey_Y_Motion_in = spikey_Y_Motion + 1'b1;
		spikey_Y_in = spikeyY + spikey_Y_Motion;
	 end
	 
	 else if((spikey_Y_in) < spikey_height)
	 begin
		spikey_Y_in = spikey_height;
		spikey_Y_Motion_in = spikey_Y_Motion + 1'b1;
	 end

	 else
	 begin
		spikey_Y_Motion_in = 0;
		spikey_Y_in = (spikey_Y_Max - spikey_height);
	 end
	 
	 // boundary left
	 if (spikeyX - spikey_width <= 0)
	 begin
		direction_in = lakitu_direction;
		spikey_Y_in = spikey_Y_initial;
		spikey_X_in = (lakitu_direction) ? spikey_X_initial : (lakituX - 10'd26);
		spikey_X_Motion_in = lakitu_motion;
		dropped_in  = 1'b0;
	 end
	 // boundary right
	 if (spikeyX + spikey_width >= 10'd639)
	 begin
		direction_in = lakitu_direction;
		spikey_Y_in = spikey_Y_initial;
		spikey_X_in = (lakitu_direction) ? spikey_X_initial : (lakituX -  10'd26);
		spikey_X_Motion_in = lakitu_motion;
		dropped_in = 1'b0;
	 end
	 
	 if(dropped)
	 begin
		spikey_X_in = spikeyX + spikey_X_Motion;
		direction_in = direction;
	 end
	 else
	 begin
		spikey_X_in = (lakitu_direction) ? spikey_X_initial : (lakituX - 10'd26);
		spikey_Y_in = spikey_Y_initial;
	 end	 
	 // walk right
	 if (lakitu_direction == 1'b1 && spikey_X_initial == 10'd320 && !dropped)
	 begin
		spikey_X_Motion_in = 10'd1;
		spikey_X_in = spikeyX + 10'd1;
		dropped_in = 1'b1;
	 end
	 
	 // walk left
	 if (lakitu_direction == 1'b0 && spikey_X_initial == 10'd320 && !dropped)
	 begin
		spikey_X_Motion_in = (~10'd1) + 1'b1;
	   spikey_X_in = spikeyX - 10'd1;
		dropped_in = 1'b1;
	 end
	 
	 spikey_Y_Max_in = 10'd479;
	 //pipe collision
	 if(((spikey_X_in + spikey_width + spikey_X_Motion) >= 10'd297) && ((spikey_X_in - spikey_width + spikey_X_Motion) <= 10'd297) && ((spikey_Y_in + spikey_height + spikey_Y_Motion) >= 10'd386))
	 begin
			spikey_X_in = 10'd297 - spikey_width;
	 end
	 if(((spikey_X_in - spikey_width + spikey_X_Motion) <= 10'd343) && ((spikey_X_in + spikey_width + spikey_X_Motion) >= 10'd343) && ((spikey_Y_in + spikey_height + spikey_Y_Motion) >= 10'd386))
	 begin
	 	spikey_X_in = 10'd343 + spikey_width;
	 end
		
	 if(((spikeyY + spikey_height) <= 10'd386) && ((spikeyX + spikey_width) >= 10'd297) && ((spikeyX - spikey_width) <= 10'd343) && spikey_Y_Motion_in >= 10'd0)
	 begin
	 	spikey_Y_Max_in = 10'd386;
	 	spikey_X_in = spikeyX + spikey_X_Motion;
	 end
		
	if(reset_spikey)
	begin
		spikey_X_in = (lakitu_direction) ? spikey_X_initial : (lakituX - 10'd26);
		spikey_Y_in = spikey_Y_initial;
		direction_in = lakitu_direction;
		dropped_in = 1'b0;
		
//		spikey_X_in = spikey_X_initial;
//		spikey_Y_Max_in = 10'd303;
//		spikey_Y_Motion_in = 10'd0;
//		direction_in = ~direction;
//	   spikey_X_Motion_in = (direction_in) ? (10'd1) : ((~10'd1) + 1'b1);
	end
		
	end													//if(frame_clk)
end													//always_comb

//is_spikey
always_comb begin
  if ( (DrawX >= (spikeyX-spikey_width)) && (DrawX <= (spikeyX+spikey_width)) &&
			(DrawY >= (spikeyY-spikey_height)) && (DrawY <= (spikeyY+spikey_height)) ) 
		is_spikey = 1'b1;
  else
		is_spikey = 1'b0;
  /* The spikey's (pixelated) circle is generated using the standard circle formula.  Note that while 
	  the single line is quite powerful descriptively, it causes the synthesis tool to use up three
	  of the 12 available multipliers on the chip! */
end


//animation counter
logic [7:0] counter_val;
counter cM(.Clk(frame_clk), .Reset, .count(counter_val));

always_comb
begin
animation = 1'b0;
if(counter_val % 8'd20 <= 8'd10)
	animation = 1'b0;

else 
	animation = 1'b1;
end

endmodule
