`timescale 1ns/1ps
`include "pattern_detect.v"
module tb;
reg clk,rst,d_i,valid_i;
wire pattern;
integer count;

pattern_detect dut(clk,rst,pattern,d_i,valid_i);

always begin
clk=0; #5;
clk=1; #5;
end
  initial begin
  count = 0;

  rst=1;
  #20;
  rst=0;
  repeat(100)begin
  @(posedge clk);
  d_i=$random;
  valid_i=1;
  end
 /* @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 0;
  valid_i=1;
  @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 0;
  valid_i=1;
  @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 0;
  valid_i=1;
  @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 1;
  valid_i=1;
  @(posedge clk);
  d_i = 0;
  valid_i=1;*/
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

