vlog tb.v  
vsim tb -l comp.log
add wave -position insertpoint sim:/tb/*
run -all
