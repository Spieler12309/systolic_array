module sys_array_wrapper_mnist
#(  parameter DATA_WIDTH = 16,//Разрядность шины входных данных
	parameter ARRAY_A_W  = 1, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 784, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 784, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 10, //Количество столбцов в массиве весов
    parameter IMAGES = 10)
(   input                      clk,
    input                      reset_n,
    input                      load_params,
    input                      start_comp,
    input  [3:0]               image_num,
    output                     ready,
    output [7:0]               hex_connect,
    output [9:0]               classes
);

wire [0:IMAGES-1] [0:ARRAY_A_L-1] [DATA_WIDTH - 1:0] images;
wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH - 1:0] input_image;
wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH - 1:0] weights;
wire signed [0:ARRAY_A_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0]   bias;
wire signed [0:ARRAY_A_W-1] [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] outputs_fetcher;
wire signed [0:ARRAY_A_W-1] [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] matrix_sum;
wire ready1;
reg ready1_prev;
reg ready2;

always @(posedge clk)
    ready1_prev <= ready1;

always @(posedge clk)
    if (ready1 > ready1_prev)
        ready2 = 1'b1;
    else
        ready2 = 1'b0;

// Модуль считывания изображений
roma 
#(.FILE("../../images.hex"), .DATA_WIDTH(DATA_WIDTH), .ARRAY_W(IMAGES), .ARRAY_L(ARRAY_A_L)) 
rom_instance_images
(   .clk(clk),
    .data_rom(images)
);

// Модуль считывания матрицы весов
roma 
#(.FILE("../../weight.hex"), .DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_W_W), .ARRAY_L(ARRAY_W_L)) 
rom_instance_weight
(   .clk(clk), 
    .data_rom(weights)
);

// Модуль считывания матрицы весов
roma 
#(.FILE("../../bias.hex"), .DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_A_W), .ARRAY_L(ARRAY_W_L)) 
rom_instance_bias
(   .clk(clk), 
    .data_rom(bias)
);

genvar ii, jj;
generate
    for (ii = 0; ii < ARRAY_A_L; ii++) begin : input_image_generation
        assign input_image[0][ii] = images[image_num][ii];
    end
endgenerate

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
    .input_data_a(input_image),
    .input_data_w(weights),
    .ready(ready1),
    .out_data(outputs_fetcher)
);


generate
    for (ii = 0; ii < ARRAY_A_W; ii++) begin : outputs_fetcher_generation_i
        for (jj = 0; jj < ARRAY_W_L; jj++) begin : outputs_fetcher_generation_j
            assign matrix_sum[ii][jj] = ready1
                                        ? outputs_fetcher[ii][jj] + bias[ii][jj] 
                                        : {2*DATA_WIDTH{1'b0}};
		  end
	 end
endgenerate

max_num #(.DATA_WIDTH(2 * DATA_WIDTH)) //Разрядность шины входных данных
max_num0
(   .clk(clk),
    .reset_n(reset_n && load_params),
    .start(ready2),
    .matrix(matrix_sum[0]),

    .classes(classes),
    .ready(ready)
);

// Генерация модулей для семисегментных переключателей
seg7_tohex_mnist hex_converter_i1
(   .code(classes), 
    .hexadecimal(hex_connect)
);

assign led = classes;

endmodule
