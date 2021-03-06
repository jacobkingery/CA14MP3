module register(q, d, wrenable, clk);
input [31:0] d;
input wrenable;
input clk;
output reg [31:0] q;
initial q = 32'b0;

always @(posedge clk) begin
	if(wrenable) begin
		q = d;
	end
end

endmodule
