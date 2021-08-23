module sys_array_fetcher_synth
#(
	parameter DATA_WIDTH = 8,

	parameter ARRAY_W_W = 20, //Строк в массиве весов
	parameter ARRAY_W_L = 10, //Столбцов в массиве весов
	parameter ARRAY_A_W = 10, //Строк в массиве данных
	parameter ARRAY_A_L = 10 //Столбцов в массиве данных
)

(   input  clk,
    input  reset_n,
    input load_params,
    input  start_comp, 

    output reg ready,
    output wire rd);

wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] input_data_b;
wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] input_data_a;

wire [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] out_data;

sys_array_fetcher 
#(.DATA_WIDTH(DATA_WIDTH),
.ARRAY_W_W       (ARRAY_W_W    ),
.ARRAY_W_L       (ARRAY_W_L    ),
.ARRAY_A_W       (ARRAY_A_W    ),
.ARRAY_A_L       (ARRAY_A_L    ))
sys_array_fetcher0 (
	.clk(clk),
	.reset_n(reset_n),
    .load_params(load_params),
  .start_comp(start_comp),
  .input_data_w(input_data_a),
  .input_data_b(input_data_b),
  .ready(ready),
  .out_data(out_data)
);

genvar i, j;
reg [DATA_WIDTH-1:0] roma [ARRAY_W_W*ARRAY_W_L-1:0];
reg [DATA_WIDTH-1:0] romb [ARRAY_A_W*ARRAY_A_L-1:0];

initial begin
    $readmemh ("a_data.hex", roma);
    $readmemh ("b_data.hex", romb);
end

generate
    for (i=0;i<ARRAY_W_W;i=i+1) begin: generate_roma_W
        for (j=0;j<ARRAY_W_L;j=j+1) begin: generate_roma_L
	        assign input_data_a[i][j] = roma[ARRAY_W_L*i + j];
	    end
    end
endgenerate

generate
    for (i=0;i<ARRAY_A_W;i=i+1) begin: generate_romb_W
        for (j=0;j<ARRAY_A_L;j=j+1) begin: generate_romb_L
	        assign input_data_b[i][j] = romb[ARRAY_A_L*i + j];
	    end
    end
endgenerate

assign rd = &out_data;

endmodule
