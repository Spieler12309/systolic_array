//`timescale 1 ns / 100 ps

module tb_shift_array
#(
	parameter DATA_WIDTH=8,
	parameter LENGTH=4,
	parameter PTR_LENGTH = 3);
	
reg clk, reset_n;
reg [1:0] ctrl_code;
reg [0: LENGTH-1] [DATA_WIDTH-1:0] data_in;
reg [DATA_WIDTH-1:0] data_write;

wire [DATA_WIDTH-1:0] data_read;
wire [0: LENGTH-1] [DATA_WIDTH-1:0] data_out;
wire start;
wire fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;
wire [PTR_LENGTH-1:0] wptr, rptr;
wire [0:LENGTH-1] [DATA_WIDTH-1:0] mem;
wire read, write;
wire [PTR_LENGTH - 1:0] cnt; //counter

shift_reg #(.DATA_WIDTH(DATA_WIDTH), .LENGTH(LENGTH), .PTR_LENGTH(PTR_LENGTH)) shift_reg1
(
.clk(clk),
.reset_n(reset_n),
.ctrl_code(ctrl_code),
.data_in(data_in),
.data_write(data_write),

.data_read(data_read),
.data_out(data_out),

.start(start),
.fifo_full(fifo_full),
.fifo_empty(fifo_empty),
.fifo_threshold(fifo_threshold),
.fifo_overflow(fifo_overflow),
.fifo_underflow(fifo_underflow),
.wptr(wptr),
.rptr(rptr),
.mem(mem),
.read(read),
.write(write),
.cnt(cnt)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii;

initial
begin
	reset_n=0; ctrl_code = 2'b00;
	#80; reset_n=1;
	#20;
		
	ctrl_code = 2'b01;		  
	for (ii = 0; ii < LENGTH; ii = ii + 1) begin
		data_in[ii] = ii + 1;
	end
		
	#100; // (LENGTH+1) * PERIOD
	ctrl_code = 2'b11;
	#400; // (LENGTH+1) * PERIOD
	ctrl_code = 2'b10;
	for (ii = 0; ii < 1; ii = ii + 1) begin
		data_write = ii + 5;
			#100;
	end
		
	ctrl_code = 2'b00;
	#100; // (LENGTH+1) * PERIOD
	ctrl_code = 2'b11;
	for (ii = 0; ii < LENGTH; ii = ii + 1) begin
		#100;
	end
end
endmodule
