`timescale 1 ns / 100 ps

module tb_sys_array_fetcher_split
#(
	parameter DATA_WIDTH = 8,

	parameter ARRAY_A_W = 4, //Строк в массиве данных
	parameter ARRAY_A_L = 5, //Столбцов в массиве данных
	parameter ARRAY_W_W = 5, //Строк в массиве весов
	parameter ARRAY_W_L = 8, //Столбцов в массиве весов

    parameter ARRAY_W = 5, //Максимальное число строк в систолическом массиве
    parameter ARRAY_L = 5, //Максимальное число столбцов в систолическом массиве

    parameter ARRAY_MAX_A_W = 5,

    parameter OUT_SIZE = 100);
	
reg clk, reset_n, load_params, start_comp;

reg signed [DATA_WIDTH-1:0] input_data_a [0:ARRAY_A_W-1] [0:ARRAY_A_L-1];
reg signed [DATA_WIDTH-1:0] weights [0:ARRAY_W_W-1] [0:ARRAY_W_L-1];
reg signed [2*DATA_WIDTH-1:0] result_data  [0:ARRAY_A_W-1] [0:ARRAY_W_L-1];

wire ready;
wire signed [2*DATA_WIDTH-1:0] out_data [0:ARRAY_A_W-1] [0:ARRAY_W_L-1];
wire [15:0] cnt;
wire div_clk;

sys_array_fetcher_split
#(.DATA_WIDTH(DATA_WIDTH),
.ARRAY_W_W       (ARRAY_W_W    ),
.ARRAY_W_L       (ARRAY_W_L    ),
.ARRAY_A_W       (ARRAY_A_W    ),
.ARRAY_A_L       (ARRAY_A_L    ),
.ARRAY_W         (ARRAY_W  ),
.ARRAY_L         (ARRAY_L  ),
.ARRAY_MAX_A_W   (ARRAY_MAX_A_W),
.OUT_SIZE        (OUT_SIZE     ))
sys_array_fetcher0 (
	.clk(clk),
	.reset_n(reset_n),
  .start_comp(start_comp),
  .input_data_a(input_data_a),
  .weights(weights),
  .ready(ready),
  .out_data(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

genvar i, j;

initial begin
    $readmemh ("a_data.hex", input_data_a);
    $readmemh ("b_data.hex", weights);
    $readmemh ("c_data.hex", result_data);
end

initial
    begin
        reset_n=0; load_params = 0;
        #120; reset_n=1;
        #20;
        load_params = 1'b1;


        #20;
        load_params = 1'b0;
        #120;
        start_comp = 1'b1;
        #120;
        start_comp = 1'b0;
        #20;
        while (~ready)
            #20;
        #40;
        $finish;
            
    end
endmodule