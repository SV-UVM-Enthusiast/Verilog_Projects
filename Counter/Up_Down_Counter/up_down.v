module down(clk,rst,up_down,count);
input clk,rst,up_down;
parameter MSB=3,LSB=0;
output reg [MSB:LSB]count;

always@(posedge clk)begin
	if (rst==1)begin
	count=0;
	end
	else begin
		if (up_down==1)count=count+1;
		else count = count - 1;
    end

end
endmodule
