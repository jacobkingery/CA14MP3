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

reg Jump;
initial Jump=1;
reg[25:0] TargetInstr;
initial TargetInstr=0;

always @(posedge clk) begin
  if (Jump) begin
    PC={PC[29:26], TargetInstr};
  end else begin
    if (Branch && Zero) begin
      // sign extend immediate and add to PC
    end else begin
      PC=PC+1;
    end
  end
end

initial begin
  #110
  Jump=0;
end

endmodule