module CPU;

  // Clock
  reg clk;
  initial clk=1;
  always #100 clk = !clk;

  // Answer
  wire[31:0] answer;

  // Control flags
  wire RegDst, ExtendMethod, RegWr, Branch, Jump, MemWr, MemToReg, JumpReg, InvZero;
  wire[1:0] ALUsrc; 
  wire[2:0] ALUcntrl; 

  // Program Counter
  wire[29:0] PC;
  wire[31:0] PC32;
  assign PC32 = {{2{1'b0}}, PC32};

  // Instruction
  wire[31:0] Instruction;

  // Wires
  wire[4:0] rs, rt, rd;
  wire[15:0] imm16;
  wire[31:0] imm32;
  wire[31:0] imm32sign;
  wire[31:0] imm32zero;
  wire[25:0] TargetInstr;
  wire[31:0] ALUout;
  wire[31:0] ALUopB;
  wire[4:0] Aw;
  wire[31:0] Dw;
  wire[31:0] Da, Db;
  wire[31:0] Dout;

  // Instruction breakdown
  assign rs = Instruction[25:21];
  assign rt = Instruction[20:16];
  assign rd = Instruction[15:11];
  assign imm16 = Instruction[15:0];
  assign TargetInstr = Instruction[25:0];

  // Extended Immediate
  assign imm32sign = {{16{imm16[15]}}, imm16};  
  assign imm32zero = {{16{1'b0}}, imm16};
  Mux2to1 immExtenderMux (imm32, ExtendMethod, imm32sign, imm32zero);

  // ALU sourceB
  Mux3to1 ALUsrcBMux (ALUopB, ALUscr, imm32, PC32, Db);

  // Register file write address
  Mux2to1 #(5) AwMux (Aw, RegDst, rt, rd);

  // Register file data input
  Mux2to1 DwMux (Dw, MemToReg, ALUout, Dout);


  regfile RegFile (Da, Db, Dw, rs, rt, Aw, RegWr, clk, answer); 
  ALU ALU (ALUout, ALUcarryout, ALUzero, ALUoverflow, Da, ALUopB, ALUcntrl);
  DataMemory DataMem (clk, MemWr, ALUout, Db, Dout);
  IFU IFU (clk, Jump, TargetInstr, JumpReg, ALUout, Branch, imm16, Zero, InvZero, PC, Instruction);
  InstructionDecoder InstrDec (clk, Instruction, ExtendMethod, RegDst, RegWr, ALUsrc, Branch, Jump, ALUcntrl, MemWr, MemToReg, JumpReg, InvZero);

endmodule
