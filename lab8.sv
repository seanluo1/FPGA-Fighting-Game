//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50, PS2_CLK, PS2_DAT,
             input               Reset, Button,         //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, 
//				 output logic [8:0]  LEDG,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             output logic CE, UB, LB, OE, WE,
             output logic [19:0] ADDR,
             inout wire [15:0] Data
);
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~Reset;        // The push buttons are active low
    end
    
	 
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
	 //SRAM signals
	assign WE = 1'b1;
	assign OE = 1'b0;	
	//always on
	assign CE = 1'b0;
	assign UB = 1'b0;
	assign LB = 1'b0;
	
	//names
	logic is_Mname, is_Lname;
	always_comb
	begin
	//mario
	 if( (drawX >= (10'd30)) && (drawX <= (10'd80)) && (drawY >= (10'd22)) && (drawY <= (10'd40)))
        is_Mname = 1'b1;
    else
        is_Mname = 1'b0;
	//luigi
	 if( (drawX >= (10'd470)) && (drawX <= (10'd520)) && (drawY >= (10'd22)) && (drawY <= (10'd40)))
        is_Lname = 1'b1;
    else
        is_Lname = 1'b0;		  
	end
	
	
	
	//local variables for firball functionality
	logic [2:0] fireball;
	logic fire, is_fireball0, is_fireball1, is_fireball2, is_fireball3, is_fireball4;
	logic fb0, fb1, fb2, fb3, fb4, fire0, fire1, fire2, fire3, fire4, frame_clk_edge;
	
	fireball_controller fb_cu(.Clk, .Reset(Reset_h), .fb0_ready(fb0), .fb1_ready(fb1), .fb2_ready(fb2), .fb3_ready(fb3), .fb4_ready(fb4), .keycode(keycode), 
										.press(press), .frame_clk_edge(frame_clk_edge), .fire0, .fire1, .fire2, .fire3, .fire4, .dead_char(Mario_dead));
	
	//pick fireballs of MARIO
	
	fireballv2 fbm_0(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(mx), .Char_Y_Pos(my),
					.Char_direction(direcM), .fire(fire0) , .is_fireball(is_fireball0), .Ready_to_fire(fb0), .fbx(fb0x), .fby(fb0y), .reset(reset_m0), .disappear(disM0));
					
	fireballv2 fbm_1(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(mx), .Char_Y_Pos(my),
					.Char_direction(direcM), .fire(fire1) , .is_fireball(is_fireball1), .Ready_to_fire(fb1), .fbx(fb1x), .fby(fb1y), .reset(reset_m1), .disappear(disM1));
					
	fireballv2 fbm_2(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(mx), .Char_Y_Pos(my),
					.Char_direction(direcM), .fire(fire2) , .is_fireball(is_fireball2), .Ready_to_fire(fb2), .fbx(fb2x), .fby(fb2y), .reset(reset_m2), .disappear(disM2));
					
	fireballv2 fbm_3(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(mx), .Char_Y_Pos(my),
					.Char_direction(direcM), .fire(fire3) , .is_fireball(is_fireball3), .Ready_to_fire(fb3), .fbx(fb3x), .fby(fb3y), .reset(reset_m3), .disappear(disM3));
					
	fireballv2 fbm_4(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(mx), .Char_Y_Pos(my),
					.Char_direction(direcM), .fire(fire4) , .is_fireball(is_fireball4), .Ready_to_fire(fb4), .fbx(fb4x), .fby(fb4y), .reset(reset_m4), .disappear(disM4));
				
	logic is_fireballL0, is_fireballL1, is_fireballL2, is_fireballL3, is_fireballL4;
	logic fbL0, fbL1, fbL2, fbL3, fbL4, fireL0, fireL1, fireL2, fireL3, fireL4;
	//fireballs of LUIGI
	fireball_controllerL fb_cuL(.Clk, .Reset(Reset_h), .fbL0_ready(fbL0), .fbL1_ready(fbL1), .fbL2_ready(fbL2), .fbL3_ready(fbL3), .fbL4_ready(fbL4), .keycode(keycode), 
										.press(press), .frame_clk_edge(frame_clk_edge), .fireL0, .fireL1, .fireL2, .fireL3, .fireL4, .dead_char(Luigi_dead));
	
	fireballv2 fbl_0(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(lx), .Char_Y_Pos(ly),
					.Char_direction(direcL), .fire(fireL0) , .is_fireball(is_fireballL0), .Ready_to_fire(fbL0), .fbx(fbL0x), .fby(fbL0y), .reset(reset_l0), .disappear(disL0));
					
	fireballv2 fbl_1(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(lx), .Char_Y_Pos(ly),
					.Char_direction(direcL), .fire(fireL1) , .is_fireball(is_fireballL1), .Ready_to_fire(fbL1), .fbx(fbL1x), .fby(fbL1y), .reset(reset_l1), .disappear(disL1));
					
	fireballv2 fbl_2(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(lx), .Char_Y_Pos(ly),
					.Char_direction(direcL), .fire(fireL2) , .is_fireball(is_fireballL2), .Ready_to_fire(fbL2), .fbx(fbL2x), .fby(fbL2y), .reset(reset_l2), .disappear(disL2));
					
	fireballv2 fbl_3(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(lx), .Char_Y_Pos(ly),
					.Char_direction(direcL), .fire(fireL3) , .is_fireball(is_fireballL3), .Ready_to_fire(fbL3), .fbx(fbL3x), .fby(fbL3y), .reset(reset_l3), .disappear(disL3));
					
	fireballv2 fbl_4(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .Char_X_Pos(lx), .Char_Y_Pos(ly),
					.Char_direction(direcL), .fire(fireL4) , .is_fireball(is_fireballL4), .Ready_to_fire(fbL4), .fbx(fbL4x), .fby(fbL4y), .reset(reset_l4), .disappear(disL4));
	 
	 
	 //collision detection
	 //collision wires
	 logic x_collision, y_collision, reset_m0, reset_m1, reset_m2, reset_m3, reset_m4, reset_l0, reset_l1, reset_l2, reset_l3, reset_l4;
	 logic disL0, disL1, disL2, disL3, disL4, disM0, disM1, disM2, disM3, disM4, Mario_shot, Luigi_shot, reset_spikey1, reset_spikey2, m_col, l_col, m_heal, l_heal;
	 	 
	 //fireball collisions
	 fireball_collisions fb_detector(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS),.fb0x, .fb1x, .fb2x, .fb3x, .fb4x, .fb0y, .fb1y, .fb2y, .fb3y, .fb4y,
									.fbL0x, .fbL1x, .fbL2x, .fbL3x, .fbL4x, .fbL0y, .fbL1y, .fbL2y, .fbL3y, .fbL4y,
                           .reset_m0, .reset_m1, .reset_m2, .reset_m3, .reset_m4, .reset_l0, .reset_l1, .reset_l2, .reset_l3, .reset_l4);
									
	 //fireball_character collisions
	 fb_char_collision_detector Mario_fb(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .CharX(mx), .CharY(my), .fb0_x(fbL0x), .fb1_x(fbL1x), .fb2_x(fbL2x), .fb3_x(fbL3x), .fb4_x(fbL4x), 
														.fb0_y(fbL0y), .fb1_y(fbL1y), .fb2_y(fbL2y), .fb3_y(fbL3y), .fb4_y(fbL4y), .spikeyX, .spikeyY, .mushroomX, .mushroomY, .dropped,
														.shot(Mario_shot), .dis0(disL0), .dis1(disL1), .dis2(disL2), .dis3(disL3), .dis4(disL4),
														.fired0(fbL0), .fired1(fbL1), .fired2(fbL2), .fired3(fbL3), .fired4(fbL4), .reset_spikey(reset_spikey1), .collision(m_col), .health(m_heal));
														
	fb_char_collision_detector Luigi_fb(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .CharX(lx), .CharY(ly), .fb0_x(fb0x), .fb1_x(fb1x), .fb2_x(fb2x), .fb3_x(fb3x), .fb4_x(fb4x), 
														.fb0_y(fb0y), .fb1_y(fb1y), .fb2_y(fb2y), .fb3_y(fb3y), .fb4_y(fb4y), .spikeyX, .spikeyY, .mushroomX, .mushroomY, .dropped,
														.shot(Luigi_shot), .dis0(disM0), .dis1(disM1), .dis2(disM2), .dis3(disM3), .dis4(disM4),
														.fired0(fb0), .fired1(fb1), .fired2(fb2), .fired3(fb3), .fired4(fb4), .reset_spikey(reset_spikey2), .collision(l_col), .health(l_heal));
														
	logic [9:0] mhx, mhy, lhx, lhy;
	logic is_Mariohb, is_Luigihb, Mario_dead, Luigi_dead;	
	logic [4:0] which_Mhb, which_Lhb;
	//health bars
	healthbar Mario_hb(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .PositionX(mhx), .PositionY(mhy), .DrawX(drawX), .DrawY(drawY), .shot(Mario_shot), .dead(Mario_dead), 
								.is_healthbar(is_Mariohb), .health_out(which_Mhb), .heal(m_heal));
								
	healthbar Luigi_hb(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .PositionX(lhx), .PositionY(lhy), .DrawX(drawX), .DrawY(drawY), .shot(Luigi_shot), .dead(Luigi_dead), 
								.is_healthbar(is_Luigihb), .health_out(which_Lhb), .heal(l_heal));
	 
	 logic press, isball2;
	 logic [3:0] DATA;
	 
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
	 
	 keyboard kb(.Clk, .psClk(PS2_CLK), .psData(PS2_DAT), .reset(Reset_h), .keyCode(keycode), .press(press));
    
	 logic [9:0] drawX, drawY, mx, my, lx, ly, fb0x, fb1x, fb2x, fb3x, fb4x, fb0y, fb1y, fb2y, fb3y, fb4y, 
																fbL0x, fbL1x, fbL2x, fbL3x, fbL4x, fbL0y, fbL1y, fbL2y, fbL3y, fbL4y;
	 logic isball, direcM, direcL;
	 logic [3:0] behaveL, behaveM;
	 logic [1:0] M_animation, L_animation;
	 logic [19:0] spriteADDRS, BACK_ADDR, address;
	 always_comb
	 begin
		//health bars
		mhx = 10'd100;
		mhy = 10'd50;
		lhx = 10'd540;
		lhy = 10'd50;
		//ledges
		left_LedgeX  = 10'd180;
		left_LedgeY  = 10'd291;
		right_LedgeX = 10'd461;
		right_LedgeY = 10'd291;
	 end
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk, .Reset(Reset_h), .VGA_HS, .VGA_VS, .VGA_CLK(VGA_CLK), .VGA_BLANK_N, .VGA_SYNC_N, .DrawX(drawX), .DrawY(drawY));
    
    // Which signal should be frame_clk?
    Mario Mario_instance(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .keycode(keycode), .press(press), .is_Mario(isball), .dead(Mario_dead),
								.Direction(direcM), .Behavior(behaveM), .X_pos(mx), .Y_pos(my), .animation(M_animation), .frame_clk_edge, .LuigiX(lx), .LuigiY(ly),
								.dead_opponent(Luigi_dead));
								
    Luigi Luigi_instance(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .keycode(keycode), .press(press), .is_Luigi(isball2), .dead(Luigi_dead), .MarioX(mx), .MarioY(my),
										.Direction(direcL), .Behavior(behaveL), .X_pos(lx), .Y_pos(ly), .animation(L_animation), .dead_opponent(Mario_dead));
										
										
	 //ledges and pipes
	 logic [9:0] left_LedgeX, right_LedgeX, left_LedgeY, right_LedgeY;
	 logic is_leftLedge, is_rightLedge, is_pipe, drawing;
	 
	 ledges left_ledge(.Clk, .Reset(Reset_h), .DrawX(drawX), .DrawY(drawY), .ledgeX(left_LedgeX), .ledgeY(left_LedgeY), .is_ledge(is_leftLedge));
	 
	 ledges right_ledge(.Clk, .Reset(Reset_h), .DrawX(drawX), .DrawY(drawY), .ledgeX(right_LedgeX), .ledgeY(right_LedgeY), .is_ledge(is_rightLedge));

	 pipe pipe1(.Clk, .Reset(Reset_h), .DrawX(drawX), .DrawY(drawY), .is_pipe);
	 
	 //spikey
	 logic [9:0] spikeyX, spikeyY;
	 logic spikey_direction, spikey_animation, is_spikey, dropped;
	 spikey spikey_instance(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .spikeyX, .spikeyY, .is_spikey, .direction(spikey_direction), 
										.animation(spikey_animation), .reset_spikey(reset_spikey1 || reset_spikey2), .lakituX, .lakituY, .lakitu_direction, .lakitu_motion, .dropped);
	 //lakitu
		logic [9:0] lakituX, lakituY, lakitu_motion;
		logic lakitu_direction, lakitu_animation, is_lakitu;
	  Lakitu lakitu_instance(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .lakituX, .lakituY, .is_lakitu, .direction(lakitu_direction), 
										.animation(lakitu_animation), .lakitu_motion, .game_over(Mario_dead || Luigi_dead));
	logic [9:0] mushroomX, mushroomY;
	logic is_mushroom, collision;
	  mushroom mushroom_instance(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawX), .DrawY(drawY), .mushroomX, .mushroomY, .is_mushroom, .collision(m_col || l_col));

    
    //color_mapper color_instance(.is_ball(isball), .is_ball2(isball2), .DrawX(drawX), .DrawY(drawY), .VGA_R, .VGA_G, .VGA_B);
	 
	 sprite_address_computer4 computer(.is_Mario(isball), .Mario_direction(direcM), .Mario_behavior(behaveM), .drawX(drawX), .drawY(drawY), .MarioX(mx), .MarioY(my),
													.is_Luigi(isball2), .Luigi_direction(direcL), .Luigi_behavior(behaveL), .LuigiX(lx), .LuigiY(ly), .SPRITE_ADDR(spriteADDRS),
														.background_ADDR(ADDR), .Mario_animation(M_animation), .Luigi_animation(L_animation),
														.fb0x, .fb1x, .fb2x, .fb3x, .fb4x, .fb0y, .fb1y, .fb2y, .fb3y, .fb4y, .spikeyX, .spikeyY, .lakituX, .lakituY, .mushroomX, .mushroomY,
														.is_fb0(is_fireball0), .is_fb1(is_fireball1), .is_fb2(is_fireball2), .is_fb3(is_fireball3), .is_fb4(is_fireball4),
														.fbL0x, .fbL1x, .fbL2x, .fbL3x, .fbL4x, .fbL0y, .fbL1y, .fbL2y, .fbL3y, .fbL4y,
														.is_fbL0(is_fireballL0), .is_fbL1(is_fireballL1), .is_fbL2(is_fireballL2), .is_fbL3(is_fireballL3), .is_fbL4(is_fireballL4),
														.is_Luigihb, .is_Mariohb, .which_Lhb, .which_Mhb, .is_leftLedge, .is_rightLedge, .is_pipe, .is_spikey, .spikey_animation,
														.spikey_direction, .is_Mname, .is_Lname, .is_lakitu, .is_mushroom, .lakitu_animation, .lakitu_direction);
	 //assign ADDR = 20'h70001;
    
	 color_mapperV4 color_instance(.Clk(VGA_VS), .is_Mario(isball), .is_Luigi(isball2), .DrawX(drawX), .DrawY(drawY), .spriteColor(spriteData),
					.backgroundColor(Data), .VGA_R, .VGA_G, .VGA_B, .is_fb0(is_fireball0), .is_fb1(is_fireball1), .is_fb2(is_fireball2), .is_fb3(is_fireball3), .is_fb4(is_fireball4),
					.is_fbL0(is_fireballL0), .is_fbL1(is_fireballL1), .is_fbL2(is_fireballL2), .is_fbL3(is_fireballL3), .is_fbL4(is_fireballL4), .is_Mhb(is_Mariohb), .is_Lhb(is_Luigihb),
					.is_leftLedge, .is_rightLedge, .is_pipe, .is_spikey, .is_Mname, .is_Lname, .is_lakitu, .is_mushroom);

	//sprite memory
	 logic [7:0] spriteData;
	 logic [19:0] SADDRS;
	 assign SADDRS = 20'h1310B;
	 
	 spriteROM mem(.address(spriteADDRS), .colorData(spriteData));
	 
	 
    // Display keycode on hex display
HexDriver hex_driver3 (lakituX[3:0], HEX0);
HexDriver hex_driver2 (lakituX[7:4], HEX1);
HexDriver hex_driver1 (lakituX[9:8], HEX2);
HexDriver hex_driver0 ((m_col || l_col), HEX3);
	 
	
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
