module DataMemory(clk, regWE, Addr, DataIn, DataOut);
  input clk, regWE;
  input[31:0] Addr;
  input[31:0] DataIn;
  output[31:0] DataOut;

  wire[9:0] OffsetAddr;
  assign OffsetAddr = 1023 - (32'h3ffc - Addr)/4;
 
  reg [31:0] mem[1023:0]; 
  always @(posedge clk) begin
    if (regWE)
      mem[OffsetAddr] <= DataIn;
  end
  assign DataOut = mem[OffsetAddr];

  // For looking into the memory, will be optimized out in synthesis
  wire[31:0] mem0, mem1, mem2, mem3, mem4, mem5, mem6;  
  assign mem0 = mem[1023];
  assign mem1 = mem[1022];
  assign mem2 = mem[1021];
  assign mem3 = mem[1020];
  assign mem4 = mem[1019];
  assign mem5 = mem[1018];
  assign mem6 = mem[1017];
endmodule