//color pallete
//gets color from SRAM and outputs color data to color Mapper

module sprite_address_computer4(input               is_Mario,            // Whether current pixel belongs to ball
                                                    is_Luigi, is_fb0, is_fb1, is_fb2, is_fb3, is_fb4,
																	 is_fbL0, is_fbL1, is_fbL2, is_fbL3, is_fbL4, is_Luigihb, is_Mariohb, is_leftLedge, is_rightLedge, is_pipe,
																	 is_spikey, is_Mname, is_Lname, is_lakitu, is_mushroom,
                                input			       Mario_direction,
                                                    Luigi_direction,
																	 spikey_direction,
																	 lakitu_direction,
                                input [3:0]		    Mario_behavior,
                                                    Luigi_behavior,
                                input logic [9:0]   drawX, drawY,
                                input logic [9:0]   MarioX, MarioY, fb0x, fb1x, fb2x, fb3x, fb4x, fbL0x, fbL1x, fbL2x, fbL3x, fbL4x, spikeyX, lakituX, mushroomX,
                                input logic [9:0]   LuigiX, LuigiY, fb0y, fb1y, fb2y, fb3y, fb4y, fbL0y, fbL1y, fbL2y, fbL3y, fbL4y, spikeyY, lakituY, mushroomY,
                                input logic [1:0]   Mario_animation,
																	 Luigi_animation,
										  input						 spikey_animation, lakitu_animation,
										  input logic [4:0]    which_Mhb, which_Lhb,
                                output logic [19:0]	SPRITE_ADDR,
																		background_ADDR
);

//logic variables for sprite locations and addresses
logic [19:0] sprite_mx, sprite_my;
logic [19:0] sprite_lx, sprite_ly, sprite_fx, sprite_fy, sprite_hx, sprite_hy, sprite_ledgex, sprite_ledgey, sprite_px, sprite_py, sprite_sx, sprite_sy, 
					sprite_namex, sprite_namey, sprite_Lakitux, sprite_Lakituy, sprite_mushroomx, sprite_mushroomy;
logic [19:0] sprite_ADDR;

assign SPRITE_ADDR = sprite_ADDR;
assign background_ADDR = (drawX + (drawY * 20'd640));

always_comb
begin: get_coordinates
	sprite_mx = 20'd0;
	sprite_my = 20'd0;
	sprite_lx = 20'd0;
	sprite_ly = 20'd0;
	sprite_fx = 20'd0;
	sprite_fy = 20'd0;
	sprite_hx = 20'd0;
	sprite_hy = 20'd0;	
	sprite_ledgex = 20'd0;
	sprite_ledgey = 20'd0;
	sprite_px = 20'd0;
	sprite_py = 20'd0;
	sprite_sx = 20'd0;
	sprite_sy = 20'd0;
	sprite_namex = 20'd0;
	sprite_namey = 20'd0;	
	sprite_Lakitux = 20'd0;
	sprite_Lakituy = 20'd0;
	sprite_mushroomx = 20'd0;
	sprite_mushroomy = 20'd0;
	
	if(is_mushroom)
	begin
		sprite_mushroomx = drawX - mushroomX + 20'd13;
		sprite_mushroomy = drawY - mushroomY + 20'd13;
	end
	
	if(is_lakitu)
	begin
		sprite_Lakitux = drawX - lakituX + 20'd26;
		sprite_Lakituy = drawY - lakituY + 20'd35;
	end
	
	if(is_Mname)
	begin
		sprite_namex = drawX - 10'd55 + 20'd25;
		sprite_namey = drawY - 10'd31 + 20'd9;
	end
	
	if(is_Lname)
	begin
		sprite_namex = drawX - 10'd495 + 20'd25;
		sprite_namey = drawY - 10'd31 + 20'd9;
	end
	
	if(is_spikey)
	begin
		sprite_sx = drawX - spikeyX + 20'd13;
		sprite_sy = drawY - spikeyY + 20'd13;	
	end
	
	if(is_pipe)
	begin
		 sprite_px = drawX - 20'd320 + 20'd23;
       sprite_py = drawY - 20'd432 + 20'd47;		
	end
	
	if(is_leftLedge)
	begin
		 sprite_ledgex = drawX - 20'd180 + 20'd67;
       sprite_ledgey = drawY - 20'd291 + 20'd12;	
	end
	
	if(is_rightLedge)
	begin
		 sprite_ledgex = drawX - 20'd461 + 20'd67;
       sprite_ledgey = drawY - 20'd291 + 20'd12;	
	end
	
	if(is_Mariohb)
	begin
		 sprite_hx = drawX - 20'd100 + 20'd70;
       sprite_hy = drawY - 20'd50 + 20'd8;	
	end
	
	if(is_Luigihb)
	begin
		 sprite_hx = drawX - 20'd540 + 20'd70;
       sprite_hy = drawY - 20'd50 + 20'd8;	
	end

	if(is_Mario)
	begin
        sprite_mx = drawX - MarioX + 20'd26;
        sprite_my = drawY - MarioY + 20'd28;
	end
	
	if(is_Luigi)
	begin
        sprite_lx = drawX - LuigiX + 20'd26;
        sprite_ly = drawY - LuigiY + 20'd28;
	end
	
	if(is_fb0)
	begin
		  sprite_fx = drawX - fb0x + 20'd8;
        sprite_fy = drawY - fb0y + 20'd8;
	end
	
	if(is_fb1)
	begin
		  sprite_fx = drawX - fb1x + 20'd8;
        sprite_fy = drawY - fb1y + 20'd8;
	end
	
	if(is_fb2)
	begin
		  sprite_fx = drawX - fb2x + 20'd8;
        sprite_fy = drawY - fb2y + 20'd8;
	end
	
	if(is_fb3)
	begin
		  sprite_fx = drawX - fb3x + 20'd8;
        sprite_fy = drawY - fb3y + 20'd8;
	end
	
	if(is_fb4)
	begin
		  sprite_fx = drawX - fb4x + 20'd8;
        sprite_fy = drawY - fb4y + 20'd8;
	end
	//LUIGI FIREBALLS
	if(is_fbL0)
	begin
		  sprite_fx = drawX - fbL0x + 20'd8;
        sprite_fy = drawY - fbL0y + 20'd8;
	end
	
	if(is_fbL1)
	begin
		  sprite_fx = drawX - fbL1x + 20'd8;
        sprite_fy = drawY - fbL1y + 20'd8;
	end
	
	if(is_fbL2)
	begin
		  sprite_fx = drawX - fbL2x + 20'd8;
        sprite_fy = drawY - fbL2y + 20'd8;
	end
	
	if(is_fbL3)
	begin
		  sprite_fx = drawX - fbL3x + 20'd8;
        sprite_fy = drawY - fbL3y + 20'd8;
	end
	
	if(is_fbL4)
	begin
		  sprite_fx = drawX - fbL4x + 20'd8;
        sprite_fy = drawY - fbL4y + 20'd8;
	end
end

always_comb
begin
    //default address
	sprite_ADDR = 20'h0000;
	
	if(is_mushroom)
	begin
		sprite_ADDR = (sprite_mushroomx + 20'd122 + ((sprite_mushroomy + 20'd140) * 20'd512));
	end
	
	if(is_lakitu)
	begin
	case(lakitu_direction)
			1'b1:	//right
			begin
					case(lakitu_animation)
					1'b0:
					begin
						sprite_ADDR = (sprite_Lakitux + 20'd173 + ((sprite_Lakituy + 20'd177) * 20'd512));
					end
					1'b1:
					begin
						sprite_ADDR = (sprite_Lakitux + 20'd257 + ((sprite_Lakituy + 20'd177) * 20'd512));
					end
				endcase
			end
			1'b0: //left
			begin
				case(lakitu_animation)
				1'b0:
				begin
					sprite_ADDR = (((20'd52 - sprite_Lakitux) + 20'd173) + ((sprite_Lakituy + 20'd177) * 20'd512));
				end
				1'b1:
				begin
					sprite_ADDR = (((20'd52 - sprite_Lakitux) + 20'd257) + ((sprite_Lakituy + 20'd177) * 20'd512));
				end
			   endcase
			end
		endcase
	end
	
	if(is_Mname)
	begin
		sprite_ADDR = (sprite_namex + 20'd181 + ((sprite_namey + 20'd289) * 20'd512));
	end
	
	if(is_Lname)
	begin
		sprite_ADDR = (sprite_namex + 20'd243 + ((sprite_namey + 20'd289) * 20'd512));
	end
	
	if(is_spikey)
	begin
		case(spikey_direction)
			1'b0:	//left
			begin
					case(spikey_animation)
					1'b0:
					begin
						sprite_ADDR = (sprite_sx + 20'd342 + ((sprite_sy + 20'd138) * 20'd512));
					end
					1'b1:
					begin
						sprite_ADDR = (sprite_sx + 20'd377 + ((sprite_sy + 20'd138) * 20'd512));
					end
				endcase
			end
			1'b1: //right
			begin
				case(spikey_animation)
				1'b0:
				begin
					sprite_ADDR = (((20'd26 - sprite_sx) + 20'd342) + ((sprite_sy + 20'd138) * 20'd512));
				end
				1'b1:
				begin
					sprite_ADDR = (((20'd26 - sprite_sx) + 20'd377) + ((sprite_sy + 20'd138) * 20'd512));
				end
			   endcase
			end
		endcase
	end
	
	if(is_pipe)
	begin
		sprite_ADDR = (sprite_px + 20'd379 + ((sprite_py + 20'd7) * 20'd512));
	end
	
	if(is_leftLedge || is_rightLedge)
	begin
		sprite_ADDR = (sprite_ledgex + 20'd200 + ((sprite_ledgey + 20'd140) * 20'd512));
	end
	
	if(is_fb0 || is_fb1 || is_fb2 || is_fb3 || is_fb4 || is_fbL0 || is_fbL1 || is_fbL2 || is_fbL3 || is_fbL4)
	begin
		sprite_ADDR = (sprite_fx + 20'd163 + ((sprite_fy + 20'd144) * 20'd512));
	end
	//healthbar
	if(is_Mariohb)
	begin
		case(which_Mhb)
	   5'd20, 5'd19, 5'd18, 5'd17, 5'd16, 5'd15, 5'd14:
		begin
			sprite_ADDR = (sprite_hx + 20'd19 + ((sprite_hy + 20'd258) * 20'd512));
		end
		5'd13, 5'd12, 5'd11, 5'd10, 5'd9, 5'd9, 5'd8, 5'd7:
		begin
			sprite_ADDR = (sprite_hx + 20'd173 + ((sprite_hy + 20'd258) * 20'd512));
		end
		5'd6, 5'd5, 5'd4, 5'd3, 5'd2, 5'd1:
		begin
			sprite_ADDR = (sprite_hx + 20'd330 + ((sprite_hy + 20'd258) * 20'd512));
		end
		5'd0:
		begin
			sprite_ADDR = (sprite_hx + 20'd19 + ((sprite_hy + 20'd290) * 20'd512));
		end
	endcase
	end
	//healthbar
	if(is_Luigihb)
	begin
		case(which_Lhb)
		5'd20, 5'd19, 5'd18, 5'd17, 5'd16, 5'd15, 5'd14:		
		begin
			sprite_ADDR = (sprite_hx + 20'd19 + ((sprite_hy + 20'd258) * 20'd512));
		end
		5'd13, 5'd12, 5'd11, 5'd10, 5'd9, 5'd9, 5'd8, 5'd7:
		begin
			sprite_ADDR = (sprite_hx + 20'd173 + ((sprite_hy + 20'd258) * 20'd512));
		end
		5'd6, 5'd5, 5'd4, 5'd3, 5'd2, 5'd1:
		begin
			sprite_ADDR = (sprite_hx + 20'd330 + ((sprite_hy + 20'd258) * 20'd512));
		end
		5'd0:
		begin
			sprite_ADDR = (sprite_hx + 20'd19 + ((sprite_hy + 20'd290) * 20'd512));
		end
	endcase
	end
	
	if(is_Mario)
	begin
	 case(Mario_direction)
	 //facing right
	 1'b1: 
     begin
		case(Mario_behavior)
		//standing/jumping
		4'b0000:
			begin
			//get upper left corner of sprite
			sprite_ADDR = (sprite_mx + 20'd5 + ((sprite_my + 20'd6) * 20'd512));
			end
		//running
		4'b0001:
		  //get upper left corner of sprites
		  //make animation: 0,1,2
		  begin
		  case(Mario_animation)
		  2'b00:
			   begin
				sprite_ADDR = (sprite_mx + 20'd58 + ((sprite_my + 20'd6) * 20'd512));
				end
		  2'b01:
				begin
                sprite_ADDR = (sprite_mx + 20'd113 + ((sprite_my + 20'd6) * 20'd512));
				end
		  2'b10:
				begin
                sprite_ADDR = (sprite_mx + 20'd175 + ((sprite_my + 20'd7) * 20'd512));
				end
		  default: ;
		  endcase
		  end
		//shooting
		4'b0010:
			begin
			//get upper left corner of sprite
			sprite_ADDR = (sprite_mx + 20'd304 + ((sprite_my + 20'd6) * 20'd512));
			end
		   //WINNER
		4'b0011:
			begin
			//upper left corner
			sprite_ADDR = (sprite_mx + 20'd237 + ((sprite_my + 20'd6) * 20'd512));
			end
		//LOSER
		4'b0100:
			begin
			//upper left corner
			sprite_ADDR = (sprite_mx + 20'd90 + ((sprite_my + 20'd184) * 20'd512));
			end
		default:;
		endcase
		end
	 //facing left
	 1'b0: 
	 begin
		case(Mario_behavior)
	 	4'b0000:
            begin
            //get upper left corner of sprite
            sprite_ADDR = (((20'd52 - sprite_mx) + 20'd5) + ((sprite_my + 20'd6) * 20'd512));
            end
		//running
		4'b0001:
		  //get upper right corner of sprites
		  //make animation: 0,1,2
            begin
            case(Mario_animation)
            2'b00:
                begin
                sprite_ADDR = (((20'd52 - sprite_mx) + 20'd58) + ((sprite_my + 20'd6) * 20'd512));
                end
            2'b01:
                begin
                sprite_ADDR = (((20'd52 - sprite_mx) + 20'd113) + ((sprite_my + 20'd6) * 20'd512));
                end
            2'b10:
                begin
                sprite_ADDR = (((20'd52 - sprite_mx) + 20'd175) + ((sprite_my + 20'd7) * 20'd512));
                end
            default: ;
            endcase
            end
		//shooting
		4'b0010:
			begin
            sprite_ADDR = (((20'd52 - sprite_mx) + 20'd304) + ((sprite_my + 20'd6) * 20'd512));
            end
		   //WINNER
		4'b0011:
            begin
            sprite_ADDR = (((20'd52 - sprite_mx) + 20'd237) + ((sprite_my + 20'd6) * 20'd512));
            end
		//LOSER
		4'b0100:
            begin
            sprite_ADDR = (((20'd52 - sprite_mx) + 20'd90) + ((sprite_my + 20'd184) * 20'd512));
            end
		default: ;
		endcase
	 end
	 
	 endcase
	end
	if(is_Luigi)
	begin
	case(Luigi_direction)
	 //facing left
	 1'b0:
		begin
		case(Luigi_behavior)
		//standing/jumping
		4'b0000:
			begin
			//get upper left corner of sprite
			sprite_ADDR = (((20'd52 - sprite_lx) + 20'd3) + ((sprite_ly+ 20'd70) * 20'd512));
			end
		//running
		4'b0001:
		  //get upper left corner of sprites
		  //make animation: 0,1,2
		  begin
		  case(Luigi_animation)
		  2'b00:
			   begin
				sprite_ADDR = (((20'd52 - sprite_lx) + 20'd59) + ((sprite_ly + 20'd71) * 20'd512));
				end
		  2'b01:
				begin
				sprite_ADDR = (((20'd52 - sprite_lx) + 20'd110) + ((sprite_ly + 20'd71) * 20'd512));
				end
		  2'b10:
				begin
				sprite_ADDR = (((20'd52 - sprite_lx) + 20'd173) + ((sprite_ly + 20'd71) * 20'd512));
				end
		  default: ;
		  endcase
		  end
		//shooting
		4'b0010:
			begin
			//get upper left corner of sprite
			sprite_ADDR = (((20'd52 - sprite_lx) + 20'd306) + ((sprite_ly + 20'd71) * 20'd512));
			end
        //WINNER
		4'b0011:
			begin
            sprite_ADDR = (((20'd52 - sprite_lx) + 20'd235) + ((sprite_ly + 20'd69) * 20'd512));
			end
		//LOSER
		4'b0100:
			begin
			//upper left corner
			sprite_ADDR = (((20'd52 - sprite_lx) + 20'd23) + ((sprite_ly + 20'd179) * 20'd512));
			end
		default:;
		endcase
		end
	 //facing right
	 1'b1: 
	 begin
        case(Luigi_behavior)
        //standing/jumping
        4'b0000:
        begin
        //get upper left corner of sprite
        sprite_ADDR = (sprite_lx + 20'd3 + ((sprite_ly+ 20'd70) * 20'd512));
        end
        //running
        4'b0001:
        //get upper left corner of sprites
        //make animation: 0,1,2
        begin
        case(Luigi_animation)
            2'b00:
                begin
                sprite_ADDR = (sprite_lx + 20'd59 + ((sprite_ly + 20'd71) * 20'd512));
                end
            2'b01:
                begin
                sprite_ADDR = (sprite_lx + 20'd110 + ((sprite_ly + 20'd71) * 20'd512));
                end
            2'b10:
                begin
                sprite_ADDR = (sprite_lx + 20'd173 + ((sprite_ly + 20'd71) * 20'd512));
                end
            default: ;
        endcase
        end
        //shooting
        4'b0010:
            begin
            //get upper left corner of sprite
            sprite_ADDR = (sprite_lx + 20'd306 + ((sprite_ly + 20'd71) * 20'd512));
            end
        //WINNER
        4'b0011:
            begin
            sprite_ADDR = (sprite_lx + 20'd235 + ((sprite_ly + 20'd69) * 20'd512));
            end
        //LOSER
        4'b0100:
            begin
            //upper left corner
            sprite_ADDR = (sprite_lx + 20'd23 + ((sprite_ly + 20'd179) * 20'd512));
            end
        default:;
        endcase
        end
		 endcase
    end
end
endmodule
