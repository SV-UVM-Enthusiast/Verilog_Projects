`timescale 1ns/1ns
`include "fifo.v"
module tb;

reg rd_clk_i,wr_clk_i,rst_i,wr_en_i,rd_en_i;
parameter DEPTH=16, WIDTH=8, PTR_WIDTH=4;
parameter WR_CLK_TP=8,RD_CLK_TP=9;
parameter MAX_DELAY_WR=5,MAX_DELAY_RD=5;
parameter NUM_MAX=20;
wire wr_error_o,rd_error_o,full_o,empty_o;
reg [WIDTH-1:0]wdata_i;
wire [WIDTH-1:0]rdata_o;
integer j,k,p,q;
reg [30*8:1]testname;
integer wr_delay,read_delay;

fifo dut(.wr_clk_i(wr_clk_i),.rd_clk_i(rd_clk_i),.rst_i(rst_i),.wr_en_i(wr_en_i),.wdata_i(wdata_i),.wr_error_o(wr_error_o),.full_o(full_o),.rd_en_i(rd_en_i),.rdata_o(rdata_o),.empty_o(empty_o),.rd_error_o(rd_error_o));
always begin
wr_clk_i=0; #(WR_CLK_TP/2.0);
wr_clk_i=1; #(WR_CLK_TP/2.0);
end
always begin
rd_clk_i=0; #(RD_CLK_TP/2.0);
rd_clk_i=1; #(RD_CLK_TP/2.0);
end 
    initial begin
   	$value$plusargs("testname=%s",testname);
	rst_i=1;
	wdata_i=0;
	wr_en_i=0;
	rd_en_i=0;
	@(posedge wr_clk_i);
	rst_i=0;
	case(testname)
	"test_full":begin
	write_fifo(DEPTH);
	end
	"test_empty":begin
	write_fifo(DEPTH);
	read_fifo(DEPTH);
	end
	"test_full_error":begin
	write_fifo(DEPTH+1);
	read_fifo(DEPTH);
	end
	"test_empty_error":begin
	write_fifo(DEPTH);
	read_fifo(DEPTH+1);
	end
	"test_concurnt_rd_wr":begin
	fork
	begin
	     for(p=0;p<NUM_MAX;p=p+1)begin
		 write_fifo(1);
		 wr_delay= $urandom_range(1,MAX_DELAY_WR);
	     repeat(wr_delay)@(posedge wr_clk_i);
		 end
	end
	begin
	     for(q=0;q<NUM_MAX;q=q+1)begin
		 read_fifo(1);
		 read_delay=$urandom_range(1,MAX_DELAY_RD);
		 repeat(read_delay)@(posedge rd_clk_i);
		 end
	end
	join
	end
	endcase
	 #100;
	 $finish;
     end	
 
     
	 task write_fifo(input integer num_wr);
	 begin
     for(j=0;j<num_wr;j=j+1)begin
	 @(posedge wr_clk_i);
	 wr_en_i=1;
	 wdata_i=$random;
	 end
	 @(posedge wr_clk_i);
	 wr_en_i=0;
	 wdata_i=0;
	 end
	 endtask

     task read_fifo(input integer num_rd);
	 begin
	 for(k=0;k<num_rd;k=k+1)begin
	 @(posedge rd_clk_i);
	 rd_en_i=1;
	 end
	 @(posedge rd_clk_i);
	 rd_en_i=0;
	 end
	 endtask

endmodule
