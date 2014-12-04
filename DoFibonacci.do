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
sim:/CPU/RegFile/done \
sim:/CPU/RegFile/a0 \
sim:/CPU/RegFile/sp \
sim:/CPU/RegFile/ra \
sim:/CPU/ALUout \
sim:/CPU/DataMem/mem0 \
sim:/CPU/DataMem/mem1 \
sim:/CPU/DataMem/mem2 \
sim:/CPU/DataMem/mem3 \
sim:/CPU/DataMem/mem4 \
sim:/CPU/DataMem/mem5 \
sim:/CPU/DataMem/mem6 
run 10000
wave zoom full