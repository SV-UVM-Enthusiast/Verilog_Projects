vlog mem_tb.v
vsim tb
add wave -position insertpoint sim:/tb/*
run -all
