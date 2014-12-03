module memory(clk, regWE, Addr, DataIn, DataOut);
  input clk, regWE;
  input[29:0] Addr;
  input[31:0] DataIn;
  output[31:0] DataOut;
 
reg [31:0] mem[1023:0]; 
always @(posedge clk)
  if (regWE)
    mem[Addr] <= DataIn;

initial $readmemh("program_hex.dat", mem);

assign DataOut = mem[Addr];
endmodule

module testMemory;
reg clk, regWE;
reg[29:0] PC;
reg [31:0] DataIn; 
wire[31:0] DataOut;

initial regWE=0;
initial DataIn=0;
initial PC=0;

initial clk=0;
always #100 clk = !clk;

memory instrMem (clk, regWE, PC, DataIn, DataOut);

// Flags set by instruction decoder
reg Jump;
initial Jump=0;
reg Branch;
initial Branch=0;
reg InvZero;
initial InvZero=0;
reg JumpReg;
initial JumpReg=0;


reg[25:0] TargetInstr;
initial TargetInstr=0; // from opcode
reg[15:0] imm16;
initial imm16=2; // from opcode
reg Zero;
initial Zero=0; // from ALU
reg[31:0] JumpTo;
initial JumpTo=0; // a multiple of 4, from $ra

always @(posedge clk) begin
  if (Jump) begin
    // jump to given target, assuming same first 4 bits
    PC <= {PC[29:26], TargetInstr};
  end else if (JumpReg) begin
    // jump to the value in the jump return register, divided by 4
    PC <= JumpTo[31:2];
  end else begin
    if (Branch & (Zero ^ InvZero)) begin
      // sign extend immediate and add to PC (plus 1)
      PC <= PC + {{14{imm16[15]}}, imm16} + 1;
    end else begin
      // increment PC
      PC <= PC + 1;
    end
  end
end

// Expected PC sequence is as follows:
// 0, 1, 2, 0, 1, 9, 10, 1, 2, 2, 3, 4, 5, 9, 10, 14, 15
initial begin
  #310
  Jump=1;
  TargetInstr=0;
  #200
  Jump=0;
  #200
  Jump=1;
  TargetInstr=9;
  #200
  Jump=0;
  #200
  JumpReg=1;
  JumpTo=4;
  #200
  JumpReg=0;
  #200
  JumpReg=1;
  JumpTo=8;
  #200
  JumpReg=0;
  #200
  Branch=1;
  imm16=3;
  Zero=0;
  InvZero=0;
  #200
  Branch=0;
  #200
  Branch=1;
  InvZero=1;
  #200
  Branch=0;
  #200
  Branch=1;
  InvZero=0;
  Zero=1;
  #200
  InvZero=1;
end

endmodule