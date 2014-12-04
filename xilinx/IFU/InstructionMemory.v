module memory(clk, regWE, Addr, DataIn, DataOut);
  input clk, regWE;
  input[29:0] Addr;
  input[31:0] DataIn;
  output reg[31:0] DataOut;
 
  reg [31:0] mem[1023:0]; 
  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
    end
    DataOut <= mem[Addr];
  end

  initial $readmemh("program_hex.dat", mem);

endmodule
