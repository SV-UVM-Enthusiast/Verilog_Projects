`include "spi.v"
module tb;
parameter MAX_NUM_TXS = 8;
parameter S_IDLE = 3'b001;
parameter S_ADDR = 3'b010;
parameter S_DATA = 3'b100;
reg pclk_i, prst_i, penable_i, pwrite_i;
reg [7:0] paddr_i;
reg [7:0] pwdata_i; 
wire [7:0] prdata_o;
wire pready_o;
reg sclk_ref_i;
wire sclk_o;
wire mosi;
reg miso;
wire [3:0] cs;
integer i;
reg [7:0] data;
reg [2:0] state, next_state;
integer count;
reg [7:0] data_collect, addr_collect;

spi_ctrl dut(

pclk_i, prst_i, paddr_i, pwdata_i, prdata_o, pwrite_i, penable_i, pready_o, 

sclk_ref_i, sclk_o, mosi, miso, cs
);


initial begin
	pclk_i = 0;
	forever #5 pclk_i = ~pclk_i;
end

initial begin
	sclk_ref_i = 0;
	forever #1 sclk_ref_i = ~sclk_ref_i;
end

initial begin
	prst_i = 1;
	miso = 1;
	paddr_i = 0;
	pwdata_i = 0;
	pwrite_i = 0;
	penable_i = 0;
	data = 0;
	state = S_IDLE;
	next_state = S_IDLE;
	count = 0;
	data_collect=8'h0;
	addr_collect=8'h0;
	repeat(2) @(posedge pclk_i);
	prst_i = 0;
	for (i = 0; i < MAX_NUM_TXS; i=i+1) begin
		write_reg(i, 8'hd3+i); //53, 54, 55, so on
	end
	//data_regA
	for (i = 0; i < MAX_NUM_TXS; i=i+1) begin
		write_reg(8'h10+i, 8'h46+i); //46, 47, 48, so on
	end
	//ctrl_reg
	data = {4'b0, 3'h2, 1'b1}; 
	write_reg(8'h20, data);
	#300;
	//ctrl_reg: 2 txs
	data = {4'b0, 3'h1, 1'b1}; 
	write_reg(8'h20, data);
	#200;
	data = {4'b0, 3'h1, 1'b1}; 
	write_reg(8'h20, data);
	#500;
	$finish;
end

task write_reg(input reg [7:0] addr, input reg [7:0] data);
begin
		@(posedge pclk_i); 
		paddr_i = addr;
		pwdata_i = data;
		pwrite_i = 1;
		penable_i = 1;
		wait (pready_o == 1);
		@(posedge pclk_i);
		penable_i = 0;
		paddr_i = 0;
		pwdata_i = 0;
		pwrite_i = 0;
end
endtask

always @(posedge sclk_o) begin
case (state)
	S_IDLE : begin
		count = count + 1;
		if (count == 4) begin
			count = 0;
			addr_collect[count] = mosi;
			count = count + 1;
			next_state = S_ADDR;
		end
	end
	S_ADDR : begin
		addr_collect[count] = mosi;
		count = count + 1;
		if (count == 8) begin
			next_state = S_DATA;
			count = 0;
			$display("%t : addr_collect=%h", $time, addr_collect);
		end
	end
	S_DATA : begin
		data_collect[count] = mosi;
		count = count + 1;
		if (count == 8) begin
			next_state = S_ADDR;
			count = 0;
			$display("%t : data_collect=%h", $time, data_collect);
		end
	end
endcase
end

always @(next_state) state = next_state;

endmodule
