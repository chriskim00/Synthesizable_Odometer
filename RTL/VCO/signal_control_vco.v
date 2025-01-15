
// shift register to give the input bits
module signal_ctrl_vco(RESETB, LOAD, CTRL_IN, CTRL_OUT);
	input RESETB, LOAD;
	input [1:0] CTRL_IN ;
	output reg [1:0] CTRL_OUT;
	
	always @ (posedge LOAD, posedge RESETB) begin
 		if (!RESETB) 
  			CTRL_OUT <= 0;
 		else
 			CTRL_OUT <= CTRL_IN;
	end		

endmodule

