
module edge_detector(
	IN, 
	RESETB, 
	CLK, 
	DETECT);
	
	input IN;
	input RESETB; 
	input CLK;
	
	output DETECT;
	
	wire [0:2] OUT;
	wire [0:2] OUTB;
	
	wire RESET;
	assign RESET = ~RESETB;
	
	// using simple 3 bit shift register, to shift the signal, compare, and generate the DETECT pulse
	shift_sample_3b shift_reg (IN, RESET, CLK, OUT);	
	assign OUTB[0] = !OUT[0];
	assign OUTB[1] = !OUT[1];
	assign OUTB[2] = !OUT[2];

	assign DETECT = OUT[0] & OUTB[1] & OUTB[2];	
endmodule			

