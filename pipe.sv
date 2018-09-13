//pipe object

module pipe( input Clk, Reset,
              input [9:0]     DrawX, DrawY,
                output is_pipe);
					 

parameter [9:0]  pipe_width = 10'd23;
parameter [9:0]  pipe_height = 10'd47;

//internal logic
logic [9:0] pipe_X_Pos, pipe_Y_Pos;

always_ff @ (posedge Clk)
begin
   pipe_X_Pos <= 10'd320;
   pipe_Y_Pos <= 10'd432;
end

//is_ledge
always_comb
begin
    if( (DrawX >= (10'd320 - 10'd23)) && (DrawX <= (10'd320 + 10'd23)) && (DrawY >= (10'd432 - 10'd47)) && (DrawY <= (10'd432 + 10'd47)))
        is_pipe = 1'b1;
    else
        is_pipe = 1'b0;
end

endmodule
			