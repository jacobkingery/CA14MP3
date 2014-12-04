module Mux3to1(out, addr, in0, in1, in2);
parameter inputSize = 32;
output[inputSize-1:0] out;
input addr;
input[inputSize-1:0] in0, in1, in2;

wire[2:0] inputs [inputSize-1:0];
assign inputs[0] = in0;
assign inputs[1] = in1;
assign inputs[2] = in2;

assign out = inputs[addr];
endmodule

module Mux2to1(out, addr, in0, in1);
parameter inputSize = 32;
output[inputSize-1:0] out;
input addr;
input[inputSize-1:0] in0, in1;

wire[1:0] inputs [inputSize-1:0];
assign inputs[0] = in0;
assign inputs[1] = in1;

assign out = inputs[addr];
endmodule