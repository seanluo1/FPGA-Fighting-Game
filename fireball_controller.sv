//fire_inball control unit

module fireball_controller(input Clk, Reset, fb0_ready, fb1_ready, fb2_ready, fb3_ready, fb4_ready,
										input [7:0]  keycode,
										input        press, button, frame_clk_edge, dead_char,
										output       fire0, fire1, fire2, fire3, fire4
									);
logic fire0_in, fire1_in, fire2_in, fire3_in, fire4_in, flag, flag_in;	
	
always_ff @ (posedge Clk)
begin
   if (Reset)
   begin
		fire0 <= 0;
		fire1 <= 0;
		fire2 <= 0;
		fire3 <= 0;
		fire4 <= 0;
		flag <= 1'b1;
	end
	else
	begin
		fire0 <= fire0_in;
		fire1 <= fire1_in;
		fire2 <= fire2_in;
		fire3 <= fire3_in;
		fire4 <= fire4_in;
		flag <= flag_in;
	end
end

always_comb
begin
fire0_in = fire0;
fire1_in = fire1;
fire2_in = fire2;
fire3_in = fire3;
fire4_in = fire4;
flag_in = flag;

if(frame_clk_edge)
begin
	//default values
	fire0_in = fire0;
	fire1_in = fire1;
	fire2_in = fire2;
	fire3_in = fire3;
	fire4_in = fire4;
	flag_in = flag;

if (press == 1'b0 && keycode == 8'h29)
	flag_in = 1'b0;
		
if(keycode == 8'h29 && press == 1'b1 && flag == 1'b0 && !dead_char)
//if(button)
begin
	if(fb0_ready)
	begin
		fire0_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
	else if(fb1_ready)
	begin
		fire1_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
	else if(fb2_ready)
	begin
		fire2_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
	else if(fb3_ready)
	begin
		fire3_in  = 1'b1;
		flag_in = 1'b1;	
	end

	else if(fb4_ready)
	begin
		fire4_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
//	else if(fb0_ready)
//	begin
//		fbMux_in = 3'b101;
//		fire_in  = 1'b1;
//	end
end
else if((keycode == 8'h29 && press == 1'b0) || keycode != 8'h29)
begin
fire0_in = 0;
fire1_in = 0;
fire2_in = 0;
fire3_in = 0;
fire4_in = 0;
end

end			//frame_clk_edge
end			//always_comb


endmodule
