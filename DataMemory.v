module DataMemory(clk, regWE, Addr, DataIn, DataOut);
  input clk, regWE;
  input[31:0] Addr;
  input[31:0] DataIn;
  output reg[31:0] DataOut;
 
  reg [31:0] mem[1023:0]; 
  always @(posedge clk) begin
  if (regWE)
    mem[Addr] <= DataIn;
  DataOut <= mem[Addr];
  end
endmodule