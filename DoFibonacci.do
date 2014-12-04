vlog -reportprogress 300 -work work cpu.v Muxes.v \
RegFile/regfile.v RegFile/decoder1to32.v RegFile/mux32to1by32.v \
RegFile/register32zero.v RegFile/register.v ALU_test-all.v DataMemory.v \
InstructionFetchUnit.v InstructionDecoder.v
vsim -voptargs="+acc" CPU
add wave -position insertpoint \
sim:/CPU/clk \
sim:/CPU/PC \
sim:/CPU/Instruction \
sim:/CPU/answer \
sim:/CPU/Jump
run 3200
wave zoom full