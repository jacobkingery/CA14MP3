
// Instruction Decoder
// MP3 (single cycle CPU design), Computer Archetecture, Olin College, Fall 2014
// This module takes a 32 bit instruction and uses a LUT to decode this instruction to all the neccessary
// control lines for the entire CPU
// Kyle Mayer
// 12/3/2014
// rescourses: power point number 9 from class notes (contains MIPS standards for fields in the 32 bit instruction word)
// images (as documented below) drawn as a part of MP3, outlining overall CPU design. (contains records of all used control lines)
// For binary op codes: https://www.student.cs.uwaterloo.ca/~isg/res/mips/opcodes

// hex codes for all the operations we will support with our processor. Defined here to make the LUT more readable.
// op code values pulled from MIPS standards, partially found in power point 9.
// `define OP_ADD 3'd0 // syntax example

`define OPCODE_addiu 6'b001001 // add immediate unsigned. I TYPE
`define OPCODE_jal 6'b000011 // jump and link. J TYPE
`define OPCODE_addu 6'b100001 // add unsigned. R TYPE
`define OPCODE_add 6'b100000 // add two registers. R TYPE
`define OPCODE_addi 6'b001000 // add immediate. I TYPE
`define OPCODE_slt 6'b101010 // set less than. R TYPE
`define OPCODE_bne 6'b000101 // branch not equal. I TYPE
`define OPCODE_beq 6'b000100 // branch if equal. I TYPE
`define OPCODE_jr 6'b001000 // jump return. R TYPE
`define OPCODE_sw 6'b101011 // Store word. I TYPE
`define OPCODE_lw 6'b100011 // Load word. I TYPE

`define RT 2'd0
`define RD 2'd1
`define RA 2'd2

`define immediate 2'b00
`define PC 2'b01
`define Db 2'b10

`define ADD 3'd0
`define SUB 3'd1
`define SLT 3'd3


module InstructionDecoder(clk, instruction, ExtendMethod, RegDst, RegWr, ALUsrc, Branch, Jump, ALUcntrl, MemWr, MemToReg, JumpReg, InvZero);
// Look up table that takes a 32 bit instruction word and sets all the neccissary control
// flags to make the processor preform the correct computation.
input clk;
// 32 bit hex code defining which operation we will preform.
input[31:0] instruction;

// control flags. See all green labels in 'mp3processor.jpg' to see where the list
// of neccissary control flags came from.
output reg[1:0] RegDst; // register desination. selects which part of the instruction contains the write address for the register file.
output reg ExtendMethod; // extend method. chooses whether to sign extend or zero extend the immediate.
output reg RegWr; // register write enable. determines if the output of the last calculation is written back to the register file or not.
output reg[1:0] ALUsrc; // ALU source. does our ALU preform its operation on a value from the reg file, an immediate, or on the program counter.
output reg Branch; // are we branching? helps the instruction fetch unit know what to fetch next.
output reg Jump; // are we jumping? helps the instruction unit know what to fetch next.
output reg [2:0]ALUcntrl; // ALU control. What operation should our ALU preform on the two inputs? (one input is always Da, the other is selected by ALUsrc)
output reg MemWr; // Memory Write Enable. Do we write from the register file to the Data Memory?
output reg MemToReg; // Memory to Register File. What source do we send back to the register file? Do we load from Data Memory, or return the output from the ALU.

// the next control flags are addi9tional control flags found in 'mp3if.jpg' (Instruction Fetch Unit)
output reg JumpReg; // Jump Register. are we doing a jr? helps instruction fetch unit.
output reg InvZero; // Invert Zero flag. should we invert the zero flag from the ALU? makes bne possible.


wire[5:0] op_code;
assign op_code = instruction[31:26];

wire[5:0] funct = instruction[5:0];


always @(instruction,op_code, funct) begin
  case (op_code)
    0: begin
      case (funct)
        `OPCODE_addu: begin RegDst = `RD; ExtendMethod = 0; RegWr = 1; ALUsrc = `Db; Branch = 0; Jump = 0; 
          ALUcntrl = `ADD; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
        `OPCODE_add: begin RegDst = `RD; ExtendMethod = 0; RegWr = 1; ALUsrc = `Db; Branch = 0; Jump = 0; 
          ALUcntrl = `ADD; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
        `OPCODE_slt: begin RegDst = `RD; ExtendMethod = 0; RegWr = 1; ALUsrc = `Db; Branch = 0; Jump = 0; 
          ALUcntrl = `SLT; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
        `OPCODE_jr: begin RegDst = `RD; ExtendMethod = 0; RegWr = 0; ALUsrc = `Db; Branch = 0; Jump = 0; 
          ALUcntrl = `ADD; MemWr = 0; MemToReg = 0; JumpReg = 1; InvZero = 0; end 
        
        default: begin RegDst = 0; ExtendMethod = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
        ALUcntrl = 0; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end
      endcase
    end
    `OPCODE_addiu: begin RegDst = `RT; ExtendMethod = 1; RegWr = 1; ALUsrc = `immediate; Branch = 0; Jump = 0; 
      ALUcntrl = `ADD; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end
    `OPCODE_jal: begin RegDst = `RA; ExtendMethod = 0; RegWr = 1; ALUsrc = `PC; Branch = 0; Jump = 1; 
      ALUcntrl = `ADD; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
    `OPCODE_addi: begin RegDst = `RT; ExtendMethod = 0; RegWr = 1; ALUsrc = `immediate; Branch = 0; Jump = 0; 
      ALUcntrl = `ADD; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
    `OPCODE_bne: begin RegDst = `RT; ExtendMethod = 0; RegWr = 0; ALUsrc = `Db; Branch = 1; Jump = 0; 
      ALUcntrl = `SUB; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 1; end 
    `OPCODE_beq: begin RegDst = `RT; ExtendMethod = 0; RegWr = 0; ALUsrc = `Db; Branch = 1; Jump = 0; 
      ALUcntrl = `SUB; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
    `OPCODE_sw: begin RegDst = `RT; ExtendMethod = 0; RegWr = 0; ALUsrc = `immediate; Branch = 0; Jump = 0; 
      ALUcntrl = `ADD; MemWr = 1; MemToReg = 0; JumpReg = 0; InvZero = 0; end 
    `OPCODE_lw: begin RegDst = `RT; ExtendMethod = 0; RegWr = 1; ALUsrc = `immediate; Branch = 0; Jump = 0; 
      ALUcntrl = `ADD; MemWr = 0; MemToReg = 1; JumpReg = 0; InvZero = 0; end 
    
    
    default: begin RegDst = 0; ExtendMethod = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
      ALUcntrl = 0; MemWr = 0; MemToReg = 0; JumpReg = 0; InvZero = 0; end
    // helps make sure every case is represented, so that the synthesiser 
    // can optimize away all the registers. (all outputs were declared as reg). 
    // apparently the synthesiser can't get rid of them if one of my cases is incomplete.
    // default case should never be used.
  endcase
end // end always block
endmodule 

module InstructionDecoderTestBench;
reg[31:0] tester_instruction;
wire tester_RegDst;
wire tester_ExtendMethod;
wire tester_RegWr;
wire[1:0] tester_ALUsrc;
wire tester_Branch;
wire tester_Jump;
wire [2:0]tester_ALUcntrl;
wire tester_MemWr;
wire tester_MemToReg;
wire tester_JumpReg;
wire tester_InvZero;

InstructionDecoder myDecoder(tester_instruction, tester_ExtendMethod, tester_RegDst, tester_RegWr, tester_ALUsrc, tester_Branch, tester_Jump, tester_ALUcntrl, tester_MemWr, tester_MemToReg, tester_JumpReg, tester_InvZero);


initial begin
// send in a handful of possible instructions, so we can see that all the control lines are set.
// no idea if they are valid op codes and address values- this should be fixed!!

#100;

// addiu
tester_instruction = 32'b00100100000111010011111111111100; #1000
// jal
tester_instruction = 32'b00001100000000000000000000001001; #1000
// addu
tester_instruction = 32'b00000000000000100001100000100001; #1000
// add
tester_instruction = 32'b00001100000000000000000000001001; #1000
// addi
tester_instruction = 32'b00001100000000000000000000100101; #1000
// slt
tester_instruction = 32'b00100000000000010000000000000001; #1000
// bne
tester_instruction = 32'b00000000001001000000100000101010; #1000
// beq
tester_instruction = 32'b00010100001000000000000000000101; #1000
// jr
tester_instruction = 32'b00100100000000100000000000000001; #1000
// sw
tester_instruction = 32'b00100011101111011111111111111000; #1000
// lw
tester_instruction = 32'b00001100000000000000000000001001; #1000;

end


endmodule
