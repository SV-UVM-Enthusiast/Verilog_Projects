module dff(clk,rst,d,q);
input clk,rst,d;
output reg q;
    
	always@(posedge clk)begin
	if(rst==1)q=0;
	else q=d;

	end
endmodule
   module upcounter(clk, rst, count);
   input clk,rst;
   output [2:0] count;
   wire d0,d1,d2;
 assign d0 = ~count[0];
 assign d1 = count[0] ^ count[1];
 assign d2 = ~count[1] & count[2] | ~count[0] & count[2] | ~count[2] & count[1] & count[0];

 dff g1(clk, rst, d2, count[2]);
 dff g2(clk, rst, d1, count[1]);
 dff g3(clk, rst, d0, count[0]);
 endmodule
