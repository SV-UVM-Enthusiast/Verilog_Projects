`timescale 1ns/1ns
`include"up_down.v"
module tb;
reg clk,rst,up_down;
parameter MSB=2,LSB=0;
wire [MSB:LSB]count;

down #(.MSB(MSB),.LSB(LSB)) dut(clk,rst,up_down,count);

always begin
	clk=0;
	#5;
	clk=1;
	#5;
end

initial begin
	rst=1;
	#10;
	rst=0;
	$monitor("count=%0d",count);
	@(posedge clk);
	up_down=0;
	#200;
	up_down=1;
	#200;
	$finish;
end
endmodule
