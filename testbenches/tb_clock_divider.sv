`timescale 1 ns / 100 ps

module tb_clock_divider;
parameter PERIOD  = 10;

reg clk;
wire div_clk;

clock_divider#(
    .DIVIDE_LEN ( 6 )
)u_clock_divider(
    .clk ( clk ),
    .div_clk  ( div_clk  )
);

initial
begin
    clk = 1'b0;
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    $monitor("TIME = %d, clk = %b, div_clk = %b", $time, clk, div_clk);
    #10000;
    $finish;
end

endmodule