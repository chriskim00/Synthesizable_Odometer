
module freq_div_12b (AC_STRESS_CLK, RESETB, FREQ_DIV_OUT);

input AC_STRESS_CLK,RESETB;
output  FREQ_DIV_OUT;

reg [11:0] DIV_OUT;   // 12 bit frequency divider bits
integer i;

assign    FREQ_DIV_OUT = DIV_OUT[11];

//using a counter as a frequency divider
always @ (posedge AC_STRESS_CLK or negedge RESETB) begin
if (!RESETB) begin

   DIV_OUT <= 0;
end

else begin
   DIV_OUT <= DIV_OUT + 1'b1  ;

end

end	
	
endmodule

