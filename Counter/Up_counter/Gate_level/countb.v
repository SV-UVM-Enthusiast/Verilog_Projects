`include "upcount.v"
module tb;
reg clk,rst;
wire [2:0]count;

upcounter dut(clk,rst,count);

initial begin
forever begin
clk=0;
#5;
clk=1;
#5;
end
end

initial begin
rst=1;
#10;
rst=0;
$monitor("count=%0d",count);
#500
$finish;
end
endmodule
