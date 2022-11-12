`timescale 1 ns / 100 ps
`include "defines.svh"

module tb_sys_array_cell
#(parameter DATA_WIDTH=8);
	
reg  signed [DATA_WIDTH - 1:0] input_data;
reg  signed [2*DATA_WIDTH-1:0] prop_data;
reg  signed [DATA_WIDTH-1:0] param_data;

wire signed [2*DATA_WIDTH-1:0] out_data_simple;
wire signed [DATA_WIDTH-1:0] prop_param_simple;

wire signed [2*DATA_WIDTH-1:0] out_data_load;
wire signed [DATA_WIDTH-1:0] prop_param_load;

reg clk, reset_n, param_load;

sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) systolic_array_cell(
	.clk(clk),
	.reset_n(reset_n),
    .param_load(param_load),
	.input_data(input_data),
	.prop_data(prop_data),
	.param_data(param_data),
	.out_data(out_data_simple),
    .prop_param(prop_param_simple)
);

sys_array_cell #(.DATA_WIDTH(DATA_WIDTH), .TYPE(simple)) systolic_array_cell2(
	.clk(clk),
	.reset_n(reset_n),
    .param_load(),
	.input_data(input_data),
	.prop_data(prop_data),
	.param_data(param_data),
	.out_data(out_data_load),
    .prop_param(prop_param_load)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

reg [0:15] [31:0] input_data_arr = {};
reg [0:15] [31:0] param_data_arr = {};
reg [0:15] [31:0] prop_data_arr = {};

reg [2*DATA_WIDTH - 1: 0] res;

initial
    begin
        reset_n = 1'b0; 
        param_load = 1'b0;

        for (int i = 0; i < 15; i++) 
        begin
            #20;
            param_data <= param_data_arr[i];
            input_data <= input_data_arr[i];
            prop_data <= prop_data_arr[i];
            param_load <= 1'b1;
            #20;
            param_load <= 1'b0;
            #20;

            res = prop_data_arr[i] + input_data_arr[i] * param_data_arr[i];

            $display("time = ", $time, " ", prop_data, " + ", input_data, " * ", param_data, " = [", res, ", ", out_data_simple, ", ", out_data_load, "]");
            if (out_data_simple != res || out_data_load != res)
            begin
                $$display("ERROR\n");
                $display("time = ", $time, " ", prop_data, " + ", input_data, " * ", param_data, " = [", res, ", ", out_data_simple, ", ", out_data_load, "]");
                $finish;
            end   
        end

        $finish;
    end
endmodule
