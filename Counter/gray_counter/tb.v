`timescale 1ns/1ns
`include"gray.v"
module tb;
parameter MSB=3,LSB=0;
reg clk,rst;
wire [MSB:LSB]count;

gray #(.MSB(MSB),.LSB(LSB))dut(clk,rst,count);
always begin
	clk=0; #5;
	clk=1; #5;
end
initial begin
	rst=1;
	#10;
	rst=0;
	$monitor("count=%b",count);
	#400;
	$finish;
end
endmodule
