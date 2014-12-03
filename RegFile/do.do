vlog -reportprogress 300 -work work regfile.v hw4testbenchharness.v decoder1to32.v mux32to1by32.v register32zero.v register.v 
vsim -voptargs="+acc" hw4testbenchharness

add wave -position insertpoint  \
sim:/hw4testbenchharness/ReadData1 \
sim:/hw4testbenchharness/ReadData2 \
sim:/hw4testbenchharness/WriteData \
sim:/hw4testbenchharness/ReadRegister1 \
sim:/hw4testbenchharness/ReadRegister2 \
sim:/hw4testbenchharness/WriteRegister \
sim:/hw4testbenchharness/RegWrite \
sim:/hw4testbenchharness/Clk \
sim:/hw4testbenchharness/begintest \
sim:/hw4testbenchharness/endtest \
sim:/hw4testbenchharness/dutpassed
run -all

wave zoom full