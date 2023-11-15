//pattern 10110, mealy, overlapping, using one-hot encoding 

module pattern_detect(clk,rst,pattern,d_i,valid_i);
input clk,rst,d_i,valid_i;
output reg pattern;

parameter S_RST = 4'b00001;
parameter S_1 = 4'b00010;
parameter S_10 = 4'b00100;
parameter S_101 = 4'b01000;
parameter S_1011 = 4'b10000;

reg [3:0]state,next_state;

always@(posedge clk)begin
if(rst==1)begin
pattern = 0;
state = S_RST;
next_state = S_RST;
end
else begin
  pattern = 0;
  if(valid_i==1)begin
  case(state)
  S_RST:begin
  if(d_i==1)next_state=S_1;
  else next_state=S_RST;
  end
  S_1:begin
  if(d_i==1)next_state=S_1;
  else next_state=S_10;
  end
  S_10:begin
  if(d_i==1)next_state=S_101;
  else next_state=S_RST;
  end
  S_101:begin
  if(d_i==1)next_state=S_1011;
  else next_state=S_10;
  end
  S_1011:begin
  if(d_i==1)begin
  next_state=S_1;
  end
  else begin
  pattern = 1;
   next_state=S_10;
   end
   end
   endcase
    end
	end
end
	always@(next_state)state=next_state;
endmodule
