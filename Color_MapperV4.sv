//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapperV4 ( input              is_Mario,            // Whether current pixel belongs to ball 
														 is_Luigi, is_fb0, is_fb1, is_fb2, is_fb3, is_fb4, is_lakitu,
														 is_fbL0, is_fbL1, is_fbL2, is_fbL3, is_fbL4, is_Mhb, is_Lhb, is_leftLedge, is_rightLedge, is_pipe, is_spikey, is_mushroom,
														 is_Mname, is_Lname,
														 Clk,
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY, 
														sprite_x, sprite_y, // Current pixel coordinates
							  input  logic [15:0] backgroundColor,
							  input  logic [7:0]  spriteColor,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
//							  output logic [19:0] SRAM_ADDR,
//							  output select
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin
		   Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
	 if((is_Mario && spriteColor != 8'h00) || (is_Luigi && spriteColor != 8'h00) || is_Mhb || is_Lhb || 
					((is_fb0 || is_fb1 || is_fb2 || is_fb3 || is_fb4 ||
						is_fbL0 || is_fbL1 || is_fbL2 || is_fbL3 || is_fbL4) && spriteColor != 8'h00) || is_leftLedge || is_rightLedge ||
						(is_pipe && spriteColor != 8'h00) || (is_spikey && spriteColor != 8'h00) || (spriteColor != 8'h00 && (is_Mname || is_Lname)) ||
						(is_lakitu && (spriteColor != 8'h00)) || (spriteColor != 8'h00 && (is_mushroom)))
	 begin
        case(spriteColor)
				//WHITE
				8'h01:
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
				//RED
				8'h02:
				begin
					Red = 8'hff;
					Green = 8'h00;
					Blue = 8'h00;
				end
				//GREEN
				8'h03:
				begin
					Red = 8'h00;
					Green = 8'hff;
					Blue = 8'h00;
				end
				//BLUE
				8'h04:
				begin	
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'hff;
				end
				//BLACK
				8'h05:
				begin	
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
				end
				//TAN
				8'h06:
				begin	
					Red = 8'hf5;
					Green = 8'hde;
					Blue = 8'hb3;
				end
				//BROWN
				8'h07:
				begin	
					Red = 8'ha0;
					Green = 8'h52;
					Blue = 8'h2d;
				end
				//YELLOW
				8'h08:
				begin	
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'h00;
				end
				//BRICK BROWN
				8'h09:
				begin	
					Red = 8'he7;
					Green = 8'h5d;
					Blue = 8'h10;
				end
				//PIPE GREEN 1
				8'h0a:
				begin	
					Red = 8'hc1;
					Green = 8'hfd;
					Blue = 8'h18;
				end
				//PIPE GREEN 2
				8'h0b:
				begin	
					Red = 8'h00;
					Green = 8'haa;
					Blue = 8'h00;
				end
				//SHELL RED
				8'h0c:
				begin	
					Red = 8'h9b;
					Green = 8'h23;
					Blue = 8'h20;
				end
				//ENEMY YELLOW 
				8'h0d:
				begin	
					Red = 8'hd8;
					Green = 8'h8d;
					Blue = 8'h20;
				end
				//add background
				default: ;
		  endcase
		 end
		 
//		 else if(is_fb0 || is_fb1 || is_fb2 || is_fb3 || is_fb4)
//		 begin
//			Red = 8'hff;
//			Green = 8'hff;
//			Blue = 8'h00;
//		 end
		 
		 else
		 begin
        case(backgroundColor)
				//background
				16'h0000:
				begin
					Red = 8'h88;
					Green = 8'h40;
					Blue = 8'h48;
				end
				//WHITE
				16'h0100:
				begin
					Red = 8'hc0;
					Green = 8'h40;
					Blue = 8'h70;
				end
				//RED
				16'h0200:
				begin
					Red = 8'hd8;
					Green = 8'h40;
					Blue = 8'h80;
				end
				//GREEN
				16'h0300:
				begin
					Red = 8'ha8;
					Green = 8'h40;
					Blue = 8'h58;
				end
				//BLUE
				16'h0400:
				begin	
					Red = 8'h58;
					Green = 8'h38;
					Blue = 8'h20;
				end
				//BLACK
				16'h0500:
				begin	
					Red = 8'hf8;
					Green = 8'hc8;
					Blue = 8'h50;
				end
				//TAN
				16'h0600:
				begin	
					Red = 8'h80;
					Green = 8'h60;
					Blue = 8'h48;
				end
				//BROWN
				16'h0700:
				begin	
					Red = 8'h60;
					Green = 8'h40;
					Blue = 8'h28;
				end
				//YELLOW
				16'h0800:
				begin	
					Red = 8'ha0;
					Green = 8'h80;
					Blue = 8'h68;
				end
				16'h0900:
				begin	
					Red = 8'h48;
					Green = 8'hb0;
					Blue = 8'ha8;
				end
				16'h0A00:
				begin	
					Red = 8'h98;
					Green = 8'hf0;
					Blue = 8'h70;
				end
				16'h0B00:
				begin	
					Red = 8'hf8;
					Green = 8'hf8;
					Blue = 8'hf8;
				end
				16'h0C00:
				begin	
					Red = 8'hf8;
					Green = 8'hc0;
					Blue = 8'he8;
				end
				16'h0D00:
				begin	
					Red = 8'hb0;
					Green = 8'hc8;
					Blue = 8'hc8;
				end
				16'h0E00:
				begin	
					Red = 8'he8;
					Green = 8'hf0;
					Blue = 8'hc0;
				end
				16'h0F00:
				begin	
					Red = 8'hd8;
					Green = 8'he8;
					Blue = 8'hf0;
				end
			endcase
		 end
    end  
    
endmodule
