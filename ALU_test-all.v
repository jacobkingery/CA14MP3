// defining gates with improper delays
`define NOTGATE not 
`define BUFGATE buf 
`define NANDGATE nand
`define NORGATE nor 
`define ANDGATE and 
`define ANDGATE4 and 
`define ORGATE or 
`define ORGATE5 or 
`define XORGATE xor 

// defining ALU commands as words
`define ADD 3'd0
`define SUB 3'd1
`define XOR 3'd2
`define SLT 3'd3
`define AND 3'd4
`define NAND 3'd5
`define NOR 3'd6
`define OR 3'd7

module ALUcontrolLUT(muxindex, invertB, invertOut, Cin, ALUcommand, clk);
// Behavioral LUT, mostly provided but configured with specific control flags
output reg[2:0] muxindex;
output reg invertB;
output reg invertOut;
output reg Cin;
input[2:0] ALUcommand;
input clk;
always @(ALUcommand) begin
// always @(negedge clk) begin
    case (ALUcommand)
    `ADD: begin muxindex = 0; invertB=0; invertOut = 0; Cin = 0; end 
    `SUB: begin muxindex = 0; invertB=1; invertOut = 0; Cin = 1; end
    `XOR: begin muxindex = 1; invertB=0; invertOut = 0; Cin = 0; end 
    `SLT: begin muxindex = 2; invertB=1; invertOut = 0; Cin = 1; end
    `AND: begin muxindex = 3; invertB=0; invertOut = 1; Cin = 0; end 
    `NAND: begin muxindex = 3; invertB=0; invertOut = 0; Cin = 0; end
    `NOR: begin muxindex = 4; invertB=0; invertOut = 0; Cin = 0; end 
    `OR: begin muxindex = 4; invertB=0; invertOut = 1; Cin = 0; end
    endcase
end
endmodule

module fullAdder(S, Cout, A, B, Cin);
// Full Adder module made previously
output S, Cout;
input A, B, Cin;
wire AxorB;
wire AxorBandCin, AandB;

// Sum
`XORGATE xor1 (AxorB, A,B);
`XORGATE xor2 (S, AxorB,Cin);

// Cout
`ANDGATE and1 (AxorBandCin, AxorB,Cin);
`ANDGATE and2 (AandB, A,B);
`ORGATE or1 (Cout, AxorBandCin,AandB);
endmodule

module add_op(res, Cout, ovfl, A, B, invertB, Cin);
// ADD with operands A and B; if command is SUB, 
// invert B and have a carryin of 1
output[31:0] res;
output Cout;
output ovfl;
input[31:0] A;
input[31:0] B;
input invertB;
input Cin;

// Initialize carry chain
wire [32:0] carry;
`BUFGATE buf1 (carry[0], Cin);

wire [31:0] Bin;
generate 
genvar index;
    for (index = 0; index<32; index = index + 1) begin : FULL_ADDER_BLOCK 
    `XORGATE xor2 (Bin[index], B[index], invertB);
    fullAdder faddr1 (res[index], carry[index+1], A[index], Bin[index], carry[index]);
end
endgenerate

// Pass last carry bit to Cout flag
`BUFGATE buf2 (Cout, carry[32]);

// Overflow checking
`XORGATE ovflw (ovfl, carry[31], Cout);
endmodule

module nand_op(res, A, B, invOut);
// NAND with A and B as inputs; invert output if command is AND
output[31:0] res;
input[31:0] A;
input[31:0] B;
input invOut;

wire [31:0] tmp;

generate
genvar index;
    for (index = 0; index<32; index = index + 1) begin : ADD_INVERT_OUTPUT_BLOCK
    `NANDGATE nand1 (tmp[index], A[index], B[index]);
    `XORGATE xor1 (res[index], tmp[index], invOut);
end
endgenerate
endmodule

module slt_op(res, sub_res, ovfl_res);
// SLT; takes in the result of subtracting B from A and overflow flag
output[31:0] res;
input[31:0] sub_res;
input ovfl_res;

// A is less than B if the MSB of B-A is 1 (indicating 
// that the result was negative) and the subtraction 
// operation did not cause overflow -or- if the MSB of
// B-A is 0 (positive) and the operation did cause overflow
`XORGATE xor1 (res[0], sub_res[31], ovfl_res);

// Left pad result with 31 0s to end up with 32 bit number
generate
genvar index;
    for (index = 1; index<32; index = index + 1) begin : LEFT_PAD_BLOCK
    `BUFGATE buf1 (res[index], 0);
end
endgenerate
endmodule

module nor_op(res, A, B, invOut);
// NOR with A and B as inputs; invert output if command is OR
output[31:0] res;
input[31:0] A;
input[31:0] B;
input invOut;

wire [31:0] tmp;

generate
genvar index;
    for (index = 0; index<32; index = index + 1) begin : NOR_INVERT_OUTPUT_BLOCK
    `NORGATE nor1 (tmp[index], A[index], B[index]);
    `XORGATE xor1 (res[index], tmp[index], invOut);
end
endgenerate
endmodule

module xor_op(res, A, B);
// XOR with A and B as inputs
output[31:0] res;
input[31:0] A;
input[31:0] B;

generate
genvar index;
    for (index = 0; index<32; index = index + 1) begin : XOR_BLOCK
    `XORGATE xor1 (res[index], A[index], B[index]);
end
endgenerate
endmodule

module ALU(result, carryout, zero, overflow, operandA, operandB, command, clk);
output[31:0] result;
output carryout;
output zero;
output overflow;
input[31:0] operandA;
input[31:0] operandB;
input[2:0] command;
input clk;

// Get control settings from LUT
wire [2:0] addr;
wire invB;
wire invOut;
wire Cin;
ALUcontrolLUT controlLUT (addr, invB, invOut, Cin, command, clk);

// Get output of each module for given settings
wire tmp_ovfl;
wire tmp_Cout;
wire [31:0] add_res;
wire [31:0] xor_res;
wire [31:0] slt_res;
wire [31:0] nor_res;
wire [31:0] nand_res;
add_op add_op1 (add_res, tmp_Cout, tmp_ovfl, operandA, operandB, invB, Cin);
xor_op xor_op1 (xor_res, operandA, operandB);
slt_op slt_op1 (slt_res, add_res, tmp_ovfl);
nor_op nor_op1 (nor_res, operandA, operandB, invOut);
nand_op nand_op1 (nand_res, operandA, operandB, invOut);

// Create complement of addresss
wire [2:0] naddr;
generate
genvar index;
    for (index = 0; index<3; index = index + 1) begin : INVERT_ADDRESS_BLOCK
    `NOTGATE not1 (naddr[index], addr[index]);
end
endgenerate

// Mux to select which result to pass out of ALU
wire [31:0] add_out;
wire [31:0] xor_out;
wire [31:0] slt_out;
wire [31:0] nor_out;
wire [31:0] nand_out;
wire [31:0] nresult;
generate
genvar ind;
    for (ind=0; ind<32; ind=ind+1) begin : SELECT_OUTPUT_BLOCK
    `ANDGATE andadd (add_out[ind], naddr[0],naddr[1],naddr[2],add_res[ind]);
    `ANDGATE andxor (xor_out[ind], addr[0],naddr[1],naddr[2],xor_res[ind]);
    `ANDGATE andslt (slt_out[ind], naddr[0],addr[1],naddr[2],slt_res[ind]);
    `ANDGATE andnor (nor_out[ind], naddr[0],naddr[1],addr[2],nor_res[ind]);
    `ANDGATE andnand (nand_out[ind], addr[0],addr[1],naddr[2],nand_res[ind]);
    `ORGATE orres (result[ind], add_out[ind],xor_out[ind],slt_out[ind],nor_out[ind],nand_out[ind]);
    `NOTGATE notres (nresult[ind], result[ind]);
end
endgenerate

// Only pass overflow and carryout out of ALU if ADD or SUB were called
`ANDGATE andovfl (overflow, naddr[0],naddr[1],naddr[2],tmp_ovfl);
`ANDGATE andcout (carryout, naddr[0],naddr[1],naddr[2],tmp_Cout);

// Check if zero flag should be set
wire [32:0] zerochain;
`BUFGATE buf3 (zerochain[0], 1);
generate
    genvar i;
    for (i=0; i<32; i=i+1) begin : ZEROCHAIN_BLOCK
    `ANDGATE zeroand (zerochain[i+1], nresult[i], zerochain[i]);
end
endgenerate
`BUFGATE buf4 (zero, zerochain[32]);
endmodule

module testALU;
reg [31:0] A;
reg [31:0] B;
reg [2:0] command;
wire [31:0] res;
wire Cout;
wire zero;
wire ovfl;

ALU myALU (res, Cout, zero, ovfl, A, B, command);

initial begin

command=`ADD;
$display("ADD");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing zeros");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b00000000000000000000000000000001;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 1 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing corner cases");
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111110 1 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing carryout and no overflow"); 
A=32'b11111110000000000000000000000000;B=32'b11111110000000000000000000000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111100000000000000000000000001 1 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing overflow and no carryout"); 
A=32'b01010101010101010101010101010101;B=32'b01010101010101010101010101010101; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 10101010101010101010101010101010 0 0 1", A, B, res, Cout, zero, ovfl);
A=32'b01111111111111111111111111111111;B=32'b01111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111110 0 0 1", A, B, res, Cout, zero, ovfl);
$display("Testing carryout and overflow"); 
A=32'b11010001000100010001000100010001;B=32'b10001000100010001000100010001000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 01011001100110011001100110011001 1 0 1", A, B, res, Cout, zero, ovfl);
A=32'b10000000000000000000000000000000;B=32'b10000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 1 1 1", A, B, res, Cout, zero, ovfl);

command=`SUB;
$display("SUB");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing zeros");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 1 1 0", A, B, res, Cout, zero, ovfl);
A=32'b01000000010010100000010011100101;B=32'b01000000010010100000010011100101; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 1 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing corner cases");
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 1 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 1 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing carryout and overflow"); 
A=32'b10000000000000000000000000000000;B=32'b01000000000000000000000000000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00111111111111111111111111111111 1 0 1", A, B, res, Cout, zero, ovfl);
A=32'b10111000000000000000000000000000;B=32'b01010010110000000011001000000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 01100101001111111100110111111111 1 0 1", A, B, res, Cout, zero, ovfl);
$display("Testing overflow and no carryout"); 
A=32'b01010101010101010101010101010101;B=32'b10101010101010101010101010101010; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 10101010101010101010101010101011 0 0 1", A, B, res, Cout, zero, ovfl);
A=32'b01000000000000000000000000000000;B=32'b10000000000000000000000000000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 10111111111111111111111111111111 0 0 1", A, B, res, Cout, zero, ovfl);
$display("Testing carryout and no overflow"); 
A=32'b01111111111111111111111111111111;B=32'b01111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 1 1 0", A, B, res, Cout, zero, ovfl);
A=32'b01010101010101010101010101010101;B=32'b01010101010101010101010101010100; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000001 1 0 0", A, B, res, Cout, zero, ovfl);

command=`XOR;
$display("XOR");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing corner cases");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing A Combination");
A=32'b10100000000001100001010000000111;B=32'b11111111110000000001010001000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 01011111110001100000000001000110 0 0 0", A, B, res, Cout, zero, ovfl);

command=`SLT;
$display("SLT");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing corner cases");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing negative overflow");
A=32'b10000000000000000000000000000001;B=32'b00000000000000000000000000000010; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000001 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing positive overflow");
A=32'b01111111111111111111111111111111;B=32'b10000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing Carryouts");
A=32'b00000000000000000000000000000001;B=32'b11111111111111111111111111111110; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111110; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111110;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000001 0 0 0", A, B, res, Cout, zero, ovfl);

command=`NOR;
$display("NOR");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing corner cases");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing A Combination");
A=32'b10100000000001100001010000000111;B=32'b11111111110000000001010001000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000001110011110101110111000 0 0 0", A, B, res, Cout, zero, ovfl);

command=`OR;
$display("OR");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing corner cases");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing zeros");
A=32'b10000000000000000000000000000000;B=32'b10000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 10000000000000000000000000000000 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b00000000000000000000000000000001;B=32'b00000000000000000000000000000001; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000001 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing ones");
A=32'b10101010101010101010101010101010;B=32'b01010101010101010101010101010101; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111110000000000000000;B=32'b00000000000000001111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing random for good measure");
A=32'b11001000001100101101001110100101;B=32'b00011000000110111100100111001110; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11011000001110111101101111101111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b01101010111011001001000011010011;B=32'b00111110010100111000100000101011; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 01111110111111111001100011111011 0 0 0", A, B, res, Cout, zero, ovfl);

command=`NAND;
$display("NAND");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing corner cases");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing zeros");
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing ones");
A=32'b10101010101010101010101010101010;B=32'b01010101010101010101010101010101; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111110000000000000000;B=32'b00000000000000001111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing random");
A=32'b10101010101010101010101010101010;B=32'b10101010101010101010101010101010; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 01010101010101010101010101010101 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111110000000000000000;B=32'b11111111111111110000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000001111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11001000001100101101001110100101;B=32'b00011000000110111100100111001110; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11110111111011010011111001111011 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b01101010111011001001000011010011;B=32'b00111110010100111000100000101011; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11010101101111110111111111111100 0 0 0", A, B, res, Cout, zero, ovfl);

command=`AND;
$display("AND");
$display("A                                | B                                || RES                              | Cout | Zero | OVFL || Expected");
$display("Testing corner cases");
A=32'b00000000000000000000000000000000;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b00000000000000000000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111111111111111111111;B=32'b11111111111111111111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111111111111111111111 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing zeros");
A=32'b10101010101010101010101010101010;B=32'b01010101010101010101010101010101; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111110000000000000000;B=32'b00000000000000001111111111111111; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00000000000000000000000000000000 0 1 0", A, B, res, Cout, zero, ovfl);
$display("Testing ones");
A=32'b10101010101010101010101010101010;B=32'b10101010101010101010101010101010; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 10101010101010101010101010101010 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b11111111111111110000000000000000;B=32'b11111111111111110000000000000000; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 11111111111111110000000000000000 0 0 0", A, B, res, Cout, zero, ovfl);
$display("Testing random for good measure");
A=32'b11001000001100101101001110100101;B=32'b00011000000110111100100111001110; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00001000000100101100000110000100 0 0 0", A, B, res, Cout, zero, ovfl);
A=32'b01101010111011001001000011010011;B=32'b00111110010100111000100000101011; #3500
$display("%b | %b || %b | %b    | %b    | %b    || 00101010010000001000000000000011 0 0 0", A, B, res, Cout, zero, ovfl);
end
endmodule
