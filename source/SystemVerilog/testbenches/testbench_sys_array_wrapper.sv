//`timescale 1 ns / 100 ps

module testbench_sys_array_wrapper
#(
	parameter DATA_WIDTH=8,
	parameter ARRAY_W=4, //i
	parameter ARRAY_L=4,
  parameter CLOCK_DIVIDE = 2);//j
	
reg clk, reset_n, load_params, start_comp;

wire [4*DATA_WIDTH-1:0] out_data;
	 

sys_array_wrapper 
#(.DATA_WIDTH(DATA_WIDTH), 
	.ARRAY_W(ARRAY_W), 
	.ARRAY_L(ARRAY_L),
  .CLOCK_DIVIDE(CLOCK_DIVIDE)) 
sys_array_wrapper0 (
	.clk(clk),
	.reset_n(reset_n),
	.load_params(load_params),
  .start_comp(start_comp),
  .hex_connect(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

initial
begin
  reset_n=0; load_params = 0;
  #80; reset_n=1;
  #20;
  load_params = 1'b1;
  #20;
  load_params = 1'b0;
  #10;
  start_comp = 1'b1;
  #20;
  start_comp = 1'b0;		  
end
endmodule
