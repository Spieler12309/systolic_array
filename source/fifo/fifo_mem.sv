module fifo_mem
#(	parameter DATA_WIDTH = 8,
	parameter LENGTH = 16,
	parameter PTR_LENGTH = 5)
(	
	input clk, 
	input reset_n, 
	input write, 
	input read, 
	input [DATA_WIDTH-1:0] data_in,
	
	output fifo_full, 
	output fifo_empty, 
	output fifo_threshold, 
	output fifo_overflow, 
	output fifo_underflow,
	output [DATA_WIDTH-1:0] data_out
);  

wire [PTR_LENGTH-1:0] wptr, rptr;
wire fifo_write, fifo_read;   

write_pointer#(
    .PTR_LENGTH ( PTR_LENGTH )
)u_write_pointer(
    .clk       ( clk       ),
    .reset_n   ( reset_n   ),
    .fifo_full ( fifo_full ),
    .write     ( write     ),
    .wptr      ( wptr      ),
    .fifo_write  ( fifo_write  )
);

read_pointer#(
    .PTR_LENGTH ( PTR_LENGTH )
)u_read_pointer(
    .clk        ( clk        ),
    .reset_n    ( reset_n    ),
    .fifo_empty ( fifo_empty ),
    .read       ( read       ),
    .rptr       ( rptr       ),
    .fifo_read  ( fifo_read  )
);

memory_array#(
    .DATA_WIDTH ( DATA_WIDTH ),
    .LENGTH     ( LENGTH ),
    .PTR_LENGTH ( PTR_LENGTH )
)u_memory_array(
    .clk        ( clk        ),
    .data_in    ( data_in    ),
    .wptr       ( wptr       ),
    .rptr       ( rptr       ),
    .fifo_write ( fifo_write ),
    .data_out   ( data_out   )
);

status_signal#(
    .PTR_LENGTH     ( PTR_LENGTH	 )
)u_status_signal(
    .clk            ( clk            ),
    .reset_n        ( reset_n        ),
    .read           ( read           ),
    .write          ( write          ),
    .fifo_write     ( fifo_write     ),
    .fifo_read      ( fifo_read      ),
    .rptr           ( rptr           ),
    .wptr           ( wptr           ),
    .fifo_full      ( fifo_full      ),
    .fifo_empty     ( fifo_empty     ),
    .fifo_threshold ( fifo_threshold ),
    .fifo_overflow  ( fifo_overflow  ),
    .fifo_underflow  ( fifo_underflow  )
);


endmodule  