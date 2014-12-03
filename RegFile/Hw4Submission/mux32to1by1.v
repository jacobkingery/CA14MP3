module mux32to1by1(out, address, inputs);
input[31:0] inputs;
input[4:0] address;
output out;
// your code

wire[31:0] inputsofmux;
wire outputofmux;
assign outputofmux=inputsofmux[address];


endmodule
