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
sim:/testCPU/CPU/RegFile/sp \
sim:/testCPU/CPU/RegFile/a0 \
sim:/testCPU/CPU/ALUout \
sim:/testCPU/CPU/Da \
sim:/testCPU/CPU/ALUopB \
sim:/testCPU/CPU/ALUzero \
sim:/testCPU/CPU/DataMem/mem1 \
sim:/testCPU/CPU/DataMem/mem2 \
sim:/testCPU/CPU/DataMem/mem3 \
sim:/testCPU/CPU/DataMem/mem4 \
sim:/testCPU/CPU/DataMem/mem5 \
sim:/testCPU/CPU/DataMem/mem6
run 550000
wave zoom full