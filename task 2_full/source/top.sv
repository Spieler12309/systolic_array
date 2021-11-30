module top 
#(  parameter DATA_WIDTH = 8,
	parameter ARRAY_W_W = 2, //Строк в массиве весов
	parameter ARRAY_W_L = 5, //Столбцов в массиве весов
	parameter ARRAY_A_W = 5, //Строк в массиве данных
	parameter ARRAY_A_L = 2, //Столбцов в массиве данных
	parameter CLOCK_DIVIDE = 25)
(
	input					clk,
	input 			[3:0] 	key_sw,
	output	wire	[3:0] 	led,
	output					buzzer,
	output			[7:0] 	segment,
	output			[3:0] 	digit
);

wire ready, out_ready;
wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] input_data_b;
wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] input_data_a;

reg [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] out_data;

assign hex_connector = out_data;

genvar ii;

// Модуль считывания матриц
read_data 
#(  .DATA_WIDTH(DATA_WIDTH), 
    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
rd1
(   .clk(clk), 
    .data_rom_w(input_data_a),
    .data_rom_b(input_data_b)
);

wire clk2;

clock_divider #(.DIVIDE_LEN(25))
cd1
(	.clk(clk),
	.div_clock(clk2)
);

// Модуль вычислителя
sys_array_fetcher 
#(  .DATA_WIDTH(DATA_WIDTH), 
    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
fetching_unit
(
    .clk(clk2),
    .reset_n(key_sw[3]),
    .load_params(~key_sw[0]),
    .start_comp(~key_sw[1]),
    .input_data_b(input_data_b),
    .input_data_w(input_data_a),

    .ready(ready),
    .out_ready(out_ready),
    .out_data(),
    .output_wire(out_data)
);

reg [2*DATA_WIDTH-1:0] data;

// Подклюаем модуль для вывода результата на семисегментные индикаторы.
data_to_segments ds1
(   .clk(clk),
    .data(data),
    .segment(segment),
    .digit(digit)
);

reg [1:0] row, kol;
initial
begin 
    row = 0;
    kol = 0;
end

wire next_item;

button_debouncer deb1 (
    .clk_i(clk),
	.rst_i(),
    .sw_i(key_sw[2]),
 
    .sw_state_o(),
    .sw_down_o(next_item),
    .sw_up_o()
); 

always @(posedge next_item)
begin 
    if (out_ready)
    begin
    	data = out_data[row][kol];
        if (kol + 1 >= ARRAY_A_L)
        begin 
            kol = 0;
            if (row + 1 >= ARRAY_W_W)
                row = 0;
            else
                row = row + 1;
        end
        else
            kol = kol + 1;
    end
end

assign led[0] = ~ready;
assign led[1] = ~out_ready;
assign led[2] = ~kol[0];
assign led[3] = ~row[0];


endmodule
