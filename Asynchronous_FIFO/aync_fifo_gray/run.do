vlog tb.v
vsim tb +testname=test_full_error
add wave -position insertpoint sim:/tb/dut/*
run -all

