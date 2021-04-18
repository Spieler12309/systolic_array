//`timescale 1 ns / 100 ps

module testbench_roma
#(
	parameter DATA_WIDTH=8,
	parameter ARRAY_W=5,
	parameter ARRAY_L=2);
	
reg clk;
wire [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH - 1:0] input_data_a;

roma #(
	.DATA_WIDTH(DATA_WIDTH), 
	.ARRAY_W(ARRAY_W), 
	.ARRAY_L(ARRAY_L)) 
rom_instance_a
(   .clk(clk), 
    .data_rom(input_data_a)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii, jj;

initial
    begin
    	#20;
      for (ii = 0; ii < ARRAY_W; ii = ii + 1) begin
      	for (jj = 0; jj < ARRAY_L; jj = jj + 1) begin
      		$display(input_data_a[ii][jj]);
      	end
      	$display("\n");
      end
    end
endmodule
