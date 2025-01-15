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

         
        reg RESETB_r;
        wire RESETB;
        assign RESETB=RESETB_r;

        reg LOAD_r;
        wire LOAD;
        assign LOAD=LOAD_r;

  
        wire PAD_OUT, AC_STRESS_CLK;
 
                         
     VCO_full  DUT2 (.RESETB(RESETB), .LOAD(LOAD), .VCO_DIV_SEL(VCO_DIV_SEL), .EN_VCO(EN_VCO), .CLK_KILL(CLK_KILL), .AC_STRESS_CLK(AC_STRESS_CLK), .PAD_OUT(PAD_OUT), .VDD(1'b1) ,.VSS(1'b0));                  

initial
        begin
          //$sdf_annotate ("annotateHack.sdf",DUT,,"sdfAnnotation.log","MAXIMUM",,);
          $dumpfile ("odometer.vcd");
          //$dumpvars(1, DUT.AC_STRESS_CLK, DUT.START, DUT.AC_DC, DUT.SEL_INV, DUT.SEL_NAND, DUT.SEL_NOR, DUT.RESETB, 
          //             DUT.LOAD, DUT.MEAS_TRIG, DUT.VCO_OUT, DUT.BF_COUNT);
          RESETB_r       = 1'b1 ; // begin in reset
          LOAD_r         = 1'b0 ;
          VCO_DIV_SEL_r    = 2'b11;
          EN_VCO_r         = 1'b0 ;
          CLK_KILL_r	= 1'b0 ;
          RESETB_r       = 1'b1 ;
    #100  RESETB_r       = 1'b0 ;
    #100  RESETB_r       = 1'b1 ; // Release reset
    #100  RESETB_r       = 1'b0 ; 
    #100  RESETB_r       = 1'b1 ;

 
    #10   EN_VCO_r         = 1'b1 ;  // Enable VCO operation

    #50     VCO_DIV_SEL_r = 2'b00 ; // falling edge of clock place scan data on to configure
            
            LOAD_r         = 1'b1 ;

            #25 ;
                 repeat (500)
            begin
             #50 ; //  Wait 500 stress clock cycles
            end 

 
            repeat (10)
            begin
             #50 ; //  Wait 10 stress clock cycles
            end 
 
            #600000 CLK_KILL_r	= 1'b1 ;
                 VCO_DIV_SEL_r    = 2'b10;
                  LOAD_r         = 1'b0 ;
            #10  LOAD_r         = 1'b1 ;
                 repeat (900)
            begin
             #50 ; //  Wait 900 stress clock cycles
            end 

             
            #10000 $finish ;
         end
endmodule 
