
module regfile(ReadData1, // Contents of first register read
ReadData2, // Contents of second register read
WriteData, // Contents to write to register
ReadRegister1, // Address of first register to read
ReadRegister2, // Address of second register to read
WriteRegister, // Address of register to write
RegWrite, // Enable writing of register when High
Clk, // Clock (Positive Edge Triggered)
answer);
input [31:0] WriteData; // input data to write 
input [4:0] ReadRegister1; // addresses to read and write
input [4:0] ReadRegister2;
input [4:0] WriteRegister;
input RegWrite;
input Clk;


output [31:0] ReadData1;
output [31:0] ReadData2;

wire [31:0] mux_input0;
wire [31:0] mux_input1;
wire [31:0] mux_input2;
wire [31:0] mux_input3;
wire [31:0] mux_input4;
wire [31:0] mux_input5;
wire [31:0] mux_input6;
wire [31:0] mux_input7;
wire [31:0] mux_input8;
wire [31:0] mux_input9;
wire [31:0] mux_input10;
wire [31:0] mux_input11;
wire [31:0] mux_input12;
wire [31:0] mux_input13;
wire [31:0] mux_input14;
wire [31:0] mux_input15;
wire [31:0] mux_input16;
wire [31:0] mux_input17;
wire [31:0] mux_input18;
wire [31:0] mux_input19;
wire [31:0] mux_input20;
wire [31:0] mux_input21;
wire [31:0] mux_input22;
wire [31:0] mux_input23;
wire [31:0] mux_input24;
wire [31:0] mux_input25;
wire [31:0] mux_input26;
wire [31:0] mux_input27;
wire [31:0] mux_input28;
wire [31:0] mux_input29;
wire [31:0] mux_input30;
wire [31:0] mux_input31;

wire [31:0] register_write_enables;
decoder1to32 writeAddressDecoder(
.out (register_write_enables),
.enable (RegWrite), 
.address (WriteRegister));

register32zero Register0 (.q(mux_input0), .d(WriteData), .wrenable(register_write_enables[0]), .clk(Clk));
register Register1 (.q(mux_input1), .d(WriteData), .wrenable(register_write_enables[1]), .clk(Clk));
register Register2 (.q(mux_input2), .d(WriteData), .wrenable(register_write_enables[2]), .clk(Clk));
register Register3 (.q(mux_input3), .d(WriteData), .wrenable(register_write_enables[3]), .clk(Clk));
register Register4 (.q(mux_input4), .d(WriteData), .wrenable(register_write_enables[4]), .clk(Clk));
register Register5 (.q(mux_input5), .d(WriteData), .wrenable(register_write_enables[5]), .clk(Clk));
register Register6 (.q(mux_input6), .d(WriteData), .wrenable(register_write_enables[6]), .clk(Clk));
register Register7 (.q(mux_input7), .d(WriteData), .wrenable(register_write_enables[7]), .clk(Clk));
register Register8 (.q(mux_input8), .d(WriteData), .wrenable(register_write_enables[8]), .clk(Clk));
register Register9 (.q(mux_input9), .d(WriteData), .wrenable(register_write_enables[9]), .clk(Clk));
register Register10 (.q(mux_input10), .d(WriteData), .wrenable(register_write_enables[10]), .clk(Clk));
register Register11 (.q(mux_input11), .d(WriteData), .wrenable(register_write_enables[11]), .clk(Clk));
register Register12 (.q(mux_input12), .d(WriteData), .wrenable(register_write_enables[12]), .clk(Clk));
register Register13 (.q(mux_input13), .d(WriteData), .wrenable(register_write_enables[13]), .clk(Clk));
register Register14 (.q(mux_input14), .d(WriteData), .wrenable(register_write_enables[14]), .clk(Clk));
register Register15 (.q(mux_input15), .d(WriteData), .wrenable(register_write_enables[15]), .clk(Clk));
register Register16 (.q(mux_input16), .d(WriteData), .wrenable(register_write_enables[16]), .clk(Clk));
register Register17 (.q(mux_input17), .d(WriteData), .wrenable(register_write_enables[17]), .clk(Clk));
register Register18 (.q(mux_input18), .d(WriteData), .wrenable(register_write_enables[18]), .clk(Clk));
register Register19 (.q(mux_input19), .d(WriteData), .wrenable(register_write_enables[19]), .clk(Clk));
register Register20 (.q(mux_input20), .d(WriteData), .wrenable(register_write_enables[20]), .clk(Clk));
register Register21 (.q(mux_input21), .d(WriteData), .wrenable(register_write_enables[21]), .clk(Clk));
register Register22 (.q(mux_input22), .d(WriteData), .wrenable(register_write_enables[22]), .clk(Clk));
register Register23 (.q(mux_input23), .d(WriteData), .wrenable(register_write_enables[23]), .clk(Clk));
register Register24 (.q(mux_input24), .d(WriteData), .wrenable(register_write_enables[24]), .clk(Clk));
register Register25 (.q(mux_input25), .d(WriteData), .wrenable(register_write_enables[25]), .clk(Clk));
register Register26 (.q(mux_input26), .d(WriteData), .wrenable(register_write_enables[26]), .clk(Clk));
register Register27 (.q(mux_input27), .d(WriteData), .wrenable(register_write_enables[27]), .clk(Clk));
register Register28 (.q(mux_input28), .d(WriteData), .wrenable(register_write_enables[28]), .clk(Clk));
register Register29 (.q(mux_input29), .d(WriteData), .wrenable(register_write_enables[29]), .clk(Clk));
register Register30 (.q(mux_input30), .d(WriteData), .wrenable(register_write_enables[30]), .clk(Clk));
register Register31 (.q(mux_input31), .d(WriteData), .wrenable(register_write_enables[31]), .clk(Clk));

mux32to1by32 first_muxer (ReadData1, ReadRegister1, mux_input0, mux_input1, mux_input2, mux_input3, mux_input4, mux_input5, mux_input6, mux_input7, mux_input8, mux_input9, mux_input10, mux_input11, mux_input12, mux_input13, mux_input14, mux_input15, mux_input16, mux_input17, mux_input18, mux_input19, mux_input20, mux_input21, mux_input22, mux_input23, mux_input24, mux_input25, mux_input26, mux_input27, mux_input28, mux_input29, mux_input30, mux_input31);

mux32to1by32 second_muxer (ReadData2, ReadRegister2, mux_input0, mux_input1, mux_input2, mux_input3, mux_input4, mux_input5, mux_input6, mux_input7, mux_input8, mux_input9, mux_input10, mux_input11, mux_input12, mux_input13, mux_input14, mux_input15, mux_input16, mux_input17, mux_input18, mux_input19, mux_input20, mux_input21, mux_input22, mux_input23, mux_input24, mux_input25, mux_input26, mux_input27, mux_input28, mux_input29, mux_input30, mux_input31);

// Answer register
output[31:0] answer;
assign answer = mux_input3;

// Used to look at other important registers, will be optimized out in systhesis.
wire[31:0] done, a0, sp, ra;
assign done = mux_input9;
assign a0 = mux_input4;
assign sp = mux_input29;
assign ra = mux_input31;
endmodule
