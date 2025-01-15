
// serial shift register for 12 inputs
module signal_ctrl(
	CTRL_IN,  
	RESETB, 
	LOAD, 
	CTRL);
	
	input [0:4] CTRL_IN; 
	input RESETB; 
	input LOAD;
	
	output reg [0:4] CTRL;
	
	wire RESET ;
	
	assign RESET = !RESETB;

	always @ (posedge LOAD, posedge RESET) begin             // LOAD signal catches the values to the control signal
 		if (RESET) 
  			CTRL <= 0;
 		else
 			CTRL <= CTRL_IN;
	end		

endmodule	
	

