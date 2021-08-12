`timescale 1 ns / 100 ps

module tb_sys_array_fetcher
#(
	parameter DATA_WIDTH = 8,
	parameter ARRAY_W_W = 5, //Строк в массиве весов
	parameter ARRAY_W_L = 2, //Столбцов в массиве весов
	parameter ARRAY_A_W = 2, //Строк в массиве данных
	parameter ARRAY_A_L = 6);//Столбцов в массиве данных

reg clk, reset_n, load_params, start_comp;
reg [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] input_data_a;
reg [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] input_data_w; 

wire ready;
wire [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] out_data;


sys_array_fetcher 
#(.DATA_WIDTH(DATA_WIDTH), 
	.ARRAY_W_W(ARRAY_W_W), 
	.ARRAY_W_L(ARRAY_W_L),
  .ARRAY_A_W(ARRAY_A_W), 
	.ARRAY_A_L(ARRAY_A_L)) 
sys_array_fetcher0 (
	.clk(clk),
	.reset_n(reset_n),
	.load_params(load_params),
  .start_comp(start_comp),
  .input_data_b(input_data_a),
  .input_data_w(input_data_w),
  .ready(ready),
  .out_data(out_data)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer i, j;

initial
    begin
      reset_n=0; load_params = 0;
      #80; reset_n=1;
      #20;
      load_params = 1'b1;

		  for (i=0;i<ARRAY_A_W;i=i+1) begin
        for (j=0;j<ARRAY_A_L;j=j+1) begin
          input_data_a[i][j] = ARRAY_A_W * j + i + 1;
        end
      end
		  for (i=0;i<ARRAY_W_W;i=i+1) begin
        for (j=0;j<ARRAY_W_L;j=j+1) begin
          input_data_w[i][j] = ARRAY_W_L*i + j + 1;
        end
      end
		  #20;
		  load_params = 1'b0;
		  #10;
		  start_comp = 1'b1;
		  #20;
		  start_comp = 1'b0;
      while (ready == 'b0)
        #20;
      #20; $finish;
    end
endmodule