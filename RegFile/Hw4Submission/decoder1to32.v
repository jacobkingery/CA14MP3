
module decoder1to32(out, enable, address);
output[31:0] out;
input enable;
input[4:0] address;

assign out = enable<<address;

endmodule
