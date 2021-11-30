// Данный модуль производит считывание данных из файлов и сохраняет их в регистры.
// После это с использованием сигнала change можно производить 
// поочередное считывание данных. Таким образом, проводится циклическая 
// подача восьми различных вариантов входных и выходных данных 
// основного вычислителя модуля систолического массива.

module read_data 
#(parameter DATA_WIDTH=8)(
	input clk,
	input reset_n,
	input change,

	output [2:0] code,

	output [DATA_WIDTH-1:0] inp,
	output [DATA_WIDTH-1:0] par,
	output [2*DATA_WIDTH-1:0] prop,
	output [2*DATA_WIDTH-1:0] result	
 );

wire ch;

button_debouncer deb1 (
    .clk_i(clk),
	.rst_i(),
    .sw_i(change),
 
    .sw_state_o(),
    .sw_down_o(ch),
    .sw_up_o()
); 
reg [DATA_WIDTH-1:0] data_inp [0:8];
reg [DATA_WIDTH-1:0] data_param [0:8];
reg [2*DATA_WIDTH-1:0] data_prop [0:8];
reg [2*DATA_WIDTH-1:0] data_result [0:8];

reg [2:0] code_b;

initial
	code_b = 'd0;

initial begin
    $readmemh ("../data/input.hex", data_inp);
end

initial begin
    $readmemh ("../data/param.hex", data_param);
end

initial begin
    $readmemh ("../data/prop.hex", data_prop);
end

initial begin
    $readmemh ("../data/result.hex", data_result);
end

always @(negedge reset_n or posedge ch)
begin
	if (~reset_n)
		code_b = 'd0;
	else
		if (ch)
			code_b = code_b + 1;
end

assign inp = data_inp[code_b];
assign par = data_param[code_b];
assign prop = data_prop[code_b];
assign result = data_result[code_b];

assign code = ~code_b;
 
endmodule
