//1KB= 1024*8, WIDTH 32, 256 DEPTH
`timescale 1ns/1ns
`include "memory.v"
module tb;

parameter WIDTH=32;
parameter DEPTH=256;
parameter ADDRE=8;

reg clk_i,rst_i,valid_i,wrdata_i;
reg [ADDRE-1:0]addre_i;
reg [WIDTH-1:0]write_i;
wire ready_o;
wire [WIDTH-1:0]read_o;
integer i;

memory #(.WIDTH(WIDTH),.DEPTH(DEPTH),.ADDRE(ADDRE))dut(clk_i,rst_i,read_o,write_i,valid_i,wrdata_i,ready_o,addre_i);

always begin
clk_i=0; #5;
clk_i=1; #5;
end
       initial begin
	   rst_i=1;
	   #5;
	   rst_i=0;
	    write_memory(0,DEPTH/4);
		read_memory(0,DEPTH/4);

	    write_memory(DEPTH/4,DEPTH/4);
		read_memory(DEPTH/4,DEPTH/4);

	    write_memory(DEPTH/2,DEPTH/4);
		read_memory(DEPTH/2,DEPTH/4);

	    write_memory(3*DEPTH/4,DEPTH/4);
		read_memory(3*DEPTH/4,DEPTH/4);
		$finish;
	   end
      
	  task write_memory(input [ADDRE-1:0]start_loc,input [ADDRE:0]num_loc);
	  begin
		for(i=start_loc;i<start_loc+num_loc;i=i+1)begin
	    @(posedge clk_i);
		addre_i=i;
		write_i=$random;
		wrdata_i=1;
		valid_i=1;
		wait (ready_o==1);
		end
		@(posedge clk_i);
		addre_i=0;
		wrdata_i=0;
		write_i=0;
		valid_i=0;
		end
	  endtask

	  task read_memory(input [ADDRE-1:0]start_loc,input[ADDRE:0]num_loc);
	  begin
		for(i=start_loc;i<start_loc+num_loc;i=i+1)begin
	    @(posedge clk_i);
		addre_i=i;
		wrdata_i=0;
		valid_i=1;
		wait (ready_o==1);
		end
		@(posedge clk_i);
		addre_i=0;
		wrdata_i=0;
		valid_i=0;
		end
	  endtask

	  endmodule
