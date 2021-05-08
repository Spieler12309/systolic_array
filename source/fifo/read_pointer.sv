module read_pointer
#(parameter PTR_LENGTH = 5)
(   input clk,
    input reset_n,
    input fifo_empty,
    input read, 

    output reg [PTR_LENGTH-1:0] rptr,
    output fifo_read
);

assign fifo_read = (~fifo_empty) & read;

always @(posedge clk)  
begin  
    if (~reset_n) 
        rptr <= 'b0;
    else if (fifo_read) begin
        rptr = rptr + 'b1;
    end
    else  
        rptr <= rptr;
end  

endmodule