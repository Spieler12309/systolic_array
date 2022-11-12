module sys_array_basic
#(
	parameter DATA_WIDTH = 8,
    parameter ARRAY_MAX_W = 10, //Максимальное число строк в систолическом массиве
    parameter ARRAY_MAX_L = 10) //Максимальное число столбцов в систолическом массиве
(   input 															clk,
    input 															reset_n,
    input 															weights_load,
	input										[15:0]				array_w_l,
	input 					[0:ARRAY_MAX_L-1]	[DATA_WIDTH-1:0] 	input_data,
	input [0:ARRAY_MAX_W-1]	[0:ARRAY_MAX_L-1] 	[DATA_WIDTH-1:0] 	weight_data,

    output reg				[0:ARRAY_MAX_W-1] 	[2*DATA_WIDTH-1:0] 	output_data
);

wire [0:ARRAY_MAX_W-1] [0:ARRAY_MAX_L-1] [2*DATA_WIDTH-1:0] temp_output_data;
wire [0:ARRAY_MAX_W-1] [0:ARRAY_MAX_L-1] [DATA_WIDTH-1:0] propagate_module;

genvar i;
genvar j;
genvar t;
// Генерация массива вычислительных ячеек
generate
	for(i = 0; i < ARRAY_MAX_W; i = i + 1) begin : generate_array_proc
		 for (j = 0; j < ARRAY_MAX_L; j = j + 1) begin : generate_array_proc2
		 if ((i == 0) && (j == 0)) // i - строка, j - столбец
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst ( 
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(weights_load),
			  .input_data(input_data[0]),
			  .prop_data({2*DATA_WIDTH{1'b0}}),
			  .param_data(weight_data[0][0]),
			  .out_data(temp_output_data[0][0]),
			  .prop_param(propagate_module[0][0])
			  );
		 end
		 else if (i == 0) //первая строка
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(weights_load),
			  .input_data(input_data[j]),
			  .prop_data(temp_output_data[0][j-1]),
			  .param_data(weight_data[0][j]),
			  .out_data(temp_output_data[0][j]),
			  .prop_param(propagate_module[0][j])
			  );
		 end
		 else if (j == 0) //первый столбец
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(weights_load),
			  .input_data(propagate_module[i-1][0]),
			  .prop_data({2*DATA_WIDTH{1'b0}}),
			  .param_data(weight_data[i][0]),
			  .out_data(temp_output_data[i][0]),
			  .prop_param(propagate_module[i][0])
			  );
		 end
		 else
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(weights_load),
			  .input_data(propagate_module[i-1][j]),
			  .prop_data(temp_output_data[i][j-1]),
			  .param_data(weight_data[i][j]),
			  .out_data(temp_output_data[i][j]),
			  .prop_param(propagate_module[i][j])
			  );
		 end
		 end
	end
endgenerate

// Генерация связей для выходных данных
generate
	for (t=0;t<ARRAY_MAX_W;t=t+1) begin: output_prop
		always @(posedge clk) begin
			output_data[t] = temp_output_data[t][array_w_l - 1];
		end
	end
endgenerate

endmodule