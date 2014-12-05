module register32zero(q, d, wrenable, clk);
input [31:0] d;
input wrenable;
input clk;
output reg [31:0] q;

// unneccissary!!
always @(posedge clk) begin
	q = 0;
end
endmodule
