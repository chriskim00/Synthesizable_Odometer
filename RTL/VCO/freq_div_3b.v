module freq_div_3b (
	BEFORE_DIVIDER,
	RESETB,
	DIV2_OUT,
	DIV4_OUT,
	DIV8_OUT);
	
	input BEFORE_DIVIDER;
	input RESETB;
	
	output DIV2_OUT;
	output DIV4_OUT;
	output DIV8_OUT;

	reg [2:0] DIV_OUT;   // 3 bit frequency divider output

	assign    DIV2_OUT = DIV_OUT[0];
	assign    DIV4_OUT = DIV_OUT[1];
	assign    DIV8_OUT = DIV_OUT[2];

	//using a counter as a frequency divider
	always @ (posedge BEFORE_DIVIDER or negedge RESETB) begin
		if (!RESETB) begin
   			DIV_OUT <= 0;
		end
		else begin
   			DIV_OUT <= DIV_OUT + 1'b1  ;
		end
	end		
endmodule


