//`timescale 1 ns / 100 ps

module testbench_sys_array_fetcher
#(
	parameter DATA_WIDTH=8,
	parameter ARRAY_W=5, //j
	parameter ARRAY_L=2);//i
	
reg clk, reset_n, load_params, start_comp;
reg  [DATA_WIDTH*ARRAY_W*ARRAY_L - 1:0] input_data_a, input_data_b;
	 
wire ready;
wire [2*DATA_WIDTH*ARRAY_W*ARRAY_W-1:0] out_data;
	 

sys_array_fetcher #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_W), .ARRAY_L(ARRAY_L)) sys_array_fetcher0 (
	.clock(clk),
	.reset_n(reset_n),
	.load_params(load_params),
   .start_comp(start_comp),
   .input_data_a(input_data_a),
   .input_data_b(input_data_b),
   .ready(ready),
   .out_data(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii;

initial
    begin
        reset_n=0; load_params = 0;
        #80; reset_n=1;
        #20;
        load_params = 1'b1;
		  
		  for (ii = 0; ii < 10; ii = ii + 1) begin
            input_data_a[DATA_WIDTH * ii +: DATA_WIDTH] = ii + 1;
        end
		  
		  for (ii = 0; ii < 10; ii = ii + 1) begin
            input_data_b[DATA_WIDTH * ii +: DATA_WIDTH] = ii + 1;
        end
		  #20;
		  load_params = 1'b0;
		  #10;
		  start_comp = 1'b1;
		  #20;
		  start_comp = 1'b0;
		  
    end
endmodule
