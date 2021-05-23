`timescale 1 ns / 100 ps

module tb_sys_array_fetcher
#(
	parameter DATA_WIDTH=8,
	parameter ARRAY_W=5, //i
	parameter ARRAY_L=2);//j
	
reg clk, reset_n, load_params, start_comp;
reg [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] input_data_a;
reg [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] input_data_b; 

wire ready;
wire [0:ARRAY_W-1] [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] out_data;
wire [15:0] cnt;
wire div_clk;
wire [0:ARRAY_L-1] [0:ARRAY_W-1] [DATA_WIDTH-1:0] mem_read;
wire [0:ARRAY_W-1] [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] mem_write;

sys_array_fetcher 
#(.DATA_WIDTH(DATA_WIDTH), 
	.ARRAY_W(ARRAY_W), 
	.ARRAY_L(ARRAY_L)) 
sys_array_fetcher0 (
	.clk(clk),
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

genvar i, j;
reg [DATA_WIDTH-1:0] roma [ARRAY_W*ARRAY_L-1:0];
reg [DATA_WIDTH-1:0] romb [ARRAY_W*ARRAY_L-1:0];

initial begin
    $readmemh ("a_data.hex", roma);
    $readmemh ("b_data.hex", romb);
end

generate
    for (i=0;i<ARRAY_W;i=i+1) begin: generate_roma_W
        for (j=0;j<ARRAY_L;j=j+1) begin: generate_roma_L
	        assign input_data_a[i][j] = roma[ARRAY_L*i + j];
	    end
    end
endgenerate

generate
    for (i=0;i<ARRAY_W;i=i+1) begin: generate_romb_W
        for (j=0;j<ARRAY_L;j=j+1) begin: generate_romb_L
	        assign input_data_b[i][j] = romb[ARRAY_L*i + j];
	    end
    end
endgenerate

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
