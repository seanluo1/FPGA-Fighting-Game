module ledges( input Clk, Reset,
                input [9:0]     DrawX, DrawY,
                input logic [9:0] ledgeX, ledgeY,
                output is_ledge,
					 output [9:0] ledge_Y_Pos_out
);

//134x24

parameter [9:0]  ledge_width = 10'd67;
parameter [9:0]  ledge_height = 10'd12;

//internal logic
logic [9:0] ledge_X_Pos, ledge_Y_Pos;

assign ledge_Y_Pos_out = ledge_Y_Pos;

always_ff @ (posedge Clk)
begin
    if(Reset)
    begin
        ledge_X_Pos <= ledgeX;
        ledge_Y_Pos <= ledgeY;
    end
    else
    begin
        ledge_X_Pos <= ledgeX;
        ledge_Y_Pos <= ledgeY;
    end
end

//is_ledge
always_comb
begin
    if( (DrawX >= (ledge_X_Pos - 10'd67)) && (DrawX <= (ledge_X_Pos + 10'd67)) &&
				(DrawY >= (ledge_Y_Pos - 10'd12)) && (DrawY <= (ledge_Y_Pos + 10'd12)))
        is_ledge = 1'b1;
    else
        is_ledge = 1'b0;
end

endmodule
