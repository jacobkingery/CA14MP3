vlog -reportprogress 300 -work work InstructionMemory.v
vsim -voptargs="+acc" testMemory
add wave -position insertpoint \
sim:/testMemory/clk \
sim:/testMemory/PC \
sim:/testMemory/DataOut
run 1000
wave zoom full