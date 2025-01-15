
module odometer_meas_detect (
	ROSC_REF,           	 	// reference rosc 
	ROSC_STRESS,         	 	// stress rosc  
	PC_OUT, 		 	// phase count signal
	RESETB, 			// reset signal
	MEAS_STRESS, 			// stays on when the stress data is being measured
	MEAS_TRIG,
	MEAS_DONE, 			// gives a pulse when the measurement is finished
	BF_COUNTER, 			// output of beat frequency counter
	DETECT, 			// detects the edges of phase count signal
	DEADZONE_COUNTER_MSB
	);		// signals when beat frequency count goes from parallel to serial mode
	
	input ROSC_REF; 
	input ROSC_STRESS; 
	input PC_OUT; 
	input RESETB; 
	input MEAS_STRESS; 
	input MEAS_TRIG;

	output reg MEAS_DONE;
	output reg [11:0] BF_COUNTER;
	output DETECT;	
	output DEADZONE_COUNTER_MSB;
	
	reg [12:0] DEADZONE_ESCAPE_COUNTER;
	reg [1:0] DETECT_COUNTER;
	
	wire RESET_BF_COUNTER;
	wire RESET_DEADZONE_ESCAPE_COUNTER; 
	wire RESET_MEAS_STRESS; 
	wire RESET_DETECT_COUNTER; 
	
	assign DEADZONE_COUNTER_MSB = DEADZONE_ESCAPE_COUNTER[12];
	assign DETECT_END = DETECT_COUNTER[1] & DETECT_COUNTER[0];
	assign SET_MEAS_DONE = DEADZONE_ESCAPE_COUNTER[1] | DETECT_END;
	always @ ( posedge DETECT_END or posedge DEADZONE_ESCAPE_COUNTER[1] or negedge RESETB or negedge MEAS_TRIG)
		if (!RESETB) MEAS_DONE <= 0;
		else if (!MEAS_TRIG) MEAS_DONE <= 0;
		else if (DETECT_END)
			MEAS_DONE <= 1;
		else if (DEADZONE_COUNTER_MSB) MEAS_DONE <= 1;
		//else 
		//	MEAS_DONE = 0;
	// measurement is finished if DETECT_COUNTER=11(binary), which is the count of the edges of the phase count signal
	//always @ (negedge ROSC_REF)
	//	MEAS_DONE = 0;
		
	edge_detector edge_detector_inst (PC_OUT, RESETB, ROSC_REF, DETECT);   // edge detector circuit
	
	//assign RESET_DEADZONE_ESCAPE_COUNTER = ~RESETB | (DETECT_COUNTER[1] & ~DETECT_COUNTER[0])  | ~MEAS_STRESS;	
	assign RESET_DEADZONE_ESCAPE_COUNTER = ~RESETB | DETECT_COUNTER[1]  | ~MEAS_STRESS;  // will reset DEADZONE_ESCAPE_COUNTER when DETECT_COUNTER = 2, if no deadzone
	
	assign RESET_BF_COUNTER = ~RESETB | ~DETECT_COUNTER[1] ;  //will reset when DETECT_COUNTER =0, DETECT_COUNTER = 1, will work between DETECT_COUNTER 2 and 3
	assign RESET_DETECT_COUNTER=~RESETB | ~MEAS_STRESS ;  // MEAS_STRESS will go low when the measurement is done, counters will be reset


	always @ (negedge ROSC_REF or posedge RESET_BF_COUNTER) begin    // Count is being measured at negative edge of the reference rosc
		if (RESET_BF_COUNTER) begin
			if (DEADZONE_ESCAPE_COUNTER[12]==1) BF_COUNTER <= 12'b111111111111; 
			else BF_COUNTER <= 12'b000000000000;
		end
		else BF_COUNTER <= BF_COUNTER + 1'b1;			
	end


	always @ (posedge ROSC_STRESS or posedge RESET_DEADZONE_ESCAPE_COUNTER) begin   // Count is being measured at negative edge of the reference rosc
		if (RESET_DEADZONE_ESCAPE_COUNTER)
			DEADZONE_ESCAPE_COUNTER <= 13'b0000000000000;
		else
			DEADZONE_ESCAPE_COUNTER <= DEADZONE_ESCAPE_COUNTER + 1'b1;
	end
	
//	always @ (negedge DETECT or posedge RESET_DETECT_COUNTER) begin
	always @ (negedge DETECT or negedge RESETB or negedge MEAS_STRESS) begin
		if (!RESETB)                     
			DETECT_COUNTER <= 2'b00;   // counter is reset when measurement is done
		else 
			if (!MEAS_STRESS) DETECT_COUNTER <= 2'b00;  
			else DETECT_COUNTER <= DETECT_COUNTER + 2'b01;   // otherwise counter keeps counting detect signals
	end

//	assign PARALLEL_TO_SERIAL = MEAS_DONE | !MEAS_STRESS;


endmodule


