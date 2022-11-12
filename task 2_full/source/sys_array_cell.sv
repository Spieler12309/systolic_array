//Основной вычислительный модуль систолического массива.

module sys_array_cell
#(parameter DATA_WIDTH = 8) //Разрядность шины входных данных
(   input                                     clk,
    input                                     reset_n,
    input                                     weight_load,
    input      signed [DATA_WIDTH - 1:0]      input_data,
    input      signed [2 * DATA_WIDTH - 1:0]  prop_data,
    input      signed [DATA_WIDTH - 1:0]      weight_data,
     
    output reg signed [2 * DATA_WIDTH - 1:0]  out_data,
    output reg signed [DATA_WIDTH - 1:0]      prop_param
);

reg signed [DATA_WIDTH - 1:0] weight;

always @(posedge clk)
begin
    if (~reset_n) begin // Сброс
        out_data <= {2 * DATA_WIDTH{1'b0}};
        weight <= {DATA_WIDTH{1'b0}};
    end
    else if (weight_load) begin // Загрузка параметра
        weight <= weight_data;
    end
    else begin // Вычисление данных
        // Задание 1. Реализуйте основные вычисления модуля
        out_data <= prop_data + {{DATA_WIDTH{1'b0}}, input_data} * {{DATA_WIDTH{1'b0}}, weight};
        prop_param <= input_data;
    end
end
    
endmodule
