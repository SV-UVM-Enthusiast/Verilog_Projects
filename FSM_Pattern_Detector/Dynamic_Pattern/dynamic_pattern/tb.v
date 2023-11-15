`include "dynamic.v"
module tb;
reg clk,rst,d_i,v_i;
wire pattern_detect;
integer count,seed;

dynamic_pattern dut(clk,rst,d_i,v_i,pattern_detect);

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
  @(posedge clk);
  d_i = 0;
  v_i=1;
  repeat(100)begin
  @(posedge clk);
  d_i = $random(seed);
  v_i=1;
 end
  @(posedge clk); 
  d_i=0;
  v_i=0;
  #50;
  $display("count=%0d",count);
  $finish;
  end
  always@(posedge pattern_detect)count=count+1;
  endmodule
