module clock_divider
#(parameter DIVIDE_LEN = 25)
(	input clk,
	output div_clk
);

reg [DIVIDE_LEN-1:0] cnt;

initial cnt <= {DIVIDE_LEN{1'b0}};

always @(posedge clk)
begin
    if (cnt === DIVIDE_LEN)
        cnt <= 0;
    else
        cnt <= cnt+1'b1;
end

assign div_clk = (cnt === DIVIDE_LEN);

endmodule
