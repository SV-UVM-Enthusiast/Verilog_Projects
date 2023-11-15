module dff(clk,rst,d,q,q_bar);
input clk,rst,d;
output reg q,q_bar;

always@(posedge clk)begin
  if(rst==1)begin
     q<=0;
	 q_bar<=0;
	 end
	 else begin
	 q<=d;
	 q_bar<=~q;
end
	 end
	 endmodule
