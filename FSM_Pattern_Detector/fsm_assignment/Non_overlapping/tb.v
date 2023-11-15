`include "pattern_detect.v"
module tb;
reg clk,rst,d_i,valid_i;
wire pattern;
integer count,seed;

pattern_detect dut(clk,rst,pattern,d_i,valid_i);

always begin
clk=0; #5;
clk=1; #5;
end
  initial begin
  count = 0;
  seed = 123456;
  rst=1;
  #20;
  rst=0;
   repeat(500)begin
  @(posedge clk);
  d_i = $random(seed);
  valid_i=1;
  end
  @(posedge clk)begin
  d_i=0;
  valid_i=0;
  #50;
  $display("count=%0d",count);
  $finish;
   end
   end
   always@(posedge pattern)count=count+1;
  endmodule

