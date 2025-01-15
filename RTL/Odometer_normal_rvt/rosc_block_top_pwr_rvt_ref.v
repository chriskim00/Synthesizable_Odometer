module freq_trimming_control(
	EN_POWER_ROSC,
	SEL_POWER_OFF);
	
	input EN_POWER_ROSC;
	output SEL_POWER_OFF;

	assign SEL_POWER_OFF = ~EN_POWER_ROSC ;
endmodule


module pwr_controller(
	SEL_POWER_OFF,
	MEAS_STRESS,
	OUT,
	VDD,VSS);
	
	input SEL_POWER_OFF,MEAS_STRESS;
	output OUT;
	
	wire  SEL_POWER_OFF,MEAS_STRESS;
	
	wire OUT,MEAS_STRESS_INT,SEL_POWER_INT,SEL1_INT,SEL2_INT,SEL3_INT;
	inout VDD,VSS;



	INVD2 INV(.I(MEAS_STRESS), .ZN(MEAS_STRESS_INT));
	AN2D2 AND2_OFF (.A1(SEL_POWER_OFF), .A2(MEAS_STRESS_INT), .Z(SEL_POWER_INT));  // controlling of the default switch

	// Using 4 8X inverter for supplying power to the ROSCs
	INVD8 INV8_base_1 (.I(SEL_POWER_INT), .ZN(OUT)); //default power switch1
	INVD8 INV8_base_2 (.I(SEL_POWER_INT), .ZN(OUT)); //default power switch	2
	INVD8 INV8_base_3 (.I(SEL_POWER_INT), .ZN(OUT)); //default power switch3
	INVD8 INV8_base_4 (.I(SEL_POWER_INT), .ZN(OUT)); //default power switch4
		

endmodule



// Block for controlling the virtual VDD and ring oscillator selection
module ROSC103_control (
	SEL_INV, 
	SEL_NAND, 
	SEL_NOR, 
	IN_INV, 
	IN_NAND, 
	IN_NOR, 
	OUT_INV, 
	OUT_NAND, 
	OUT_NOR, 
	START, 
	AC_DC, 
	AC_STRESS_CLK, 
	EN_POWER_ROSC, 
	EN_ROSC, 
	MEAS_STRESS, 
	OUT, 
	MOD_VDD_INV, 
	MOD_VDD_NAND, 
	MOD_VDD_NOR,
	VDD, VSS
	);
	
	output IN_INV, IN_NAND, IN_NOR;
	wire IN_INV, IN_NAND, IN_NOR;
	
	input OUT_INV, OUT_NAND, OUT_NOR;
	input EN_POWER_ROSC;
	input SEL_INV, SEL_NAND, SEL_NOR;
	input START, AC_DC, AC_STRESS_CLK, EN_ROSC, MEAS_STRESS;
	output OUT;
	output MOD_VDD_INV, MOD_VDD_NAND, MOD_VDD_NOR; // modified VDD by power controller to be used at rosc
	inout VDD, VSS;
	//reg OUT;
	wire SEL_POWER_OFF, SELb_POWER_1, SELb_POWER_2, SELb_POWER_3;
	wire EN_CHAIN;
	
	freq_trimming_control freq_trim(EN_POWER_ROSC, SEL_POWER_OFF);


	// power control unit which used to control power to be applied to reference and stress rosc
	pwr_controller pwr_inv(
	.SEL_POWER_OFF(SEL_POWER_OFF), 
	.MEAS_STRESS(MEAS_STRESS), 
	.OUT(MOD_VDD_INV), 
	.VDD(VDD), .VSS(VSS));

	pwr_controller pwr_NAND(
	.SEL_POWER_OFF(SEL_POWER_OFF), 
	.MEAS_STRESS(MEAS_STRESS), 
	.OUT(MOD_VDD_NAND), 
	.VDD(VDD), .VSS(VSS));

	pwr_controller pwr_NOR(
	.SEL_POWER_OFF(SEL_POWER_OFF), 
	.MEAS_STRESS(MEAS_STRESS), 
	.OUT(MOD_VDD_NOR), 
	.VDD(VDD), .VSS(VSS));


	// determine which ROSC to be used
	// determine use internal rosc or external AC_STRESS_CLK signal
	// buff_block_en buffer_chain (EN_ROSC,EN_ROSC_INT);
	assign EN_CHAIN = ~MEAS_STRESS | SEL_POWER_OFF ;

	assign  #10 IN_INV =(EN_ROSC &  ~(OUT_INV & SEL_INV)) | (~EN_ROSC & EN_CHAIN & START & AC_DC & AC_STRESS_CLK);
	assign  #11 IN_NAND =(EN_ROSC &  ~(OUT_NAND & SEL_NAND)) | (~EN_ROSC & EN_CHAIN & START & AC_DC & AC_STRESS_CLK);
	assign  #12 IN_NOR =(EN_ROSC &  ~(OUT_NOR & SEL_NOR)) | (~EN_ROSC & EN_CHAIN & START & AC_DC & AC_STRESS_CLK);

	assign  #10 OUT = EN_ROSC & ((OUT_INV & SEL_INV) | (OUT_NAND & SEL_NAND & ~SEL_INV) | (OUT_NOR & SEL_NOR & ~SEL_NAND & ~SEL_INV));
	
	
endmodule

module rosc_block_top_pwr_rvt_ref(
	SEL_INV, 
	SEL_NAND, 
	SEL_NOR, 
	START, 
	AC_DC, 
	AC_STRESS_CLK,
     	EN_POWER_ROSC, 
     	EN_ROSC, 
     	MEAS_STRESS, 
     	OUT, 
     	VDD, VSS);
     	
  	input SEL_INV; 
  	input SEL_NAND; 
  	input SEL_NOR; 
  	input START; 
  	input AC_DC; 
  	input AC_STRESS_CLK; 
  	input EN_POWER_ROSC;
       	input EN_ROSC; 
       	input MEAS_STRESS;
       	
  	output OUT;
  	
  	inout VDD, VSS;
  	
  	wire SEL_INV; 
  	wire SEL_NAND; 
  	wire SEL_NOR; 
  	wire START; 
  	wire AC_DC; 
  	wire AC_STRESS_CLK; 
  	wire EN_POWER_ROSC;
       	wire EN_ROSC, MEAS_STRESS;
  	wire OUT;
  	wire VDD, VSS;
  	wire IN_INV, IN_NAND, IN_NOR, MOD_VDD_INV, MOD_VDD_NAND, MOD_VDD_NOR, OUT_INV, OUT_NAND, OUT_NOR;

  	// 3 ring oscillators with control blocks
  	ROSC103_control rosc_control(
  	.SEL_INV (SEL_INV), 
  	.SEL_NAND (SEL_NAND),
       	.SEL_NOR (SEL_NOR), 
       	.OUT_INV (OUT_INV), 
       	.OUT_NAND (OUT_NAND),
       	.OUT_NOR (OUT_NOR), 
       	.START (START), 
       	.AC_DC (AC_DC), 
       	.AC_STRESS_CLK (AC_STRESS_CLK),
       	.EN_POWER_ROSC (EN_POWER_ROSC), 
       	.EN_ROSC (EN_ROSC), 
       	.MEAS_STRESS (MEAS_STRESS), 
       	.IN_INV (IN_INV),
       	.IN_NAND (IN_NAND), 
       	.IN_NOR (IN_NOR), 
       	.MOD_VDD_INV (MOD_VDD_INV), 
       	.MOD_VDD_NAND (MOD_VDD_NAND), 
       	.MOD_VDD_NOR (MOD_VDD_NOR),
       	.OUT (OUT), 
       	.VDD (VDD),
       	.VSS (VSS)); 

	// chain for ring oscillator
	ROSC103_SEL_INV_RVT_REF ROSC_INV(.IN(IN_INV), .OUT(OUT_INV), .VDD(MOD_VDD_INV), .VSS(VSS));
	ROSC103_SEL_NAND_RVT_REF ROSC_NAND(.IN(IN_NAND), .OUT(OUT_NAND), .VDD(MOD_VDD_NAND), .VSS(VSS));
	ROSC103_SEL_NOR_RVT_REF ROSC_NOR(.IN(IN_NOR), .OUT(OUT_NOR), .VDD(MOD_VDD_NOR), .VSS(VSS));


endmodule

