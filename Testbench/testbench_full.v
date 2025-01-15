`timescale 1ns/1ps
`define ARM_POWER_AWARE  1

module testbench() ;

        reg [1:0] VCO_DIV_SEL_r; 
        wire [1:0] VCO_DIV_SEL; 
        assign VCO_DIV_SEL = VCO_DIV_SEL_r; 
        
        reg EN_VCO_r;
        wire EN_VCO;
        assign EN_VCO=EN_VCO_r; 
        
        reg CLK_KILL_r;
        wire CLK_KILL;
        assign CLK_KILL=CLK_KILL_r;              

        reg START_r;
        wire START;
        assign START=START_r;

        reg AC_DC_r;
        wire AC_DC;
        assign AC_DC=AC_DC_r;

        reg AC_STRESS_CLK_r;
        wire AC_STRESS_CLK;
        assign AC_STRESS_CLK=AC_STRESS_CLK_r;

        reg SEL_INV_r;
        wire SEL_INV;
        assign SEL_INV=SEL_INV_r;

        reg SEL_NAND_r;
        wire SEL_NAND;
        assign SEL_NAND=SEL_NAND_r;
        
        reg SEL_NOR_r;
        wire SEL_NOR;
        assign SEL_NOR=SEL_NOR_r;
        
        reg RESETB_r;
        wire RESETB;
        assign RESETB=RESETB_r;

        reg LOAD_r;
        wire LOAD;
        assign LOAD=LOAD_r;

        reg MEAS_TRIG_r;
        wire MEAS_TRIG;
        assign MEAS_TRIG=MEAS_TRIG_r;
  
        wire PAD_OUT;
        wire [11:0] BF_COUNT;

     odometer_full_rvt DUT1  (.AC_STRESS_CLK(AC_STRESS_CLK), .RESETB(RESETB), .LOAD(LOAD),
                         .START(START), .AC_DC(AC_DC), .SEL_INV(SEL_INV), .SEL_NAND(SEL_NAND), .SEL_NOR(SEL_NOR), 
                         .MEAS_TRIG(MEAS_TRIG), .BF_COUNT(BF_COUNT), .VDD(1'b1),.VSS(1'b0));
                         
     VCO_full  DUT2 (.RESETB(RESETB), .LOAD(LOAD), .VCO_DIV_SEL(VCO_DIV_SEL), .EN_VCO(EN_VCO), .CLK_KILL(CLK_KILL), .AC_STRESS_CLK(AC_STRESS_CLK), .PAD_OUT(PAD_OUT), .VDD(1'b1) ,.VSS(1'b0));                  


initial
        begin
          //$sdf_annotate ("annotateHack.sdf",DUT,,"sdfAnnotation.log","MAXIMUM",,);
          $dumpfile ("odometer.vcd");
          //$dumpvars(1, DUT.AC_STRESS_CLK, DUT.START, DUT.AC_DC, DUT.SEL_INV, DUT.SEL_NAND, DUT.SEL_NOR, DUT.RESETB, 
          //             DUT.LOAD, DUT.MEAS_TRIG, DUT.VCO_OUT, DUT.BF_COUNT);
          //AC_STRESS_CLK_r = 1'b1 ; 
          START_r  = 1'b0 ;
          AC_DC_r   = 1'b0 ;
          SEL_INV_r   = 1'b0 ;
          SEL_NAND_r  = 1'b0 ;
          SEL_NOR_r  = 1'b0 ;
          RESETB_r       = 1'b1 ; // begin in reset
          LOAD_r         = 1'b0 ;
          MEAS_TRIG_r    = 1'b1 ;
          VCO_DIV_SEL_r    = 2'b11;
          EN_VCO_r         = 1'b0 ;
          CLK_KILL_r	= 1'b0 ;
          RESETB_r       = 1'b1 ;
    #100  RESETB_r       = 1'b0 ;
    #100  RESETB_r       = 1'b1 ; // Release reset
    #100  RESETB_r       = 1'b0 ; 
    #100  RESETB_r       = 1'b1 ;

 
    #10   EN_VCO_r         = 1'b1 ;

    #50     START_r = 1'b0 ; // falling edge of clock place scan data on to configure
            AC_DC_r   = 1'b0 ; // 
            SEL_INV_r   = 1'b1 ;
            SEL_NAND_r  = 1'b0 ;
            SEL_NOR_r  = 1'b0 ;  
            
            LOAD_r         = 1'b1 ;

            #250 MEAS_TRIG_r    = 1'b0 ;
            #25 MEAS_TRIG_r    = 1'b1 ;

            #25 ;
                 repeat (500)
            begin
             #50 ; //  Wait 500 stress clock cycles
            end 

 
            repeat (10)
            begin
             #50 ; //  Wait 10 stress clock cycles
            end 
 
            #70000 MEAS_TRIG_r    = 1'b0 ; // Next measure cycle
                 CLK_KILL_r	= 1'b1 ;
                 VCO_DIV_SEL_r    = 2'b00;
                 AC_DC_r   = 1'b1 ;
                 START_r = 1'b1;
            	SEL_INV_r   = 1'b0 ;
            	SEL_NAND_r  = 1'b1 ;
            	SEL_NOR_r  = 1'b0 ;                 
                 LOAD_r         = 1'b0 ;
            #10  LOAD_r         = 1'b1 ;
            #250 MEAS_TRIG_r    = 1'b1 ;
 
                 repeat (900)
            begin
             #50 ; //  Wait 900 stress clock cycles
            end 

             
            #10000 $finish ;
         end
endmodule 
