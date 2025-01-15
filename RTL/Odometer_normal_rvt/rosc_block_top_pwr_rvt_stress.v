module rosc_block_top_pwr_rvt_stress(	
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
       	.OUT (OUT), 
       	.MOD_VDD_INV (MOD_VDD_INV), 
       	.MOD_VDD_NAND (MOD_VDD_NAND), 
       	.MOD_VDD_NOR (MOD_VDD_NOR),
       	.VDD (VDD),
       	.VSS (VSS));

	// chain for ring oscillator
	ROSC101_SEL_INV_RVT_STRESS ROSC_INV(.IN(IN_INV), .OUT(OUT_INV), .VDD(MOD_VDD_INV), .VSS(VSS));
	ROSC101_SEL_NAND_RVT_STRESS ROSC_NAND(.IN(IN_NAND), .OUT(OUT_NAND), .VDD(MOD_VDD_NAND), .VSS(VSS));
	ROSC101_SEL_NOR_RVT_STRESS ROSC_NOR(.IN(IN_NOR), .OUT(OUT_NOR), .VDD(MOD_VDD_NOR), .VSS(VSS));


endmodule

