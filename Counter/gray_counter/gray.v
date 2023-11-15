module gray(clk,rst,count);
parameter MSB=3,LSB=0;
input clk,rst;
output reg [MSB:LSB]count;
reg [MSB:LSB]a;

  always@(posedge clk)begin
   if(rst==1) begin
     count <= 0;
	 a <= 0;
	 end
	 else begin
	 a <= a+1;
	count[MSB] <= a[MSB];
	count <= {a[MSB],a[MSB:LSB+1]^a[MSB-1:LSB]};
  end
 end
endmodule
