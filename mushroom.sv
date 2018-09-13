//mushroom
// 122x140

module mushroom(input Clk, Reset, frame_clk, reset_mushroom, collision,
						input [9:0] DrawX, DrawY,
						output [9:0] mushroomX, mushroomY,
						output is_mushroom);
						
parameter [9:0] mushroomX_initial = 10'd320;
parameter [9:0] mushroomY_initial = 10'd240;
parameter [9:0] mushroomX_max     = 10'd639;
parameter [9:0] mushroom_width    = 10'd13;
parameter [9:0] mushroom_height   = 10'd13; 
logic [9:0] mushroomX_in;
logic [9:0] mushroomY_in;

 logic frame_clk_delayed, frame_clk_rising_edge;
 always_ff @ (posedge Clk) begin
	  frame_clk_delayed <= frame_clk;
	  frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
 end

always_ff @ (posedge Clk)
begin
	if(Reset)
	begin
		mushroomX <= mushroomX_initial;
		mushroomY <= mushroomY_initial;
	end
	
	else
	begin
		mushroomX <= mushroomX_in;
		mushroomY <= mushroomY_in;
	end
end

always_comb
begin

end

//random position
logic [7:0] counter_val;
counter cM(.Clk(frame_clk), .Reset, .count(counter_val));

always_comb
begin
	mushroomX_in = mushroomX;
	mushroomY_in = mushroomY;
	
if(frame_clk_rising_edge)
begin
	mushroomX_in = mushroomX;
	mushroomY_in = mushroomY;
	

		//pipe
	if(collision)
	begin
		mushroomX_in = mushroomX;
	   mushroomY_in = mushroomY;
		
		if(counter_val % 8'd20 <= 8'd3)
		begin
			mushroomX_in = 10'd320;
			mushroomY_in = 10'd240;
		end

		//left ledge
		else if(counter_val % 8'd20 <= 8'd7)
		begin
			mushroomX_in = 10'd180;
			mushroomY_in = 10'd249;
		end

		//right ledge
		else if(counter_val % 8'd20 <= 8'd11)
		begin
			mushroomX_in = 10'd461;
			mushroomY_in = 10'd249;
		end

		//left corner
		else if(counter_val % 8'd20 <= 8'd15)
		begin
			mushroomX_in = 10'd30;
			mushroomY_in = 10'd400;
		end

		//right corner
		else if(counter_val % 8'd20 <= 8'd19)
		begin
			mushroomX_in = 10'd610;
			mushroomY_in = 10'd400;
		end
	end
end
end
//is_mushroom
always_comb begin
  if ( (DrawX >= (mushroomX-mushroom_width)) && (DrawX <= (mushroomX+mushroom_width)) &&
			(DrawY >= (mushroomY-mushroom_height)) && (DrawY <= (mushroomY+mushroom_height)) ) 
		is_mushroom = 1'b1;				//CHANGEEE
  else
		is_mushroom = 1'b0;
end
endmodule
