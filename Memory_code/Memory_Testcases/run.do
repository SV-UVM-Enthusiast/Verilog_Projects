vlog mem_tb.v
vsim tb +testname=fd_wr_fd_rd
add wave -position insertpoint sim:/tb/*
run -all
