module healthbar( input Clk, Reset, frame_clk,
						input [9:0] PositionX, PositionY, // hard code these in for the instances in top-level                                                      (use top left corner of bar)
						input [9:0] DrawX, DrawY,
                        input shot, heal,                             //comes from fb_char_collision detector
						output logic dead,                      //sent to corresponding character
						output logic is_healthbar,
						output logic [4:0] health_out
);

	parameter [9:0] health_Width = 10'd70;
	parameter [9:0] health_Height = 10'd8;

//internal variables
logic [4:0] health_in;
logic dead_in;


    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	
	always_ff @ (posedge Clk)
   begin
       if (Reset)
       begin
           health_out <= 5'd20;
           dead       <= 1'b0;
       end
       else
       begin
           health_out <= health_in;
           dead       <= dead_in;
       end
   end

always_comb
begin
    //default values
    health_in = health_out;
    dead_in = dead;

    if(frame_clk_rising_edge)
    begin
        //default values
        health_in = health_out;
        dead_in   = dead;

        if(health_out == 5'd0)
        begin
            dead_in = 1'b1;
				health_in = 5'd0;
        end
        else if(shot && dead == 1'b0)
        begin
            health_in = health_out - 5'd1;
            dead_in = 1'b0;
        end
		  
		  if(heal)
		  begin
				health_in = (health_out + 5'd1);
				if(health_in > 5'd20)
				health_in = 5'd20;
		  end
	end                                     //if

end                                         //always_comb


   always_comb
   begin
	  if ( (DrawX >= (PositionX - health_Width)) && (DrawX <= (PositionX + health_Width)) &&
				(DrawY >= (PositionY - health_Height)) && (DrawY <= (PositionY + health_Height)) ) 
			is_healthbar = 1'b1;
	  else
			is_healthbar = 1'b0;
   end
endmodule
