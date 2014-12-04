vlog -reportprogress 300 -work work cpu.v Muxes.v \
RegFile/regfile.v RegFile/decoder1to32.v RegFile/mux32to1by32.v \
RegFile/register32zero.v RegFile/register.v ALU.v DataMemory.v \
InstructionFetchUnit.v InstructionDecoder.v 
vsim -voptargs="+acc" testCPU
add wave -position insertpoint \
sim:/testCPU/CPU/clk \
sim:/testCPU/CPU/PC \
sim:/testCPU/CPU/Instruction \
sim:/testCPU/CPU/answer \
sim:/testCPU/CPU/RegFile/done \
sim:/testCPU/CPU/RegFile/sp 
run 550000
wave zoom full