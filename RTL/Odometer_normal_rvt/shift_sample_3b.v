
// Simple 3 bit shift register
module shift_sample_3b(
	SHIFT_IN, 
	RST, 
	CLK, 
	DATA_OUT);
	
	input SHIFT_IN; 
	input RST; 
	input CLK;
	
	output reg [0:2] DATA_OUT; 
	
	always @ (posedge CLK or posedge RST) begin
 		if (RST) begin
  			DATA_OUT <= 3'b000;
    		end
 		else begin		
			DATA_OUT[0] <= SHIFT_IN;
			DATA_OUT[1] <= DATA_OUT[0];			
			DATA_OUT[2] <= DATA_OUT[1];

		end
	end
endmodule


