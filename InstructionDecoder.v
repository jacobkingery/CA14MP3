
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

`define OPCODE_addiu 6'b001001 // add immediate unsigned?. I TYPE
`define OPCODE_jal 6'b000011 // jump and link?
`define OPCODE_addu 6'b100001 // add . . . something? unsigned?. I TYPE
`define OPCODE_add 6'b100000 // add two registers. I TYPE
`define OPCODE_addi 6'b001000 // add immediate. I TYPE
`define OPCODE_slt 6'b101010 // set less than
`define OPCODE_bne 6'b000101 // branch not equal
`define OPCODE_beq 6'b000100 // branch if equal
`define OPCODE_jr 6'b001000 // jump . . . something? return?
`define OPCODE_sw 6'b101011 // Store word.
`define OPCODE_lw 6'b100011 // Load word.



module InstructionDecoder(instruction, RegDst, RegWr, ALUsrc, Branch, Jump, ALUcntrl, MemWr, MemToReg, TargetInstr, JumpReg, Imm16);
// Look up table that takes a 32 bit instruction word and sets all the neccissary control
// flags to make the processor preform the correct computation.

// 32 bit hex code defining which operation we will preform.
input[31:0] instruction;

// control flags. See all green labels in 'mp3processor.jpg' to see where the list
// of neccissary control flags came from.
output reg RegDst; // ?? somehow controls what location is written to the register file? I don't get this one.
output reg RegWr; // register write enable. determines if the output of the last calculation is written back to the register file or not.
output reg ALUsrc; // ALU source. does our ALU preform its operation on a value from the reg file, an immediate, or on the program counter.
output reg Branch; // are we branching? helps the instruction fetch unit know what to fetch next.
output reg Jump; // are we jumping? helps the instruction unit know what to fetch next.
output reg ALUcntrl; // ALU control. What operation should our ALU preform on the two inputs? (one input is always Da, the other is selected by ALUsrc)
output reg MemWr; // Memory Write Enable. Do we write from the register file to the Data Memory?
output reg MemToReg; // Memory to Register File. What source do we send back to the register file? Do we load from Data Memory, or return the output from the ALU.

// the next two conrol flags are addi9tional control flags found in 'mp3if.jpg' (Instruction Fetch Unit)
output reg[25:0] TargetInstr; // target instruction. If we jump, where are we jumping to?
output reg JumpReg; // Jump Register. Not sure what this one is for.

// ??? Not sure if this is needed. it is drawn in black on the reference drawing 
// (indicating that it is not an output from the Instruction Decoder), but the 
// instruction decoder is the only part of the proccessor that gets access to the 
// entire 32 bit instruction. Unless imm16 is always filled, and only used if 
// ALUsrc is set?? ALUsrc IS a control wire from the Instruction Decoder.
output reg[15:0] Imm16;

reg[5:0] op_code; // should get optimized away

always @(instruction) begin
op_code = instruction[31:26];
case (op_code)
	`OPCODE_addiu: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end
	`OPCODE_jal: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_addu: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_add: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_addi: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_slt: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_bne: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_beq: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_jr: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_sw: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	`OPCODE_lw: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end	
	
	
	default: begin RegDst = 0; RegWr = 0; ALUsrc = 0; Branch = 0; Jump = 0; 
		ALUcntrl = 0; MemWr = 0; MemToReg = 0; TargetInstr = 0; JumpReg = 0; Imm16 = 0; end
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
wire tester_RegWr;
wire tester_ALUsrc;
wire tester_Branch;
wire tester_Jump;
wire tester_ALUcntrl;
wire tester_MemWr;
wire tester_MemToReg;
wire[25:0] tester_TargetInstr;
wire tester_JumpReg;
wire[15:0] tester_Imm16;

InstructionDecoder myDecoder(tester_instruction, tester_RegDst, tester_RegWr, tester_ALUsrc, tester_Branch, tester_Jump, tester_ALUcntrl, tester_MemWr, tester_MemToReg, tester_TargetInstr, tester_JumpReg, tester_Imm16);


initial begin
// send in a handful of possible instructions, so we can see that all the control lines are set.
// no idea if they are valid op codes and address values- this should be fixed!!
#100;
tester_instruction = 32'b00100000010001110000000000001111; #1000
tester_instruction = 32'b00110000010001110000000000001111; #1000
tester_instruction = 32'b00111100010001110000000000001111; #1000
tester_instruction = 32'b11100000010001110000000000001111; #1000;
end


endmodule
