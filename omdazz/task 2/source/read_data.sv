// Модуль для считывания входных матриц.

module read_data
#(
	parameter DATA_WIDTH = 8,
	parameter ARRAY_W_W = 4, //Строк в массиве весов
	parameter ARRAY_W_L = 4, //Столбцов в массиве весов
	parameter ARRAY_A_W = 4, //Строк в массиве данных
	parameter ARRAY_A_L = 4) //Столбцов в массиве данных
(	input clk,
    output reg [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH - 1:0] data_rom_w,
    output reg [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH - 1:0] data_rom_b
);

genvar i, j;
reg [DATA_WIDTH-1:0] rom_w [ARRAY_W_W*ARRAY_W_L-1:0];
reg [DATA_WIDTH-1:0] rom_b [ARRAY_A_W*ARRAY_A_L-1:0];

wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH - 1:0] rom_wire_w;
wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH - 1:0] rom_wire_b;

initial begin
    $readmemh ("../data/a_data.hex", rom_w);
    $readmemh ("../data/b_data.hex", rom_b);
end

generate
    for (i=0;i<ARRAY_W_W;i=i+1) begin: generate_W_W
        for (j=0;j<ARRAY_W_L;j=j+1) begin: generate_W_L
	        assign rom_wire_w[i][j] = rom_w[ARRAY_W_L*i + j];
	    end
    end
endgenerate

generate
    for (i=0;i<ARRAY_A_W;i=i+1) begin: generate_A_W
        for (j=0;j<ARRAY_A_L;j=j+1) begin: generate_A_L
	        assign rom_wire_b[i][j] = rom_b[ARRAY_A_L*i + j];
	    end
    end
endgenerate

always @(posedge clk) 
begin 
    data_rom_w <= rom_wire_w;
    data_rom_b <= rom_wire_b;
end
endmodule
