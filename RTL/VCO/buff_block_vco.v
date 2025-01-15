module buff_block_vco(PAD_OUT_INT, PAD_OUT);

input PAD_OUT_INT;
output PAD_OUT;

BUFFD4 buff_vco_out(.Z(PAD_OUT), .I(PAD_OUT_INT));

endmodule


