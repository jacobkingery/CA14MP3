vlog -reportprogress 300 -work work InstructionFetchUnit.v
vsim -voptargs="+acc" testIFU
add wave -position insertpoint \
sim:/testIFU/clk \
sim:/testIFU/PC \
sim:/testIFU/Instruction
run 3200
wave zoom full