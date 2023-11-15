`include "dff.v"
module tb;
reg clk,rst,d;
wire q,q_bar;
integer seed;
dff dut(clk,rst,d,q,q_bar);

always begin
	clk = 0; #5;
	clk = 1; #5;
end

initial begin
	seed = 123456;
	rst = 1;
	#20;
	rst = 0;
		repeat(20)begin
			@(posedge clk);
			d = $random(seed);
			#50;
			$monitor("%t,d=%b,rst=%b,q=%b,q_bar=%b",$time,d,rst,q,q_bar);
		end
end
initial begin
	#1000;
	$finish;
end
endmodule
