`timescale 1 ns / 100 ps

`ifndef types
    `define types 0;
    typedef enum logic [1:0] {connect_none = 2'b00, connect_sum, connect_hor, connect_vert} operation_types;

    typedef struct packed {
        logic [15:0] n;
        logic [15:0] A_W_0, A_L_0, A_W_1, A_L_1;
        logic [15:0] B_W_0, B_L_0, B_W_1, B_L_1;
        logic [15:0] O_W_0, O_L_0, O_W_1, O_L_1;
        logic [15:0] to_n1;
        logic [15:0] to_n2;
        logic signed [16:0] parent;
        operation_types operation;
    } split_type;
`endif


module tb_sys_array_split
#(
    parameter ARRAY_MAX_W = 4,
    parameter ARRAY_MAX_L = 4,
    parameter ARRAY_MAX_A_L = 4,
    parameter OUT_SIZE = 100);
	
reg [15:0] ARRAY_W_W;
reg [15:0] ARRAY_W_L;
reg [15:0] ARRAY_A_W;
reg [15:0] ARRAY_A_L;

reg clk, reset_n, ready;

split_type out_data [OUT_SIZE];
wire [15:0] first_none;
wire [15:0] last;

sys_array_split #(.ARRAY_MAX_W(ARRAY_MAX_W), .ARRAY_MAX_L(ARRAY_MAX_L), .ARRAY_MAX_A_L(ARRAY_MAX_A_L), .OUT_SIZE(OUT_SIZE)) systolic_array_split(
	.clk(clk),
	.reset_n(reset_n),
    .ARRAY_W_W(ARRAY_W_W),
    .ARRAY_W_L(ARRAY_W_L),
    .ARRAY_A_W(ARRAY_A_W),
    .ARRAY_A_L(ARRAY_A_L),

    .ready(ready),
    .out_data(out_data),
    .first_none(first_none),
    .last(last)
);

initial $dumpvars;
initial begin
    clk = 0;
    forever #10 clk=!clk;
end

initial
    begin
        reset_n=0;
        #80; reset_n=1;
        ARRAY_W_W <= 5;
        ARRAY_W_L <= 2;
        ARRAY_A_W <= 2;
        ARRAY_A_L <= 5;
        #20;
        while (!ready) begin
            #20;
        end
        $finish;
    end
endmodule
