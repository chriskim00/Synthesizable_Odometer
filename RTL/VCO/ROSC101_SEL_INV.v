`timescale 1ns/10ps

module ROSC101_SEL_INV #(parameter stages = 101) (EN_VCO,OUT,VSS,VDD);
input EN_VCO;
output OUT;
wire w[stages:1];
inout VSS,VDD;
wire OUTP;
genvar i;

    ND2D2 EN_NAND (.A1 (EN_VCO), .A2 (OUTP), .ZN (w[1]));
    generate 
    for (i=1; i<stages; i=i+1) begin:RO
		INVD2 INV2 (.I (w[i]), .ZN (w[i+1]));
    end

    endgenerate
    
    assign #50 OUTP = w[stages];
    INVD2 INV_load (.I (OUTP), .ZN (OUT));
    

endmodule

