module sys_array_wrapper 
#(  parameter DATA_WIDTH = 8,//Разрядность шины входных данных
	parameter ARRAY_A_W  = 4, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 3, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 3, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 4) //Количество столбцов в массиве весов
(   input  clk,
    input  reset_n,
    input  load_params,
    input  start_comp,
    input  [3:0] row,
    input  [3:0] col,
    output            ready,
    output [0:5][7:0] hex_connect
);

localparam NUM_HEX = DATA_WIDTH >> 1; // Количество необходимых семисегментных индикаторов

wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH - 1:0] input_data_a;
wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH - 1:0] input_data_w;
wire [0:ARRAY_A_W-1] [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] outputs_fetcher;

genvar ii;
// Модуль считывания матрицы A
roma
#(.FILE("../../a_data.hex"), .DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_A_W), .ARRAY_L(ARRAY_A_L)) 
rom_instance_a
(   .clk(clk), 
    .data_rom(input_data_a)
);

// Модуль считывания матрицы весов
roma 
#(.FILE("../../b_data.hex"), .DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_W_W), .ARRAY_L(ARRAY_W_L)) 
rom_instance_w
(   .clk(clk), 
    .data_rom(input_data_w)
);

// Модуль вычислителя
sys_array_fetcher #(.DATA_WIDTH(DATA_WIDTH), 
                    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
                    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
fetching_unit
(
    .clk(clk),
    .reset_n(reset_n),
    .load_params(~load_params),
    .start_comp(~start_comp),
    .input_data_a(input_data_a),
    .input_data_w(input_data_w),
    .ready(ready),
    .out_data(outputs_fetcher)
);

// Генерация модулей для семисегментных переключателей
generate
    for (ii=0; ii<NUM_HEX; ii=ii+1) begin : generate_hexes
        seg7_tohex hex_converter_i1
        (   .code(outputs_fetcher[row][col][4*ii +: 4]), 
            .hexadecimal(hex_connect[ii])
        );
    end
endgenerate

endmodule
