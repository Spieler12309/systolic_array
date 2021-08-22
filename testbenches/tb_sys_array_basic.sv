`timescale 1 ns / 100 ps

module tb_sys_array_basic
#(
	parameter DATA_WIDTH=8,
	parameter ARRAY_W=5,
	parameter ARRAY_L=2,
    parameter ARRAY_MAX_W = 10,
    parameter ARRAY_MAX_L = 10);
	
reg [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] parameter_data;
wire [0:ARRAY_MAX_W-1] [0:ARRAY_MAX_L-1] [DATA_WIDTH-1:0] weight_data;
reg [0:ARRAY_MAX_L-1] [DATA_WIDTH-1:0] input_module;
wire [0:ARRAY_MAX_W-1] [2*DATA_WIDTH-1:0] out_module;
reg clk, reset_n, param_load;

sys_array_basic #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_MAX_W(ARRAY_MAX_W), .ARRAY_MAX_L(ARRAY_MAX_L)) systolic_array(
	.clk(clk),
	.reset_n(reset_n),
	.weights_load(param_load),
    .ARRAY_W_L(ARRAY_L -1 ),
	.weight_data(weight_data),
	.input_data(input_module),
	.output_data(out_module)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

genvar i;
generate
    for (i = 0; i < ARRAY_MAX_W; i++) begin : generate_weight_data
        if (i < ARRAY_W)
            assign weight_data[i] = ({'b0, parameter_data[i]}) << (DATA_WIDTH * (ARRAY_MAX_L - ARRAY_L));
        else
            assign weight_data[i] = 'b0;
	 end
endgenerate

integer ii, jj;

initial
    begin
        reset_n=0; param_load = 0;
        #80; reset_n=1;
        #20;

        for (ii = 0; ii < ARRAY_W; ii = ii + 1) begin
            for (jj = 0; jj < ARRAY_L; jj = jj + 1) begin
                parameter_data[ii][jj] = ARRAY_L*ii + jj + 1;
            end
        end
        param_load = 1;
        input_module = 'b0;
        //#20; param_load = 0; #10; input_module[0] = 8'd1; //1st clk cycle
        //#20; input_module[0] = 8'd5; input_module[1] = 8'd2; //2nd clk cycle
        //#20; input_module[0] = 8'd9; input_module[1] = 8'd6; input_module[2] = 8'd3; //3rd clk cycle
        //#20; input_module[0] = 8'd13; input_module[1] = 8'd10; input_module[2] = 8'd7; input_module[3] = 8'd4; //4th clock cycle
        //#20; input_module[1] = 8'd14; input_module[2] = 8'd11; input_module[3] = 8'd8; //5th clock cycle
        //#20; input_module[2] = 8'd15; input_module[3] = 8'd12; //6th clock cycle
        //#20; input_module[3] = 8'd16; //7th clk cycle
        #20; param_load = 0; 
        #10; input_module[0] = 8'd1; //1st clk cycle
        #20; input_module[0] = 8'd3; input_module[1] = 8'd2; //2nd clk cycle
        #20; input_module[0] = 8'd5; input_module[1] = 8'd4; //3nd clk cycle
        #20; input_module[0] = 8'd7; input_module[1] = 8'd6; //4nd clk cycle
        #20; input_module[0] = 8'd9; input_module[1] = 8'd8; //5nd clk cycle
        #20; input_module[1] = 8'd10; //6nd clk cycle
        #500;
        $finish;
    end
endmodule
