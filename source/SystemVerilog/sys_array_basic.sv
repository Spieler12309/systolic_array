module sys_array_basic
#(parameter DATA_WIDTH = 8,
parameter ARRAY_W = 4, //i
parameter ARRAY_L = 4) //j
(   input  clk,
    input  reset_n,
    input  param_load,
    input [0:ARRAY_L-1] [DATA_WIDTH-1:0] input_module,
	input [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] parameter_data,

    output [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] out_module
);

wire [0:ARRAY_W-1] [0:ARRAY_L-1] [2*DATA_WIDTH-1:0] output_data;
wire [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] propagate_module;

genvar i;
genvar j;
genvar t;
generate
	for(i = 0; i < ARRAY_W; i = i + 1) begin : generate_array_proc
		 for (j = 0; j < ARRAY_L; j = j + 1) begin : generate_array_proc2
		 if ((i == 0) && (j == 0)) // i - строка, j - столбец
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst ( 
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(param_load),
			  .input_data(input_module[0]),
			  .prop_data({2*DATA_WIDTH{1'b0}}),
			  .param_data(parameter_data[0][0]),
			  .out_data(output_data[0][0]),
			  .prop_param(propagate_module[0][0])
			  );
		 end
		 else if (i == 0) //первая строка
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(param_load),
			  .input_data(input_module[j]),
			  .prop_data(output_data[0][j-1]),
			  .param_data(parameter_data[0][j]),
			  .out_data(output_data[0][j]),
			  .prop_param(propagate_module[0][j])
			  );
		 end
		 else if (j == 0) //первый столбец
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(param_load),
			  .input_data(propagate_module[i-1][0]),
			  .prop_data({2*DATA_WIDTH{1'b0}}),
			  .param_data(parameter_data[i][0]),
			  .out_data(output_data[i][0]),
			  .prop_param(propagate_module[i][0])
			  );
		 end
		 else
		 begin
			  sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
			  .clk(clk),
			  .reset_n(reset_n),
			  .param_load(param_load),
			  .input_data(propagate_module[i-1][j]),
			  .prop_data(output_data[i][j-1]),
			  .param_data(parameter_data[i][j]),
			  .out_data(output_data[i][j]),
			  .prop_param(propagate_module[i][j])
			  );
		 end
		 end
	end
endgenerate

generate
	for (t=0;t<ARRAY_W;t=t+1) begin: output_prop
		assign out_module[t] = output_data[t][ARRAY_L-1];
	end
endgenerate

endmodule
