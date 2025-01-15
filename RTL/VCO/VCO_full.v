`timescale 1ns/100ps


module VCO_full (RESETB, LOAD, VCO_DIV_SEL, EN_VCO, CLK_KILL, AC_STRESS_CLK, PAD_OUT, VDD,VSS);
input RESETB, LOAD, EN_VCO, CLK_KILL, VDD, VSS;
input [1:0] VCO_DIV_SEL;

output PAD_OUT;
output reg AC_STRESS_CLK;

wire [3:0] CTRL_IN;
reg [3:0] CTRL_OUT;
wire [1:0] VCO_DIV_SEL_INT;
wire  BEFORE_DIVIDER, DIV2_OUT, DIV4_OUT, DIV8_OUT, EN_VCO_INT, CLK_KILL_INT, FREQ_DIV_OUT;
reg  PAD_OUT_INT;

//assigning controls to wires for latching
assign CTRL_IN[0] = EN_VCO;
assign CTRL_IN[1] = CLK_KILL;
assign CTRL_IN[2] = VCO_DIV_SEL[0];
assign CTRL_IN[3] = VCO_DIV_SEL[1];

always @ (posedge LOAD or negedge RESETB) begin
 		if (!RESETB) 
  			CTRL_OUT <= 0;
 		else
 			CTRL_OUT <= CTRL_IN;
end

//renaming controls
assign EN_VCO_INT = CTRL_OUT[0];
assign CLK_KILL_INT = CTRL_OUT[1];
assign VCO_DIV_SEL_INT[0] = CTRL_OUT[2];
assign VCO_DIV_SEL_INT[1] = CTRL_OUT[3];

// ROSC block
ROSC101_SEL_INV RO ( .EN_VCO(EN_VCO_INT), .OUT(BEFORE_DIVIDER), .VDD(VDD), .VSS(VSS) );

// frequency divider for multiplexing
freq_div_3b freq_div_3b (
		.BEFORE_DIVIDER(BEFORE_DIVIDER),
		.RESETB(RESETB),
		.DIV2_OUT(DIV2_OUT),
		.DIV4_OUT(DIV4_OUT),
		.DIV8_OUT(DIV8_OUT));

//multiplexer to select the waveform that has a frequency of 1/2, 1/4 or 1/8 of the base frequency
always @ (BEFORE_DIVIDER or VCO_DIV_SEL_INT or DIV2_OUT or DIV4_OUT or DIV8_OUT) begin
case (VCO_DIV_SEL_INT)
		2'b00 : AC_STRESS_CLK = BEFORE_DIVIDER;
		2'b01 : AC_STRESS_CLK = DIV2_OUT;
		2'b10 : AC_STRESS_CLK = DIV4_OUT;
		2'b11 : AC_STRESS_CLK = DIV8_OUT;
		default: AC_STRESS_CLK = BEFORE_DIVIDER;

endcase
end

//12b frequency divider for output PAD
freq_div_12b freq_div_12b (
	.AC_STRESS_CLK(AC_STRESS_CLK), 
	.RESETB(RESETB), 
	.FREQ_DIV_OUT(FREQ_DIV_OUT));

// PAD_OUT signal is for measuring the ROSC frequency,
always @ (CLK_KILL_INT or FREQ_DIV_OUT) 
	if (CLK_KILL_INT) PAD_OUT_INT <= 0;
	else PAD_OUT_INT <= FREQ_DIV_OUT;

// buffered output	
buff_block_vco buff_block_vco (
	.PAD_OUT_INT(PAD_OUT_INT), 
	.PAD_OUT(PAD_OUT));



endmodule

