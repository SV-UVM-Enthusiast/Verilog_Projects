`include "dff.v"
module upcounter(clk, rst, count);
   input clk,rst;
   output [2:0] count;

and g1(p1,~count[0],count[2]);
and g2(p2,~count[1],count[2]);
and g3(p3,~count[2],count[0],count[1]);
or g4(n2,p1,p2,p3);
xor g5(n1,count[1],count[0]);
buf g6(n0,~count[0]);

 dff d2(clk, rst, n2, count[2]);
 dff d1(clk, rst, n1, count[1]);
 dff d0(clk, rst, n0, count[0]);
 endmodule
