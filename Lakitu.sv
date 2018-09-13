//Lakitu 52x70
//animation1: 173,177
//animation2: 257,177
module Lakitu(input Clk, Reset, frame_clk, game_over,
					input [9:0] DrawX, DrawY,
					output [9:0] lakituX, lakituY, lakitu_motion,
					output is_lakitu, direction, animation);
					
					
parameter [9:0] lakituX_initial = 10'd600;
parameter [9:0] lakituY_initial = 10'd100;
parameter [9:0] lakituX_max     = 10'd639;
parameter [9:0] lakitu_width    = 10'd26;
parameter [9:0] lakitu_height   = 10'd35; 


logic [9:0] lakituX_in, lakituY_in, lakituY_Motion, lakituX_Motion, lakituY_Motion_in, lakituX_Motion_in;
logic direction_in;

assign lakitu_motion = lakituX_Motion;

always_ff @ (posedge Clk)
begin
	if(Reset)
	begin
		lakituX <= lakituX_initial;
		lakituY <= lakituY_initial;
		lakituX_Motion <= (~10'd1) + 1'b1;
		direction <= 1'b0;
	end
	
	else
	begin
		lakituX <= lakituX_in;
		lakituY <= lakituY_initial;
		lakituX_Motion <= lakituX_Motion_in;
		direction       <= direction_in;
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
	lakituX_Motion_in = lakituX_Motion;
	lakituY_in = lakituY;
	lakituX_in = lakituX;
	direction_in = direction;
	
	if(frame_clk_rising_edge)
	begin
		//default values
		lakituX_Motion_in = lakituX_Motion;
		lakituX_in = lakituX + lakituX_Motion;
		lakituY_in = lakituY;
		direction_in = direction;

    if((lakituX + lakitu_width + lakituX_Motion) > lakituX_max)
	 begin
		lakituX_in = lakituX_max - lakitu_width;
		lakituX_Motion_in = (~10'd1) + 1'b1;
		direction_in      = 1'b0;
	 end
	 if((lakituX + lakituX_Motion) < lakitu_width)
	 begin
		lakituX_in = lakitu_width;	
		lakituX_Motion_in = 10'd1;
		direction_in      = 1'b1;
	 end

	if(game_over)
	begin
		lakituX_in = lakituX;
		lakituY_in = lakituY;
		lakituX_Motion_in = 10'd0;
	end
	
	end											//if(frame)
 end											//always_comb


//is_lakitu
always_comb begin
  if ( (DrawX >= (lakituX-10'd26)) && (DrawX <= (lakituX+10'd26)) &&
			(DrawY >= (lakituY-10'd35)) && (DrawY <= (lakituY+10'd35)) ) 
		is_lakitu = 1'b1;
  else
		is_lakitu = 1'b0;
  /* The lakitu's (pixelated) circle is generated using the standard circle formula.  Note that while 
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
