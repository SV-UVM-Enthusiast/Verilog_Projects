vlog tb.v
vsim tb +testname=test_empty
add wave -position insertpoint sim:/tb/dut/*
run -all

