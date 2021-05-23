module sys_array_fetcher
#(parameter DATA_WIDTH = 8,
parameter ARRAY_W = 4, //i
parameter ARRAY_L = 4) //j
(input  clk,
    input  reset_n,
    input  load_params,
    input  start_comp,
    input [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] input_data_a,
    input [0:ARRAY_W-1] [0:ARRAY_L-1] [DATA_WIDTH-1:0] input_data_b,

    output reg ready,
    output reg [0:ARRAY_W-1] [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] out_data
);
	 
localparam FETCH_LENGTH = (ARRAY_L+ARRAY_W*2+1); //necessary amount of clk cycles to perform fetching and get back the results
localparam PTR_LENGTH = 5;
localparam DELAY_W = ARRAY_W + 1;
localparam DELAY_L = ARRAY_L + 1;

reg [15:0] cnt; //counter
reg [ARRAY_L-1:0] [1:0] control_sr_read;
reg [ARRAY_W-1:0] [1:0] control_sr_write;

wire [0:ARRAY_L-1] [DATA_WIDTH-1:0] input_sys_array;
wire [0:ARRAY_L-1] [DATA_WIDTH-1:0] empty_wire_reads;
wire [0:ARRAY_L-1] [0:ARRAY_W-1] [DATA_WIDTH-1:0] empty_wire2_reads;
wire [0:ARRAY_W-1] [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] empty_wire_writes;
wire [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] empty_wire2_writes;
wire [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] output_sys_array;

genvar i,j;
wire [0:ARRAY_L-1] [0:ARRAY_W-1] [DATA_WIDTH-1:0] transposed_a; 
//транспонирование матрицы A
generate
    for (i=0;i<ARRAY_W;i=i+1) begin: transpose_i
        for (j=0;j<ARRAY_L;j=j+1) begin: transpose_j
            assign transposed_a[j][i] = input_data_a[i][j];
        end
    end
endgenerate

generate
    for (i=0;i<ARRAY_L;i=i+1) begin: generate_reads_shift_reg
        shift_reg #(.DATA_WIDTH(DATA_WIDTH), .LENGTH(ARRAY_W)) reads
        (   .clk(clk),
            .reset_n(reset_n),
            .ctrl_code(control_sr_read[i]),
            .data_in(transposed_a[i]),
            .data_write(empty_wire_reads[i]),
            .data_read(input_sys_array[i]),
            .data_out(empty_wire2_reads[i])
        );
    end
endgenerate
/*
Кредитный счетчик, чтобы вместить в FIFO.
Или по флагу.
*/

reg read;

wire fifo_full;
wire fifo_empty;
wire fifo_threshold;
wire fifo_overflow;
wire fifo_underflow;
wire enable;
wire [ARRAY_W-1:0][2 * DATA_WIDTH-1:0] data_out;

generate
    for (i=0;i<ARRAY_W;i=i+1) begin: generate_writes_shift_reg
        fifo_mem #(
            .DATA_WIDTH ( 2 * DATA_WIDTH ),
            .LENGTH     ( ARRAY_W     ),
            .PTR_LENGTH ( PTR_LENGTH ))
        fifo_mem_write[ARRAY_W-1:0]  (
            .clk            ( clk                    ),
            .reset_n        ( reset_n                ),
            .write          ( control_sr_write[i][1] ),
            .read           ( read                   ),
            .data_in        ( output_sys_array[i]    ),
   
            .fifo_full      ( fifo_full              ),
            .fifo_empty     ( fifo_empty             ),
            .fifo_threshold ( fifo_threshold         ),
            .fifo_overflow  ( fifo_overflow          ),
            .fifo_underflow ( fifo_underflow         ),
            .enable         ( enable                 ),
            .data_out       ( data_out[i]            )
        );
    end
endgenerate

sys_array_basic #(.DATA_WIDTH(DATA_WIDTH), .ARRAY_W(ARRAY_W), .ARRAY_L(ARRAY_L)) 
systolic_array
(   .clk(clk),
    .reset_n(reset_n),
    .param_load(load_params),
    .parameter_data(input_data_b),
    .input_module(input_sys_array),
    .out_module(output_sys_array)
);

reg [15:0] res;
always @(posedge clk)
begin
    if (~reset_n) begin // reset
        cnt <= 15'd0;
        control_sr_read <= {ARRAY_L*2{1'b0}};
        control_sr_write <= {ARRAY_W*2{1'b0}};
        ready <= 1'b0;
        res <= 'd0;
    end
    else if(enable && start_comp) begin // Начало вычислений
        cnt <= 15'd1;
        control_sr_read <= {ARRAY_L{2'b01}}; //initiate loading read registers
    end
    else if (enable && cnt > 0) begin // Основные вычисления
        if (cnt == 1) begin // Задание сигналова на первом такте вычислений
            control_sr_read[ARRAY_L-1:1] <= {2*(ARRAY_L-1){1'b0}};
            control_sr_read[0] <= 2'b11;
            cnt <= cnt+1'b1; end
        else begin // Задание логических сигналов
            if (cnt < ARRAY_L+1) // Включение регистров чтения
                control_sr_read[cnt-1] = 2'b11; 
            if ((cnt > ARRAY_W) && (cnt < ARRAY_L+ARRAY_W+1)) // Старт отклбчения регистров чтения
                control_sr_read[cnt-ARRAY_W-1] = 2'b00;
            if ((cnt > ARRAY_L+1) && (cnt < ARRAY_L+ARRAY_W+2)) // Включение регистров записи
                control_sr_write[cnt-ARRAY_L-2] = 2'b10;
            if ((cnt>ARRAY_L+ARRAY_W+1) && (cnt<=FETCH_LENGTH)) // Старт отключения регистров записи
                control_sr_write[cnt-(ARRAY_L+ARRAY_W)-2] = 2'b00;
            
            if (cnt <= FETCH_LENGTH+1)
                cnt = cnt+1'b1;
            else begin // Выдача итогового результата
                if (res < ARRAY_W) begin
                    res <= res + 1;
                end
                else begin
                    cnt <= 15'd0;
                    ready <= 1'b1;
                end
            end
        end
    end
end

// Генерация always блоков для присваивания результата
generate
    for (i=0;i<ARRAY_W;i=i+1) begin: generate_outputs_from_fifo
        always @(posedge clk)
        begin
            if ((cnt > FETCH_LENGTH + 1) && (res < ARRAY_W)) begin
                read <= 1'b1;
                out_data[i][res] <= data_out[i];                          
            end
            else begin
                read <= 1'b0;
            end
        end
    end
endgenerate

endmodule