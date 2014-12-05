


vlog -reportprogress 300 -work work InstructionDecoder.v

vsim -voptargs="+acc" InstructionDecoderTestBench
add wave -position insertpoint  \
sim:/InstructionDecoderTestBench/tester_instruction \
sim:/InstructionDecoderTestBench/tester_ExtendMethod \
sim:/InstructionDecoderTestBench/tester_RegDst \
sim:/InstructionDecoderTestBench/tester_RegWr \
sim:/InstructionDecoderTestBench/tester_ALUsrc \
sim:/InstructionDecoderTestBench/tester_Branch \
sim:/InstructionDecoderTestBench/tester_Jump \
sim:/InstructionDecoderTestBench/tester_ALUcntrl \
sim:/InstructionDecoderTestBench/tester_MemWr \
sim:/InstructionDecoderTestBench/tester_MemToReg \
sim:/InstructionDecoderTestBench/tester_JumpReg \
sim:/InstructionDecoderTestBench/tester_InvZero \

run -all
wave zoom full