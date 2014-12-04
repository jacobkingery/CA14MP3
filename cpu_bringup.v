module CPU_bringup (clk, ALUout);
input clk;
output[31:0] ALUout;

CPU cpu (clk, ALUout);
endmodule
