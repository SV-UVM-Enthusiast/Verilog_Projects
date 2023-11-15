module spi_ctrl(

pclk_i, prst_i, paddr_i, pwdata_i, prdata_o, pwrite_i, penable_i, pready_o, 

sclk_ref_i, sclk_o, mosi, miso, cs
);
parameter S_IDLE = 5'b00001;
parameter S_ADDR = 5'b00010;
parameter S_IDLE_BW_ADDR_DATA = 5'b00100;
parameter S_DATA = 5'b01000;
parameter S_IDLE_WITH_TXS_PENDING = 5'b10000;
parameter MAX_NUM_TXS = 8;

input pclk_i, prst_i, penable_i, pwrite_i;
input [7:0] paddr_i;
input [7:0] pwdata_i; 
output reg [7:0] prdata_o;
output reg pready_o;
input sclk_ref_i;
output sclk_o;
output reg mosi;
input miso;
output reg [3:0] cs;

reg [4:0] state, next_state;
reg sclk_gated_f;
integer i;
reg [2:0] cur_tx_idx;
reg [3:0] num_txs_pending;
integer count;
reg [7:0] addr_to_drive;
reg [7:0] data_to_drive;
reg [7:0] data_collect; 


reg [7:0] addr_regA[MAX_NUM_TXS-1:0]; 
reg [7:0] data_regA[MAX_NUM_TXS-1:0]; 
reg [7:0] ctrl_reg; //'h20

//how many processes: 2 processes
	//1. programming the registers
	//2. doing SPI tx

//programming the registers
always @(posedge pclk_i) begin
if (prst_i == 1) begin
	prdata_o = 0;
	pready_o = 0;
	state = S_IDLE;
	next_state = S_IDLE;
	sclk_gated_f = 1;
	cs = 4'b1;
	cur_tx_idx = 0;
	num_txs_pending = 0;
	addr_to_drive = 0;
	data_to_drive = 0;
	count = 0;
	for (i = 0; i < MAX_NUM_TXS; i=i+1) begin
		addr_regA[i] = 0;
		data_regA[i] = 0;
	end
	ctrl_reg = 0;
	mosi = 1;
	data_collect = 0;
end
else begin
	if (penable_i == 1) begin
		pready_o = 1;
		//write registers
		if (pwrite_i == 1) begin
			if (paddr_i >= 8'h0 && paddr_i <= 8'h7) 	addr_regA[paddr_i] = pwdata_i;
			if (paddr_i >= 8'h10 && paddr_i <= 8'h17)   data_regA[paddr_i-8'h10] = pwdata_i;
			if (paddr_i == 8'h20)                       ctrl_reg[3:0] = pwdata_i[3:0]; 
		end
		//read registers
		else begin
			if (paddr_i >= 8'h0 && paddr_i <= 8'h7) 	prdata_o = addr_regA[paddr_i];
			if (paddr_i >= 8'h10 && paddr_i <= 8'h17)   prdata_o = data_regA[paddr_i-8'h10];
			if (paddr_i == 8'h20)                       prdata_o = ctrl_reg;
		end
	end
	else begin
		pready_o = 0;
	end
end
end

//2. doing SPI tx
always @(posedge sclk_ref_i) begin
if (prst_i == 0) begin
	case (state)
		S_IDLE: begin
			mosi = 1;
			sclk_gated_f = 1; //clock is not running	
			addr_to_drive = 0;
			data_to_drive = 0;
			count = 0;
			if (ctrl_reg[0]) begin
				next_state = S_ADDR;
				cur_tx_idx = ctrl_reg[6:4];
				num_txs_pending = ctrl_reg[3:1] + 1;
				count = 0;
				addr_to_drive = addr_regA[cur_tx_idx];
				data_to_drive = data_regA[cur_tx_idx];
			end
		end
		S_ADDR : begin
			sclk_gated_f = 0;
			mosi = addr_to_drive[count];
			count = count + 1; 
			if (count == 8) begin
				next_state = S_IDLE_BW_ADDR_DATA;
				count = 0;
			end
		end
		S_IDLE_BW_ADDR_DATA : begin 
			sclk_gated_f = 1;
			count = count + 1;	
			mosi = 1;
			if (count == 4) begin
				next_state = S_DATA;
				count = 0;
			end
		end
		S_DATA : begin
			sclk_gated_f = 0;
			if (addr_to_drive[7] == 1) begin 

				mosi = data_to_drive[count];
				count = count + 1;
			end
			if (addr_to_drive[7] == 0) begin 

				data_collect[count] = miso;
				count = count + 1;
			end
			if (count == 8) begin
				num_txs_pending = num_txs_pending - 1; 
				count = 0;
				ctrl_reg[6:4] = ctrl_reg[6:4] + 1;
				cur_tx_idx = cur_tx_idx + 1;
				if (num_txs_pending == 0) begin
					next_state = S_IDLE;
					ctrl_reg[0] = 0; 
					ctrl_reg[3:1] = 0;
				end
				else begin
					next_state = S_IDLE_WITH_TXS_PENDING;
				end
			end
		end
		S_IDLE_WITH_TXS_PENDING : begin
			sclk_gated_f = 1;
			count = count + 1;	
			mosi = 1;
			if (count == 4) begin
				next_state = S_ADDR;
				addr_to_drive = addr_regA[cur_tx_idx];
				data_to_drive = data_regA[cur_tx_idx];
				count = 0;
			end
		end
	endcase
end
end

//always @(sclk_ref_i) begin
//	if (sclk_gated_f == 1) sclk_o = 1;
//	else sclk_o = sclk_ref_i;
//end
always @(next_state) state = next_state;
assign sclk_o = (sclk_gated_f == 0) ? sclk_ref_i : 1;

endmodule
