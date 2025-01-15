`timescale 1ns/1ps

module odometer_top (
	ROSC_STRESS, 
	ROSC_REF, 
	AC_STRESS_CLK,
	RESETB, 
	LOAD,  
	MEAS_TRIG, 
	SEL_INV, 
	SEL_NAND, 
	SEL_NOR,
	START, 
	AC_DC,
	SEL_INV_LATCHED, 
	SEL_NAND_LATCHED, 
	SEL_NOR_LATCHED,
	START_LATCHED, 
	AC_DC_LATCHED,		
	MEAS_STRESS, 
	EN_ROSC, 
	EN_POWER_ROSC_STRESS,
	BF_COUNT,
	VDD,VSS);

	input ROSC_STRESS; 
	input ROSC_REF;
	input AC_STRESS_CLK; 
	input RESETB;
	input LOAD;
	input MEAS_TRIG;
	input SEL_INV; 
	input SEL_NAND; 
	input SEL_NOR;
	input START; 
	input AC_DC;	
	input VDD,VSS;
			
	output MEAS_STRESS; 
	output EN_ROSC; 
	output EN_POWER_ROSC_STRESS;
	//output VCO_OUT;
	output SEL_INV_LATCHED; 
	output SEL_NAND_LATCHED; 
	output SEL_NOR_LATCHED;
	output START_LATCHED; 
	output AC_DC_LATCHED;	
	output [11:0] BF_COUNT ;	
	
	//wire [11:0] PARALLEL_OUT;
	wire [11:0] DATA ;
	wire [0:4] CTRL, CTRL_IN;
	reg MEAS_STRESS;
	reg PC_OUT;
	//wire [1:0] VCO_DIV_SEL;
	wire MEAS_DONE;
	wire RESET_MEAS_STRESS;
	//wire PARALLEL_TO_SERIAL;
	wire DETECT;
	//wire REGISTER_CLK;
	wire [11:0] BF_COUNTER ;
	wire DEADZONE_COUNTER_MSB;


	
	// sending inputs for latching with "LOAD" signal
	//assign CTRL_IN[5] = VCO_DIV_SEL[0];
	//assign CTRL_IN[6] = VCO_DIV_SEL[1];
	assign CTRL_IN[2] = SEL_INV;
	assign CTRL_IN[3] = SEL_NAND;
	assign CTRL_IN[4] = SEL_NOR;
	assign CTRL_IN[1] = AC_DC;
	assign CTRL_IN[0] = START;	



	assign RESET_MEAS_STRESS = ~RESETB | MEAS_DONE ;

	// when MEAS_STRESS=1, ROSC starts oscillating, MEAS_STRESS automatically becomes 0 when the measurement is done 
	always @ (posedge MEAS_TRIG or posedge RESET_MEAS_STRESS) begin
		if (RESET_MEAS_STRESS)
			MEAS_STRESS <=0;
		else
			MEAS_STRESS<= 1'b1; 
	end 

	
	
	
	signal_ctrl signal_ctrl_inst (
		.CTRL_IN(CTRL_IN), 
		.RESETB(RESETB), 
		.LOAD(LOAD), 
		.CTRL(CTRL));
		
	assign SEL_INV_LATCHED = CTRL[2];
	assign SEL_NAND_LATCHED = CTRL[3];
	assign SEL_NOR_LATCHED = CTRL[4];
	assign AC_DC_LATCHED = CTRL[1];
	assign START_LATCHED = CTRL[0];		
		
	
	wire EN_ROSC_before_shift;
	reg [1:0] EN_ROSC_shifted;
	power_enable power_enable_inst (
		.START(START_LATCHED),
		.MEAS_STRESS(MEAS_STRESS),
		.MEAS_DONE(MEAS_DONE), 
		.EN_POWER_ROSC_STRESS(EN_POWER_ROSC_STRESS), 
		.EN_ROSC(EN_ROSC_before_shift),
		.VDD(VDD),.VSS(VSS));

	always @ (posedge AC_STRESS_CLK or negedge MEAS_STRESS) begin
		if (!MEAS_STRESS)
			EN_ROSC_shifted <=0;
		else begin
			EN_ROSC_shifted[1] <= EN_ROSC_shifted[0]; 		
			EN_ROSC_shifted[0] <= EN_ROSC_before_shift; 
		end
	end 

	assign EN_ROSC = EN_ROSC_shifted[1];

	// generation of phase count signal, with respect to ROSC_REF signal
	always @ (posedge ROSC_REF or negedge MEAS_STRESS) begin
		if(!MEAS_STRESS)
			PC_OUT <= 1 ;
		else
			PC_OUT <= ROSC_STRESS ;
	end

	odometer_meas_detect  odometer_meas_detect_inst (
		.ROSC_REF(ROSC_REF), 
		.ROSC_STRESS(ROSC_STRESS), 
		.PC_OUT(PC_OUT), 
		.RESETB(RESETB), 
		.MEAS_STRESS(MEAS_STRESS),
		.MEAS_TRIG(MEAS_TRIG),
		.MEAS_DONE(MEAS_DONE),
		.BF_COUNTER(BF_COUNTER),
		.DETECT(DETECT),
		.DEADZONE_COUNTER_MSB(DEADZONE_COUNTER_MSB)
		);
		
	//assign REGISTER_CLK = SCANOUT_CLK | DETECT;
	parallel_latch parallel_latch_inst (
		.BF_COUNTER(BF_COUNTER),
		.PARALLEL_OUT(BF_COUNT),
		.RESETB(RESETB), 
		.DETECT(DETECT),
		.DEADZONE_COUNTER_MSB(DEADZONE_COUNTER_MSB));
	

endmodule










