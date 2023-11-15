//Moore machine pattern : BBCBC using one-hot encoding
module pattern_det(clk,rst,d_i,valid_i,pattern);

parameter S_RESET = 5'b000001;
parameter S_B = 5'b000010;
parameter S_BB = 5'b000100;
parameter S_BBC = 5'b001000;
parameter S_BBCB = 5'b010000;
parameter S_BBCBC = 5'b100000;
parameter B = 1'b1;
parameter c = 1'b0;

input clk,rst,d_i,valid_i;
output reg pattern;
reg [5:0]state,next_state;

    always@(posedge clk)begin
    if(rst==1)begin 
     pattern = 0;
     state = S_RESET;
     next_state = S_RESET;
	 end
		else begin
		pattern = 0;
		if(valid_i==1)begin
		case(state)
            S_RESET:begin 
		   if(d_i==B)next_state=S_B;
		  else next_state=S_RESET;
		  end
		  S_B:begin
		  if(d_i==B)next_state=S_BB;
		  else next_state=S_RESET;
		  end
		  S_BB:begin
		  if(d_i==B)next_state=S_BB;
		  else next_state=S_BBC;
		  end
		  S_BBC:begin
		  if(d_i==B)next_state=S_BBCB;
		  else next_state=S_RESET;
		  end
		  S_BBCB:begin
		  if(d_i==B)next_state=S_B;
		  else next_state=S_BBCBC;
		  end
		  S_BBCBC:begin
		  pattern = 1;
		  if(d_i==B)next_state=S_B;
		  else next_state=S_RESET;
		  end 
		    default:begin
			$display("Error condition");
			next_state=S_RESET;
			end
		  endcase
		  end
		  end
		  end
		  always@(next_state)state=next_state;
		  endmodule
