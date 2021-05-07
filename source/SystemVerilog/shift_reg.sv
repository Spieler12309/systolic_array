module shift_reg
#(parameter DATA_WIDTH = 8,
parameter LENGTH = 4,
parameter PTR_LENGTH = 5)
(	input clk,
	input reset_n,
	input [1:0] ctrl_code,
	input [0:LENGTH-1] [DATA_WIDTH-1:0] data_in,
	input [DATA_WIDTH-1:0] data_write,
	
	output reg [DATA_WIDTH-1:0] data_read,
	output reg [0:LENGTH-1] [DATA_WIDTH-1:0] data_out,

    output reg start,
    output fifo_full, 
    output fifo_empty, 
    output fifo_threshold, 
    output fifo_overflow, 
    output fifo_underflow,

    output [PTR_LENGTH-1:0] wptr,
    output [PTR_LENGTH-1:0] rptr,
    output [0:LENGTH-1] [DATA_WIDTH-1:0] mem,
    output reg read,
    output reg write,
    output reg [PTR_LENGTH - 1:0] cnt
);

localparam DELAY = LENGTH + 1;

localparam REG_UPLOAD = 0,
    REG_LOAD = 1,
    REG_WRITE = 2,
    REG_READ = 3; //Gray coding of states

reg [1:0] prev_code;
reg [0:LENGTH-1] [DATA_WIDTH-1:0] prev_data_in;
reg [DATA_WIDTH-1:0] prev_data_write;

reg [0:LENGTH-1] [DATA_WIDTH-1:0] contents;
//reg write, read;
reg [DATA_WIDTH-1:0] data_in_fifo;

//wire fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;
wire [DATA_WIDTH-1:0] data_out_fifo;

fifo_mem#(
    .DATA_WIDTH     ( DATA_WIDTH ),
    .LENGTH         ( LENGTH ),
    .PTR_LENGTH     ( PTR_LENGTH )
)u_fifo_mem(
    .clk            ( clk            ),
    .reset_n        ( reset_n        ),
    .write          ( write          ),
    .read           ( read           ),
    .data_in        ( data_in_fifo   ),
    .fifo_full      ( fifo_full      ),
    .fifo_empty     ( fifo_empty     ),
    .fifo_threshold ( fifo_threshold ),
    .fifo_overflow  ( fifo_overflow  ),
    .fifo_underflow ( fifo_underflow ),
    .data_out       ( data_out_fifo  ),
    .wptr(wptr),
    .rptr(rptr),
    .mem(mem)
);

//assign fifo_full = (prev_data_write !== data_write);
//assign fifo_empty = ((ctrl_code === REG_WRITE) && (prev_data_write !== data_write));
//assign fifo_threshold = (prev_data_in !== data_in);
//assign fifo_overflow = ((ctrl_code === REG_LOAD) && (prev_data_in !== data_in));

//reg [PTR_LENGTH - 1:0] cnt; //counter
//reg start;
integer del;

initial begin
    cnt <= LENGTH - 1;
    prev_code <= 2'b00;
    read <= 1'b0;
    write <= 1'b0;
    start <= 1'b0;
    del <= 0;
end

always @(posedge clk)
begin
    if (~reset_n) begin
        cnt <= LENGTH - 1;
        read <= 1'b0;
        write <= 1'b0;  
        data_in_fifo <= {DATA_WIDTH{1'b0}};      
    end
    else begin
        case (ctrl_code)
            REG_UPLOAD: begin
                if (prev_code !== ctrl_code) begin
                    cnt <= 0;
                    prev_code <= ctrl_code;
                    read <= 1'b1;
                    write <= 1'b0;
                end
                else begin
                    write <= 1'b0;
                    if (cnt != LENGTH) begin
                        read <= 1'b1;
                        cnt <= cnt + 1;
                        data_out[rptr[PTR_LENGTH-2:0]] <= data_out_fifo;
                    end
                    else
                        read <= 1'b0;
                end
                //data_out <= contents;
            end
            REG_LOAD: begin
                if (prev_code !== ctrl_code) begin
                    cnt <= 1;
                    prev_code <= ctrl_code;
                    read <= 1'b0;
                    write <= 1'b1;
                    data_in_fifo <= data_in[0];
                end
                else begin
                    read <= 1'b0;
                    if (cnt != LENGTH) begin
                        write <= 1'b1;
                        data_in_fifo <= data_in[cnt];
                        cnt <= cnt + 1;
                    end
                    else begin
                        write <= 1'b0;
                        cnt <= 'd0;
                    end
                end
                //contents <= data_in;
            end            
            REG_WRITE: begin
                if (del == 0) begin
                    read <= 1'b0;
                    write <= 1'b1;
                    data_in_fifo <= data_write;
                    del <= DELAY;
                end 
                else begin 
                    del <= del - 1;
                    write <= 1'b0;
                end
                //if (start) begin
                //    cnt <= 'd0;
                //    read <= 1'b0;
                //    write <= 1'b1;
                //end
                //else begin
                //    if (cnt == 'd0) begin
                //        write <= 1'b1;
                //        data_in_fifo <= data_write;                  
                //        cnt <= 'd1;
                //    end
                //    if (cnt == 'd1) begin                        
                //        write <= 1'b0;
                //        cnt <= 'd0;
                //    end                   
                //end

                //if (start) begin
                //    cnt <= 0;
                //    read <= 1'b0;
                //    write <= 1'b0;
                //end
                //else begin
                //    if (cnt == 'd0) begin
                //        write <= 1'b1;
                //        data_in_fifo <= data_write;                  
                //        cnt <= cnt + 1;
                //    end
                //    if (cnt == 'd1) begin                        
                //        write <= 1'b0;
                //        cnt <= cnt + 1;
                //    end                   
                //end
                //for (i = 0; i < LENGTH - 1; i = i + 1) begin : for_REG_WRITE
                //    contents[i] <= contents[i + 1];
                //end
                //contents[LENGTH-1] <= data_write;
            end
            REG_READ: begin               

                if (del == 0) begin
                    read <= 1'b1;
                    write <= 1'b0;
                    data_read <= data_out_fifo;
                    del <= DELAY;
                end 
                else begin 
                    del <= del - 1;
                    read <= 1'b0;
                end
                //if (start) begin
                //    cnt <= 0;
                //    read <= 1'b1;
                //    write <= 1'b0;
                //end
                //else begin
                //    if (cnt == 'd0) begin
                //        read <= 1'b1;                        
                //        cnt <= 'd1;
                //    end
                //    if (cnt == 'd1) begin
                //        data_read <= data_out_fifo;
                //        read <= 1'b0;
                //        cnt <= 'd0;
                //    end                   
                //end

                //if (start) begin
                //    cnt <= 0;
                //    read <= 1'b0;
                //    write <= 1'b0;
                //end
                //else begin
                //    if (cnt == 'd0) begin
                //        read <= 1'b1;                        
                //        cnt <= cnt + 1;
                //    end
                //    if (cnt == 'd1) begin
                //        data_read <= data_out_fifo;
                //        read <= 1'b0;
                //        cnt <= cnt + 1;
                //    end                   
                //end
                //data_read <= contents[0];
                //for (i = 0; i < LENGTH - 1; i = i + 1) begin : for_REG_READ
                //    contents[i] <= contents[i + 1];
                //end
                //contents[LENGTH-1] <= contents[0];
            end
        endcase
    end
end

endmodule
