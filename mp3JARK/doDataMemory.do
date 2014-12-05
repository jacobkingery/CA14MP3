vlog -reportprogress 300 -work work DataMemory.v

vsim -voptargs="+acc" DataMemoryTestBench
run 1000
wave zoom full