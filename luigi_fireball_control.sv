//luigi fireball controller
//fire_inball control unit

module fireball_controllerL(input Clk, Reset, fbL0_ready, fbL1_ready, fbL2_ready, fbL3_ready, fbL4_ready,
										input [7:0]  keycode,
										input        press, button, frame_clk_edge, dead_char,
										output       fireL0, fireL1, fireL2, fireL3, fireL4
									);
logic fire0_in, fire1_in, fire2_in, fire3_in, fire4_in, flag, flag_in;	
	
always_ff @ (posedge Clk)
begin
   if (Reset)
   begin
		fireL0 <= 0;
		fireL1 <= 0;
		fireL2 <= 0;
		fireL3 <= 0;
		fireL4 <= 0;
		flag <= 1'b1;
	end
	else
	begin
		fireL0 <= fire0_in;
		fireL1 <= fire1_in;
		fireL2 <= fire2_in;
		fireL3 <= fire3_in;
		fireL4 <= fire4_in;
		flag <= flag_in;
	end
end

always_comb
begin
fire0_in = fireL0;
fire1_in = fireL1;
fire2_in = fireL2;
fire3_in = fireL3;
fire4_in = fireL4;
flag_in = flag;

if(frame_clk_edge)
begin
	//default values
	fire0_in = fireL0;
	fire1_in = fireL1;
	fire2_in = fireL2;
	fire3_in = fireL3;
	fire4_in = fireL4;
	flag_in = flag;

if (press == 1'b0 && keycode == 8'h59)
	flag_in = 1'b0;
		
if(keycode == 8'h59 && press == 1'b1 && flag == 1'b0 && !dead_char)
//if(button)
begin
	if(fbL0_ready)
	begin
		fire0_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
	else if(fbL1_ready)
	begin
		fire1_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
	else if(fbL2_ready)
	begin
		fire2_in  = 1'b1;
		flag_in = 1'b1;	
	end
	
	else if(fbL3_ready)
	begin
		fire3_in  = 1'b1;
		flag_in = 1'b1;	
	end

	else if(fbL4_ready)
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
else if((keycode == 8'h59 && press == 1'b0) || keycode != 8'h59)
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
