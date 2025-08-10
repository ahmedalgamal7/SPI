vlib work
vlog ram.v FSM.v wrapper.v wrapper_tb.v
vsim -voptargs=+acc work.wrapper_tb
add wave -position insertpoint  \
wrapper_tb/MOSI \
wrapper_tb/SS_n \
wrapper_tb/clk \
wrapper_tb/rst_n \
wrapper_tb/MISO
add wave -position insertpoint  \
wrapper_tb/DUT/slave/rx_valid \
wrapper_tb/DUT/slave/rx_data \
wrapper_tb/DUT/slave/cs \
wrapper_tb/DUT/slave/ns \
wrapper_tb/DUT/slave/temp \
wrapper_tb/DUT/slave/count_1 \
wrapper_tb/DUT/slave/count_2 \
wrapper_tb/DUT/slave/rx_data_temp
add wave -position insertpoint  \
wrapper_tb/DUT/memory/din
add wave -position insertpoint  \
wrapper_tb/DUT/memory/dout
add wave -position insertpoint  \
wrapper_tb/DUT/memory/mem
run -all
#quit -sim