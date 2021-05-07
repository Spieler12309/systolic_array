module status_signal 
#(parameter PTR_LENGTH = 5,
parameter LENGTH = 10)
(   input clk,
    input reset_n,
    input read,
    input write,
    input fifo_write,
    input fifo_read,
    input [PTR_LENGTH-1:0] rptr,
    input [PTR_LENGTH-1:0] wptr,

    output reg fifo_full, 
    output reg fifo_empty, 
    output reg fifo_threshold, 
    output reg fifo_overflow, 
    output reg fifo_underflow
);

wire fbit_comp, overflow_set, underflow_set;  
wire pointer_equal;  
wire [PTR_LENGTH-1:0] pointer_result;

assign fbit_comp = wptr[PTR_LENGTH-1] ^ rptr[PTR_LENGTH-1];  
assign pointer_equal = (wptr[PTR_LENGTH-2:0] - rptr[PTR_LENGTH-2:0]) ? 0:1;  
assign pointer_result = wptr - rptr;  
assign overflow_set = fifo_full & write;  
assign underflow_set = fifo_empty & read;  

always @(*)  
begin  
    //fifo_full = 1'b0;//fbit_comp & pointer_equal;  
    fifo_empty = 1'b0;//(~fbit_comp) & pointer_equal;  
    fifo_threshold = 1'b0;//(pointer_result[PTR_LENGTH-1]||pointer_result[PTR_LENGTH-2]) ? 1:0;  
end

always @(posedge clk) begin
    if (~reset_n)
        fifo_empty <= 1'b1;
    else if (fifo_write)
        fifo_empty <= 1'b0;
end

always @(posedge clk)  
begin  
    if(~reset_n) 
        fifo_overflow <=0;  
    else if ((overflow_set==1) && (fifo_read==0))  
        fifo_overflow <=1;  
    else if (fifo_read)  
        fifo_overflow <=0;  
    else  
        fifo_overflow <= fifo_overflow;  
end

always @(posedge clk)  
begin  
    if(~reset_n) 
        fifo_underflow <=0;  
    else if ((underflow_set==1) && (fifo_write==0))  
        fifo_underflow <=1;  
    else if (fifo_write)  
        fifo_underflow <=0;  
    else  
        fifo_underflow <= fifo_underflow;  
end  

endmodule