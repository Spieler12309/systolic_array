module sys_array_basic
#(
	parameter DATA_WIDTH = 8,
	parameter ARRAY_W_W = 4, //Строк в массиве весов
	parameter ARRAY_W_L = 4, //Столбцов в массиве весов
	parameter ARRAY_A_W = 4, //Строк в массиве данных
	parameter ARRAY_A_L = 4) //Столбцов в массиве данных
(   input 															clk,
    input 															reset_n,
    input 															weights_load,
	input 					[0:ARRAY_A_W-1]		[DATA_WIDTH-1:0] 	input_data,
	input [0:ARRAY_W_W-1]	[0:ARRAY_W_L-1] 	[DATA_WIDTH-1:0] 	weight_data,

    output 					[0:ARRAY_W_W-1] 	[2*DATA_WIDTH-1:0] 	output_data
);


endmodule
