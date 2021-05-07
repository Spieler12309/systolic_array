module write_pointer
#(parameter PTR_LENGTH = 5,
parameter LENGTH = 4)
(   input clk,
    input reset_n,
    input fifo_full,
    input write, 

    output reg [PTR_LENGTH-1:0] wptr,
    output fifo_write
);

//assign fifo_write = (~fifo_full) & write;  
assign  fifo_write = write;  

always @(posedge clk)  
begin  
    if (~reset_n) 
        wptr <= 'b0;  
    else if (fifo_write)  begin
        wptr = wptr + 'b1;  
        if (wptr == LENGTH)
            wptr = 'b0;
    end
    else  
        wptr <= wptr;  
end

endmodule  