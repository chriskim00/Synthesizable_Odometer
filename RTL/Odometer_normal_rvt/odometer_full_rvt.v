`timescale 1ns/1ps

module odometer_full_rvt(
	AC_STRESS_CLK, 
	RESETB, 
	LOAD, 
	SEL_INV, 
	SEL_NAND, 
	SEL_NOR,
	START, 
	AC_DC,	
	MEAS_TRIG, 
	//AC_STRESS_CLK_OUT,
	BF_COUNT,
	VDD,VSS);

	input AC_STRESS_CLK; 
	input RESETB; 
	input LOAD; 
	input MEAS_TRIG;
	input VDD,VSS;
	input SEL_INV, SEL_NAND, SEL_NOR;
	input START;
	input AC_DC;	

	//output AC_STRESS_CLK_OUT;
	output [11:0] BF_COUNT ;
	
	wire MEAS_STRESS, EN_ROSC, EN_POWER_ROSC_STRESS;
	wire ROSC_STRESS_OUT, ROSC_REF_OUT;
	wire SEL_INV_LATCHED, SEL_NAND_LATCHED, SEL_NOR_LATCHED;
	wire START_LATCHED;
	wire AC_DC_LATCHED;	
	
	// Top level Control circutry
        odometer_top odometer_top(

        .ROSC_STRESS(ROSC_STRESS_OUT), 
        .ROSC_REF(ROSC_REF_OUT),
        .AC_STRESS_CLK(AC_STRESS_CLK),
        .RESETB(RESETB), 
        .LOAD(LOAD), 
        .MEAS_TRIG(MEAS_TRIG),               
        .SEL_INV(SEL_INV), 
        .SEL_NAND(SEL_NAND), 
        .SEL_NOR(SEL_NOR), 
        .START(START), 
        .AC_DC(AC_DC),
        .SEL_INV_LATCHED(SEL_INV_LATCHED), 
        .SEL_NAND_LATCHED(SEL_NAND_LATCHED), 
        .SEL_NOR_LATCHED(SEL_NOR_LATCHED), 
        .START_LATCHED(START_LATCHED), 
        .AC_DC_LATCHED(AC_DC_LATCHED),        
        .MEAS_STRESS(MEAS_STRESS), 
        .EN_ROSC(EN_ROSC), 
        .EN_POWER_ROSC_STRESS(EN_POWER_ROSC_STRESS),
        //.AC_STRESS_CLK_OUT(AC_STRESS_CLK_OUT),
        .BF_COUNT(BF_COUNT),        
        .VDD(VDD),.VSS(VSS));

	
	// Stress ROSC block with stress control        
	rosc_block_top_pwr_rvt_stress rosc_stress(
	.SEL_INV(SEL_INV_LATCHED), 
	.SEL_NAND(SEL_NAND_LATCHED), 
	.SEL_NOR(SEL_NOR_LATCHED), 
	.START(START_LATCHED), 
	.AC_DC(AC_DC_LATCHED), 
	.AC_STRESS_CLK(AC_STRESS_CLK), 
	.EN_POWER_ROSC(EN_POWER_ROSC_STRESS), 
	.EN_ROSC(EN_ROSC), 
	.MEAS_STRESS(MEAS_STRESS), 
	.OUT(ROSC_STRESS_OUT),
	.VDD(VDD),
	.VSS(VSS));
	
	// Reference ROSC block with control logic
	rosc_block_top_pwr_rvt_ref rosc_ref(
	.SEL_INV(SEL_INV_LATCHED), 
	.SEL_NAND(SEL_NAND_LATCHED), 
	.SEL_NOR(SEL_NOR_LATCHED), 
	.START(MEAS_STRESS), 
	.AC_DC(AC_DC_LATCHED), 
	.AC_STRESS_CLK(AC_STRESS_CLK), 
	.EN_POWER_ROSC(MEAS_STRESS), 
	.EN_ROSC(EN_ROSC), 
	.MEAS_STRESS(MEAS_STRESS), 
	.OUT(ROSC_REF_OUT),
	.VDD(VDD),
	.VSS(VSS));

endmodule
