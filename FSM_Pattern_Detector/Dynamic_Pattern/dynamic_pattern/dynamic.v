//dynamic non-overlapping pattern detector 
module dynamic_pattern(clk,rst,d_i,v_i,pattern_detect);
input clk,rst,v_i,d_i;
output reg pattern_detect;
reg [4:0] pattern_to_detect,current_pattern;
integer count;

initial begin
	pattern_to_detect = 5'b01101;
end
   always@(posedge clk)begin
   if(rst==1)begin
   pattern_detect = 0;
   count = 0;
   end
     else begin
	  if(v_i==1)begin
	  pattern_detect = 0;
	  current_pattern={current_pattern[3:0],d_i};
	  count = count+1;
	     if(count==5)begin
				if(current_pattern==pattern_to_detect)begin
				pattern_detect=1;
				count=0;
				end
				else begin
				pattern_detect=0;
				count = count - 1;
                end
				end
		 end
	  end
	  end
endmodule
