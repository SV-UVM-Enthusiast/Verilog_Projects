`timescale 1ns/1ns
`include "pattern_det.v"
module tb;
reg clk,rst,d_i,valid_i;
wire pattern;
integer count,seed;

pattern_det dut(clk,rst,d_i,valid_i,pattern);
always begin
 clk=0; #5;
 clk=1; #5;
end

initial begin
seed = 123456;
count = 0;
rst=1;
#20;
rst=0;
repeat(540)begin
@(posedge clk);
d_i=$random(seed);
valid_i=1;
end
@(posedge clk);
d_i=0;
valid_i=0;
#50;
$display("count=%0d",count);
$finish;
end
always@(posedge pattern)count=count+1;
endmodule
