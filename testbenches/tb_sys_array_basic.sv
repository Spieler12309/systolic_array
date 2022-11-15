`timescale 1 ns / 100 ps

module tb_sys_array_basic
#(
    parameter DATA_WIDTH = 8,//Разрядность шины входных данных
	parameter ARRAY_A_W  = 4, //Количество строк в массиве данных
    parameter ARRAY_A_L  = 3, //Количество столбцов в массиве данных
    parameter ARRAY_W_W  = 3, //Количество строк в массиве весов
    parameter ARRAY_W_L  = 4);//Количество столбцов в массиве весов	
reg [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] weights_test;
reg [0:ARRAY_W_W-1] [DATA_WIDTH-1:0] inputs_test;
wire [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] outputs_test;
reg clk, reset_n, weight_load;
reg [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] input_data;

initial
begin
    input_data[0] = 'h010203;
    input_data[1] = 'h040506;
    input_data[2] = 'h070809;
    input_data[3] = 'h0a0b0c;
end

sys_array_basic #(  .DATA_WIDTH(DATA_WIDTH), 
                    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
                    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
systolic_array(
	.clk(clk),
	.reset_n(reset_n),
	.weight_load(weight_load),
	.weight_data(weights_test),
	.input_data(inputs_test),
	.output_data(outputs_test)
);

initial $dumpfile("test.vcd");
initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

integer ii, jj;

initial
    begin
        reset_n=0; weight_load = 0;
        #80; reset_n=1;
        #20;

        for (ii = 0; ii < ARRAY_W_W; ii = ii + 1) begin
            for (jj = 0; jj < ARRAY_W_L; jj = jj + 1) begin
                weights_test[ii][jj] = ARRAY_W_L*ii + jj + 1;
            end
        end
        weight_load = 1;

        #20; weight_load = 0;
        #20; inputs_test[0] = input_data[0][0];
        #20; inputs_test[0] = input_data[1][0]; inputs_test[1] = input_data[0][1];
        #20; inputs_test[0] = input_data[2][0]; inputs_test[1] = input_data[1][1]; inputs_test[2] = input_data[0][2];
        #20; inputs_test[0] = input_data[3][0]; inputs_test[1] = input_data[2][1]; inputs_test[2] = input_data[1][2]; 
        #20;                                    inputs_test[1] = input_data[3][1]; inputs_test[2] = input_data[2][2]; 
        #20;                                                                       inputs_test[2] = input_data[3][2]; 

        #500; $finish;
    end
endmodule
