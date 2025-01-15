
// a parallel latch 12 bit shift register 
module parallel_latch(
	DETECT, 
	BF_COUNTER,
	RESETB, 
	PARALLEL_OUT,
	DEADZONE_COUNTER_MSB);
	
	input DETECT; 
	input RESETB;
	input DEADZONE_COUNTER_MSB;
	input [11:0] BF_COUNTER;
	output reg [11:0] PARALLEL_OUT ;
	
	// Beat frequency count values will be latched by DETECT, reset and due to deadzone occurance
	always @ (negedge DETECT or negedge RESETB or posedge DEADZONE_COUNTER_MSB) begin 
 		if (!RESETB) PARALLEL_OUT <= 0;				
  		else if (DEADZONE_COUNTER_MSB) PARALLEL_OUT <= 12'b111111111111;
 		else
 		begin		   
			//latching the beatcount values
				PARALLEL_OUT[0] <= BF_COUNTER[0];
				PARALLEL_OUT[1] <= BF_COUNTER[1];
				PARALLEL_OUT[2] <= BF_COUNTER[2];
				PARALLEL_OUT[3] <= BF_COUNTER[3];
				PARALLEL_OUT[4] <= BF_COUNTER[4];
				PARALLEL_OUT[5] <= BF_COUNTER[5];
				PARALLEL_OUT[6] <= BF_COUNTER[6];
				PARALLEL_OUT[7] <= BF_COUNTER[7];
				PARALLEL_OUT[8] <= BF_COUNTER[8];
				PARALLEL_OUT[9] <= BF_COUNTER[9];
				PARALLEL_OUT[10] <= BF_COUNTER[10];
				PARALLEL_OUT[11] <= BF_COUNTER[11];				

 		   end
	     	end

endmodule


