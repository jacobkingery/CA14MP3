module CPU;

  // Clock
  reg clk;
  initial clk=1;
  always #100 clk = !clk;

  // Answer
  wire[31:0] answer;

  // Control flags
  wire ExtendMethod, RegWr, Branch, Jump, MemWr, MemToReg, JumpReg, InvZero, DMAddrsrc;
  wire[1:0] ALUsrc, RegDst; 
  wire[2:0] ALUcntrl; 

  // Program Counter
  wire[29:0] PC;
  wire[31:0] PC32;
  assign PC32 = {{2{1'b0}}, PC};

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
  wire ALUzero;
  wire ALUoverflow;
  wire ALUcarryout;
  wire[31:0] ALUopB;
  wire[4:0] Aw;
  wire[31:0] Dw;
  wire[31:0] Da, Db;
  wire[31:0] Dout;
  wire[31:0] DMAddr;

  // Lab buffers
  reg[31:0] PCBuff;
  reg[31:0] ALUoutBuff;
  reg ZBuff;

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
  Mux3to1 ALUsrcBMux (ALUopB, ALUsrc, imm32, PCBuff, Db);

  // DataMem Addr
  Mux2to1 DataMemAddrMux (DMAddr, DMAddrsrc, ALUout, ALUoutBuff);

  // Register file write address
  Mux3to1 #(5) AwMux (Aw, RegDst, rt, rd, 5'd31);

  // Register file data input
  Mux2to1 DwMux (Dw, MemToReg, ALUout, Dout);


  regfile RegFile (Da, Db, Dw, rs, rt, Aw, RegWr, clk, answer); 
  ALU ALU (ALUout, ALUcarryout, ALUzero, ALUoverflow, Da, ALUopB, ALUcntrl, clk);
  DataMemory DataMem (clk, MemWr, DMAddr, Db, Dout);
  IFU IFU (clk, Jump, TargetInstr, JumpReg, ALUout, Branch, imm16, ZBuff, InvZero, PC, Instruction);
  InstructionDecoder InstrDec (clk, Instruction, ExtendMethod, RegDst, RegWr, ALUsrc, Branch, Jump, ALUcntrl, MemWr, MemToReg, DMAddrsrc, JumpReg, InvZero);

  always @(posedge clk) begin
    PCBuff <= PC32;
    ALUoutBuff <= ALUout;
    ZBuff <= ALUzero;
  end

endmodule
