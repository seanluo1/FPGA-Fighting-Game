//fireball - character collision detection

module fb_char_collision_detector( input       Clk, Reset, frame_clk,
                                input [9:0] CharX, CharY,
                                input [9:0] fb0_x, fb1_x, fb2_x, fb3_x, fb4_x, spikeyX, mushroomX,
                                            fb0_y, fb1_y, fb2_y, fb3_y, fb4_y, spikeyY, mushroomY,
										  input 		fired0, fired1, fired2, fired3, fired4, dropped,
                                output      shot, dis0, dis1, dis2, dis3, dis4, reset_spikey, collision, health  //if dis(n) = 1 then corresponding fireball should disappear
                                );

//internal logic
logic shot_in, dis0_in, dis1_in, dis2_in, dis3_in, dis4_in, reset_spikey_in, collision_in, health_in;
logic [9:0] fb0_right, fb0_left, fb0_top, fb0_bottom,
				fb1_right, fb1_left, fb1_top, fb1_bottom,
				fb2_right, fb2_left, fb2_top, fb2_bottom,
				fb3_right, fb3_left, fb3_top, fb3_bottom,
				fb4_right, fb4_left, fb4_top, fb4_bottom;
logic [9:0] c_right, c_left, c_top, c_bottom, pipe_left, pipe_right, pipe_top, pipe_bottom, s_right, s_left, s_top, s_bottom,
					m_right, m_left, m_top, m_bottom;

assign c_right  = CharX + 10'd26;
assign c_left   = CharX - 10'd26;
assign c_top    = CharY - 10'd28;
assign c_bottom = CharY + 10'd28;

assign m_right  = mushroomX + 10'd13;
assign m_left   = mushroomX - 10'd13;
assign m_top    = mushroomY - 10'd13;
assign m_bottom = mushroomY + 10'd13;

assign s_right  = spikeyX + 10'd13;
assign s_left   = spikeyX - 10'd13;
assign s_top    = spikeyY - 10'd13;
assign s_bottom = spikeyY + 10'd13;

assign pipe_right  = 10'd320 + 10'd23;
assign pipe_left   = 10'd320 - 10'd23;
assign pipe_top    = 10'd386;
assign pipe_bottom = 10'd479;

assign fb0_right  = fb0_x + 10'd16;
assign fb0_left   = fb0_x - 10'd16;
assign fb0_top    = fb0_y - 10'd16;
assign fb0_bottom = fb0_y + 10'd16;

assign fb1_right  = fb1_x + 10'd16;
assign fb1_left   = fb1_x - 10'd16;
assign fb1_top    = fb1_y - 10'd16;
assign fb1_bottom = fb1_y + 10'd16;

assign fb2_right  = fb2_x + 10'd16;
assign fb2_left   = fb2_x - 10'd16;
assign fb2_top    = fb2_y - 10'd16;
assign fb2_bottom = fb2_y + 10'd16;

assign fb3_right  = fb3_x + 10'd16;
assign fb3_left   = fb3_x - 10'd16;
assign fb3_top    = fb3_y - 10'd16;
assign fb3_bottom = fb3_y + 10'd16;

assign fb4_right  = fb4_x + 10'd16;
assign fb4_left   = fb4_x - 10'd16;
assign fb4_top    = fb4_y - 10'd16;
assign fb4_bottom = fb4_y + 10'd16;


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
        shot <= 1'b0;
        dis0 <= 1'b0;
        dis1 <= 1'b0;
        dis2 <= 1'b0;
        dis3 <= 1'b0;
        dis4 <= 1'b0;
		  reset_spikey <= 1'b0;
		  health       <= 1'b0;
		  collision    <= 1'b0;
    end
    else
    begin
        shot <= shot_in;
        dis0 <= dis0_in;
        dis1 <= dis1_in;
        dis2 <= dis2_in;
        dis3 <= dis3_in;
        dis4 <= dis4_in;
		  reset_spikey <= reset_spikey_in;
		  collision    <= collision_in;
		  health       <= health_in;
    end
end

always_comb
begin
    //default
    shot_in = shot;
    dis0_in = dis0;
    dis1_in = dis1;
    dis2_in = dis2;
    dis3_in = dis3;
    dis4_in = dis4;
	 reset_spikey_in = reset_spikey;
	 collision_in    = collision;
	 health_in = health;

    if(frame_clk_rising_edge)
    begin
        //default
        shot_in = 1'b0;
        dis0_in = 1'b0;
        dis1_in = 1'b0;
        dis2_in = 1'b0;
        dis3_in = 1'b0;
        dis4_in = 1'b0;
		  reset_spikey_in = 1'b0;
		  health_in = 1'b0;
		  collision_in = 1'b0;
		  
//fire ball character collisions
        if(((fb0_right >= c_left) && (c_right >= fb0_left) && (fb0_bottom >= c_top) && (fb0_top <= c_bottom)) && !fired0)
        begin
            shot_in = 1'b1;
            dis0_in = 1'b1;
        end

        if(((fb1_right >= c_left) && (c_right >= fb1_left) && (fb1_bottom >= c_top) && (fb1_top <= c_bottom)) && !fired1)
        begin
            shot_in = 1'b1;
            dis1_in = 1'b1;
        end

        if(((fb2_right >= c_left) && (c_right >= fb2_left) && (fb2_bottom >= c_top) && (fb2_top <= c_bottom)) && !fired2)
        begin
            shot_in = 1'b1;
            dis2_in = 1'b1;
        end

        if(((fb3_right >= c_left) && (c_right >= fb3_left) && (fb3_bottom >= c_top) && (fb3_top <= c_bottom)) && !fired3)
        begin
            shot_in = 1'b1;
            dis3_in = 1'b1;
        end

        if(((fb4_right >= c_left) && (c_right >= fb4_left) && (fb4_bottom >= c_top) && (fb4_top <= c_bottom)) && !fired4)
        begin
            shot_in = 1'b1;
            dis4_in = 1'b1;
        end

		  //pipe and fireball collisions

		   if(((fb0_right >= pipe_left) && (pipe_right >= fb0_left) && (fb0_bottom >= pipe_top) && (fb0_top <= pipe_bottom)) && !fired0)
        begin
            dis0_in = 1'b1;
        end

        if(((fb1_right >= pipe_left) && (pipe_right >= fb1_left) && (fb1_bottom >= pipe_top) && (fb1_top <= pipe_bottom)) && !fired1)
        begin
            dis1_in = 1'b1;
        end

        if(((fb2_right >= pipe_left) && (pipe_right >= fb2_left) && (fb2_bottom >= pipe_top) && (fb2_top <= pipe_bottom)) && !fired2)
        begin
            dis2_in = 1'b1;
        end

        if(((fb3_right >= pipe_left) && (pipe_right >= fb3_left) && (fb3_bottom >= pipe_top) && (fb3_top <= pipe_bottom)) && !fired3)
        begin
            dis3_in = 1'b1;
        end

        if(((fb4_right >= pipe_left) && (pipe_right >= fb4_left) && (fb4_bottom >= pipe_top) && (fb4_top <= pipe_bottom)) && !fired4)
        begin
            dis4_in = 1'b1;
        end

		//spikey collisions
		 if(((s_right >= c_left) && (c_right >= s_left) && (s_bottom >= c_top) && (s_top <= c_bottom)) && dropped)
       begin
            shot_in = 1'b1;
				reset_spikey_in = 1'b1;
       end
		 
		 if(((m_right >= c_left) && (c_right >= m_left) && (m_bottom >= c_top) && (m_top <= c_bottom)))
       begin
            health_in = 1'b1;
				collision_in = 1'b1;
       end
    end                                                 //if frame end

end                                                     //always comb end

endmodule


