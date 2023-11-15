module dff(clk,rst,d,q);
input clk,rst,d;
output reg q;

always@(posedge clk or posedge rst)begin
  if(rst==1)begin
     q<=0;
	 end
	 else begin
	 q<=d;
end
	 end
	 endmodule
