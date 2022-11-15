`timescale 1 ns / 100 ps

module tb_sys_array_fetcher
#(
	parameter DATA_WIDTH = 8,//Разрядность шины входных данных
	parameter ARRAY_A_W  = 4, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 3, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 3, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 4);//Количество столбцов в массиве весов
	
reg clk, reset_n, load_params, start_comp;

reg [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] input_data_a;
reg [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] weights_data; 
reg [0:ARRAY_A_W-1] [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] result_data; 

wire ready;
wire [0:ARRAY_A_W-1] [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] out_data;
wire [15:0] cnt;
wire div_clk;

sys_array_fetcher 
#(.DATA_WIDTH(DATA_WIDTH),
.ARRAY_A_W       (ARRAY_A_W    ),
.ARRAY_A_L       (ARRAY_A_L    ),
.ARRAY_W_W       (ARRAY_W_W    ),
.ARRAY_W_L       (ARRAY_W_L    ))
sys_array_fetcher0 (
    .clk(clk),
	.reset_n(reset_n),
    .load_params(load_params),
    .start_comp(start_comp),
    .input_data_a(input_data_a),
    .input_data_w(weights_data),  
    .ready(ready),
    .out_data(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

genvar i, j;
reg [DATA_WIDTH-1:0] roma [ARRAY_A_W*ARRAY_A_L-1:0];
reg [DATA_WIDTH-1:0] romb [ARRAY_W_W*ARRAY_W_L-1:0];
reg [2*DATA_WIDTH-1:0] romc [ARRAY_A_W*ARRAY_W_L-1:0];

initial begin
    $readmemh ("a_data.hex", roma);
    $readmemh ("b_data.hex", romb);
    $readmemh ("c_data.hex", romc);
end

generate
    for (i=0;i<ARRAY_A_W;i=i+1) begin: generate_roma_W
        for (j=0;j<ARRAY_A_L;j=j+1) begin: generate_roma_L
	        assign input_data_a[i][j] = roma[ARRAY_A_L*i + j];
	    end
    end
endgenerate

generate
    for (i=0;i<ARRAY_W_W;i=i+1) begin: generate_romb_W
        for (j=0;j<ARRAY_W_L;j=j+1) begin: generate_romb_L
	        assign weights_data[i][j] = romb[ARRAY_W_L*i + j];
	    end
    end
endgenerate

generate
    for (i=0;i<ARRAY_A_W;i=i+1) begin: generate_romc_W
        for (j=0;j<ARRAY_W_L;j=j+1) begin: generate_romc_L
	        assign result_data[i][j] = romc[ARRAY_W_L*i + j];
	    end
    end
endgenerate

integer ii, jj;

initial
    begin
        reset_n=0; load_params = 0;
        #20; reset_n=1;
        #20;
        load_params = 1'b1;
        #20;
        load_params = 1'b0;
        #20;
        start_comp = 1'b1;
        #20;
        start_comp = 1'b0;
        #20;
        while (~ready)
            #20;
        for (ii = 0; ii < ARRAY_A_W; ii = ii + 1) begin
            for (jj = 0; jj < ARRAY_W_L; jj = jj + 1) begin
                if (result_data[ii][jj] != out_data[ii][jj])
                begin
                    $display("FAIL!");
                    $finish; 
                end
            end
        end
        #40;
        $display("PASSED");
        $finish;            
    end
endmodule