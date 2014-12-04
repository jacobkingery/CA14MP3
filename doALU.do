vlog -reportprogress 300 -work work ALU_test-all.v
vsim -voptargs="+acc" testALU
add wave -position insertpoint \
sim:/testALU/A \
sim:/testALU/B \
sim:/testALU/command \
sim:/testALU/res \
sim:/testALU/Cout \
sim:/testALU/zero \
sim:/testALU/ovfl 
run -all
wave zoom full
