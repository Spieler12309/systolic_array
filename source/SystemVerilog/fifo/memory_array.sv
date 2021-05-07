module memory_array
#(parameter DATA_WIDTH = 8,
parameter LENGTH = 4,
parameter PTR_LENGTH = 5)
(
	input clk,
	input [DATA_WIDTH-1:0] data_in, 
	input [PTR_LENGTH-1:0] wptr,
	input [PTR_LENGTH-1:0] rptr,
	input fifo_write, 
	
	output [DATA_WIDTH-1:0] data_out,
	output reg [0:LENGTH-1] [DATA_WIDTH-1:0] mem
);  

//reg [0:LENGTH-1] [DATA_WIDTH-1:0] mem;

always @(posedge clk)  
begin  
	if (fifo_write)   
		mem[wptr[PTR_LENGTH-2:0]] <= data_in ;  
end 

assign data_out = mem[rptr[PTR_LENGTH-2:0]];  

endmodule  