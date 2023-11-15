//1KB memory
// 1024*8=8192,32 bit width, 256 depth
module memory(clk_i,rst_i,read_o,write_i,valid_i,wrdata_i,ready_o,addre_i);
parameter WIDTH=32;
parameter DEPTH=256;
parameter ADDRE=8;

input clk_i,rst_i,valid_i,wrdata_i;
input [ADDRE-1:0]addre_i;
input [WIDTH-1:0]write_i;
output reg ready_o;
output reg [WIDTH-1:0]read_o;
integer i;
reg [WIDTH-1:0]mem[DEPTH-1:0];

    always@(posedge clk_i)begin
	if(rst_i==1)begin
	read_o=0;
	ready_o=0;
	for(i=0;i<DEPTH;i=i+1)begin
	mem[i]=0;
	end
	end
	    else begin
		if(valid_i==1)begin
		ready_o=1;
		     if(wrdata_i==1)mem[addre_i]=write_i;
			 else read_o=mem[addre_i];
          end
		  else begin
		  ready_o=0;
		  end
		end
	end
endmodule
