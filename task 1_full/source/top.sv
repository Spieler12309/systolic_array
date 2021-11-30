module top (
	input					clk,
	input 			[3:0] 	key_sw,
	output	wire	[3:0] 	led,
	output					buzzer,
	output			[7:0] 	segment,
	output			[3:0] 	digit
);

localparam DATA_WIDTH = 8;

wire [2 * DATA_WIDTH - 1:0] data;

reg [DATA_WIDTH-1:0] inp;
reg [DATA_WIDTH-1:0] par;
reg [2*DATA_WIDTH-1:0] prop;
reg [2*DATA_WIDTH-1:0] result;


// Подключаем модуль для считывания тестовых данных.
read_data 
#(.DATA_WIDTH(DATA_WIDTH)) rd1 (
	.clk(clk),
	.reset_n(key_sw[3]),
	.change(key_sw[0]),
	.code(led[3:1]),

	.inp(inp),
	.par(par),
	.prop(prop),
	.result(result)
 );

// Подключаем основной вычислительный модуль систолического массива.
sys_array_cell 
#(.DATA_WIDTH(DATA_WIDTH)) sac1
(   .clk(clk),
    .reset_n(key_sw[3]),
    .param_load(~key_sw[1]),
    .input_data(inp),
    .prop_data(prop),
    .param_data(par),
	
    .out_data(data),
    .prop_param()
);

// Подклюаем модуль для вывода результата на семисегментные индикаторы.
data_to_segments ds1
(	.clk(clk),
	.data(data),
   .segment(segment),
	.digit(digit)
);

assign led[0] = ~(data == result);

endmodule
