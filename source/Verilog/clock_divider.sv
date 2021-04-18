module clock_divider
#(parameter DIVIDE_LEN=23)
(input clock,
    output div_clock);
reg [DIVIDE_LEN-1:0] cnt;
initial cnt <= {DIVIDE_LEN{1'b0}};
always @(posedge clock)
begin
    cnt <= cnt+1'b1;
end
    assign div_clock=cnt[DIVIDE_LEN-1];
endmodule
