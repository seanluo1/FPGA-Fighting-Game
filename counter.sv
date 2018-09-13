//counter for Mario/luigi animations

module counter(input Clk, Reset,
					output logic [7:0] count
					);
logic [7:0] counter;
			
always_ff @ (posedge Clk) begin
	if(Reset)
	begin
		counter <= 0;
	end
	else if(counter == 8'd60)
	begin
		counter <= 0;
	end
	else
	begin
		counter <= counter + 8'b00000001;
	end
end

assign count = counter;

endmodule
