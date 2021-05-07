module read_pointer
#(parameter PTR_LENGTH = 5, 
parameter LENGTH = 4)
(   input clk,
    input reset_n,
    input fifo_empty,
    input read, 

    output reg [PTR_LENGTH-1:0] rptr,
    output fifo_read
);

assign fifo_read = (~fifo_empty) & read;
//assign fifo_read = read;

always @(posedge clk)  
begin  
    if (~reset_n) 
        rptr <= 'b0;
    else if (fifo_read) begin
        rptr = rptr + 'b1;
        if (rptr == LENGTH)
            rptr = 'b0;
    end
    else  
        rptr <= rptr;
end  

endmodule