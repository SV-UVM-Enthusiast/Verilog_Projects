`timescale 1ns/1ns
`include "fifo.v"
module tb;
parameter DEPTH=16, WIDTH=8, PTR_WIDTH=4;

reg clk_i,rst_i,wr_en_i,rd_en_i;
wire wr_error_o,rd_error_o,full_o,empty_o;
reg [WIDTH-1:0]wdata_i;
wire [WIDTH-1:0]rdata_o;
integer i;

fifo dut(.clk_i(clk_i),.rst_i(rst_i),.wr_en_i(wr_en_i),.wdata_i(wdata_i),.wr_error_o(wr_error_o),.full_o(full_o),.rd_en_i(rd_en_i),.rdata_o(rdata_o),.empty_o(empty_o),.rd_error_o(rd_error_o));
always begin
clk_i=0; #5;
clk_i=1; #5;
end
    initial begin
	rst_i=1;
	wdata_i=0;
	rd_en_i=0;
	wr_en_i=0;
    @(posedge clk_i); 
	rst_i=0;
	write_fifo(DEPTH);
	read_fifo(DEPTH+1);
	 #100;
	 $finish;
     end	

	 task write_fifo(input integer num_wr);
	 begin
     for(i=0;i<num_wr;i=i+1)begin
	 @(posedge clk_i);
	 wr_en_i=1;
	 wdata_i=$random;
	 end
	 @(posedge clk_i);
	 wr_en_i=0;
	 wdata_i=0;
	 end
	 endtask

     task read_fifo(input integer num_rd);
	 begin
	 for(i=0;i<num_rd;i=i+1)begin
	 @(posedge clk_i);
	 rd_en_i=1;
	 end
	 @(posedge clk_i);
	 rd_en_i=0;
	 end
	 endtask
endmodule
