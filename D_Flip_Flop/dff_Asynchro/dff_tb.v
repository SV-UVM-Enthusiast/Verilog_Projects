`include "dff.v"
module tb;
reg clk,rst,d;
wire q;
integer seed;

	dff dut(clk,rst,d,q);

always begin
	clk = 0; #5;
	clk = 1; #5;
end
initial begin
	seed = 123456;
	rst = 1;
	#5;
	rst = 0;
		repeat(20)begin
			d = $random(seed);
			#50;
			rst = 1;
			#20;
			rst = 0;
			$monitor("%t,d=%b,rst=%b,q=%b",$time,d,rst,q);
		end
end
initial begin
	#100;
	$finish;
end
endmodule
