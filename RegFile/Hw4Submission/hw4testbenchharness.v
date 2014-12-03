// Validates your hw4testbench by connecting it to various functional 
// or broken register files and verifying that it correctly identifies 
module hw4testbenchharness;
wire[31:0]	ReadData1;
wire[31:0]	ReadData2;
wire[31:0]	WriteData;
wire[4:0]	ReadRegister1;
wire[4:0]	ReadRegister2;
wire[4:0]	WriteRegister;
wire		RegWrite;
wire		Clk;
reg		begintest;

// The register file being tested.  DUT = Device Under Test
regfile DUT(ReadData1,ReadData2,WriteData, ReadRegister1, ReadRegister2,WriteRegister,RegWrite, Clk);

// The test harness to test the DUT
hw4testbench tester(begintest, endtest, dutpassed,ReadData1,ReadData2,WriteData, ReadRegister1, ReadRegister2,WriteRegister,RegWrite, Clk);


initial begin
begintest=0;
#10;
begintest=1;
#1000;
end

always @(posedge endtest) begin
$display(dutpassed);
end

endmodule

// This is your actual test bench.
// It generates the signals to drive a registerfile and passes it back up one layer to the harness
//	((This lets us plug in various working / broken registerfiles to test
// When begintest is asserted, begin testing the register file.
// When your test is conclusive, set dutpassed as appropriate and then raise endtest.
module hw4testbench(begintest, endtest, dutpassed,
		    ReadData1,ReadData2,WriteData, ReadRegister1, ReadRegister2,WriteRegister,RegWrite, Clk);
output reg endtest;
output reg dutpassed;
input	   begintest;

input[31:0]		ReadData1;
input[31:0]		ReadData2;
output reg[31:0]	WriteData;
output reg[4:0]		ReadRegister1;
output reg[4:0]		ReadRegister2;
output reg[4:0]		WriteRegister;
output reg		RegWrite;
output reg		Clk;

initial begin
WriteData=0;
ReadRegister1=0;
ReadRegister2=0;
WriteRegister=0;
RegWrite=0;
Clk=0;
end

always @(posedge begintest) begin
endtest = 0;
dutpassed = 1;
#10

// Test Case 1: Write to 42 register 2, verify with Read Ports 1 and 2
// This will pass because the example register file is hardwired to always return 42.
WriteRegister = 2;
WriteData = 42;
RegWrite = 1;
ReadRegister1 = 2;
ReadRegister2 = 2;
#5 Clk=1; #5 Clk=0;	// Generate Clock Edge
if(ReadData1 != 42 || ReadData2!= 42) begin
	dutpassed = 0;
	$display("Test Case 1 Failed");
	end

// Test Case 2: Write to 15 register 2, verify with Read Ports 1 and 2
// This will fail with the example register file, but should pass with yours.
WriteRegister = 2;
WriteData = 15;
RegWrite = 1;
ReadRegister1 = 2;
ReadRegister2 = 2;
#5 Clk=1; #5 Clk=0;
if(ReadData1 != 15 || ReadData2!= 15) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 2 Failed");
	end

// Test Case 3: Write register is broken and always written to.
WriteRegister = 6;
WriteData = 15;
RegWrite = 1;
ReadRegister1 = 2;
ReadRegister2 = 2;
#5 Clk=1; #5 Clk=0;

WriteRegister = 6;
WriteData = 17;
RegWrite = 0;
ReadRegister1 = 6;
ReadRegister2 = 6;
#5 Clk=1; #5 Clk=0;

if(ReadData1 != 15 || ReadData2!= 15) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 3 Failed");
	end


// Test Case 4: decoder is broken, all registers are written to
WriteRegister = 5;
WriteData = 15;
RegWrite = 1;
ReadRegister1 = 2;
ReadRegister2 = 2;
#5 Clk=1; #5 Clk=0;

WriteRegister = 6;
WriteData = 17;
RegWrite = 1;
ReadRegister1 = 5;
ReadRegister2 = 6;
#5 Clk=1; #5 Clk=0;


if(ReadData1 != 15 || ReadData2!= 17) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 4 Failed");
	end



// Test Case 5: Register Zero is actually a register
WriteRegister = 0;
WriteData = 15;
RegWrite = 1;
ReadRegister1 = 0;
ReadRegister2 = 0;
#5 Clk=1; #5 Clk=0;
if(ReadData1 != 0 || ReadData2!= 0) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 5 Failed");
	end



// Test Case 6: port 2 always reads register 17
WriteRegister = 17;
WriteData = 17;
RegWrite = 1;
ReadRegister1 = 2;
ReadRegister2 = 2;
#5 Clk=1; #5 Clk=0;

WriteRegister = 15;
WriteData = 15;
RegWrite = 1;
ReadRegister1 = 15;
ReadRegister2 = 15;
#5 Clk=1; #5 Clk=0;

if(ReadData1 != 15 || ReadData2!= 15) begin
	dutpassed = 0;	// On Failure, set to false.
	$display("Test Case 6 Failed");
	end

//We're done!  Wait a moment and signal completion.
#5
endtest = 1;
end

endmodule
