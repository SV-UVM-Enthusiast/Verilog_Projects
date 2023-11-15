`timescale 1ns/1ns
`include"downcount.v"
module tb;
reg clk,rst;
wire [3:0]count;

down dut(clk,rst,count);

initial begin
	forever begin
		clk=0; #5;
		clk=1; #5;
	end
end
initial begin
	rst=1;
	#10;
	rst=0;
	$monitor("count=%0d",count);
	#800;
	$finish;
end
endmodule
