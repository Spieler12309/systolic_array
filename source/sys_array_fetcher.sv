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

module sys_array_fetcher

#(
	parameter DATA_WIDTH = 8,
	parameter ARRAY_W_W = 2, //Строк в массиве весов
	parameter ARRAY_W_L = 5, //Столбцов в массиве весов
	parameter ARRAY_A_W = 5, //Строк в массиве данных
	parameter ARRAY_A_L = 2, //Столбцов в массиве данных
    parameter ARRAY_MAX_W = 10, //Максимальное число строк в систолическом массиве
    parameter ARRAY_MAX_L = 10, //Максимальное число столбцов в систолическом массиве
    parameter ARRAY_MAX_A_L = 10,
    parameter OUT_SIZE = 100)

(input  clk,
    input  reset_n,
    input  start_comp,
    input [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] input_data_b,
    input [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] input_data_w,

    output reg ready,
    output reg [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] out_data);


reg [ARRAY_MAX_L-1:0] [1:0] control_sr_read; // Контрольные сигналы регистра чтения
reg [ARRAY_MAX_W-1:0] [1:0] control_sr_write; // Контрольные сигналы регистра записи

reg [0:ARRAY_MAX_W-1] [0:ARRAY_MAX_L-1] [DATA_WIDTH-1:0] input_data_w_max;
reg [0:ARRAY_MAX_L-1] [0:ARRAY_MAX_A_L-1] [DATA_WIDTH-1:0] input_data_b_max;

reg  load_params;

wire en;
wire [0:ARRAY_MAX_L-1] [DATA_WIDTH-1:0] input_sys_array;
wire [0:ARRAY_MAX_L-1] [DATA_WIDTH-1:0] empty_wire_reads;
wire [0:ARRAY_MAX_L-1] [0:ARRAY_MAX_A_L-1] [DATA_WIDTH-1:0] empty_wire2_reads;
wire [0:ARRAY_MAX_W-1] [0:ARRAY_MAX_A_L-1] [2*DATA_WIDTH-1:0] empty_wire_writes;
wire [0:ARRAY_MAX_W-1] [2*DATA_WIDTH-1:0] empty_wire2_writes;
wire [0:ARRAY_MAX_W-1] [2*DATA_WIDTH-1:0] output_sys_array;
wire [0:ARRAY_MAX_W-1] [0:ARRAY_MAX_A_L-1] [2*DATA_WIDTH-1:0] output_wire;
wire split_ready;
split_type split_out_data [OUT_SIZE];


wire [15:0] first_none;
wire [15:0] last;

sys_array_split #(
    .ARRAY_MAX_W ( ARRAY_MAX_W ),
    .ARRAY_MAX_L ( ARRAY_MAX_L ),
    .ARRAY_MAX_A_L(ARRAY_MAX_A_L),
    .OUT_SIZE    ( OUT_SIZE    ))
 u_sys_array_split1 (
    .clk         ( clk            ),
    .reset_n     ( reset_n        ),
    .ARRAY_W_W   ( ARRAY_W_W      ),
    .ARRAY_W_L   ( ARRAY_W_L      ),
    .ARRAY_A_W   ( ARRAY_A_W      ),
    .ARRAY_A_L   ( ARRAY_A_L      ),

    .ready       ( split_ready    ),
    .out_data    ( split_out_data ),
    .first_none  ( first_none     ),
    .last        ( last           )
);

genvar i,j;

generate
    for (i=0;i<ARRAY_MAX_L; i=i+1) begin: generate_reads_shift_reg
        shift_reg #(.DATA_WIDTH(DATA_WIDTH), .LENGTH(ARRAY_MAX_A_L)) reads
        (   .clk(clk),
            .reset_n(reset_n),
            .ctrl_code(control_sr_read[i]),
            .data_in(input_data_b_max[i]),
            .data_write(empty_wire_reads[i]),
            .en(en),
            .data_read(input_sys_array[i]),
            .data_out(empty_wire2_reads[i])
        );
    end
endgenerate

generate
    for (i=0;i<ARRAY_MAX_W;i=i+1) begin: generate_writes_shift_reg
        shift_reg #(.DATA_WIDTH(2*DATA_WIDTH), .LENGTH(ARRAY_MAX_A_L)) writes
        (   .clk(clk),
            .reset_n(reset_n),
            .ctrl_code(control_sr_write[i]),
            .data_in(empty_wire_writes[i]),
            .data_write(output_sys_array[i]),
            .en(en),
            .data_read(empty_wire2_writes[i]),
            .data_out(output_wire[i])
        );
    end
endgenerate

reg [15:0] len_w_l;
reg [15:0] len_w_w;
reg [15:0] len_a_l;
reg [15:0] len_a_w;
reg reset_n_basic;

sys_array_basic #(  .DATA_WIDTH(DATA_WIDTH), 
                    .ARRAY_MAX_W(ARRAY_MAX_W), .ARRAY_MAX_L(ARRAY_MAX_L)) 
systolic_array
(
    .clk(clk),
    .reset_n(reset_n),// && reset_n_basic),
    .weights_load(load_params),
    .array_w_l(len_a_w),
    .weight_data(input_data_w_max),
    .input_data(input_sys_array),
    .output_data(output_sys_array)
);

reg prev_split_ready;
reg start_comp_split;

initial begin
    prev_split_ready = 1'b0;
end

always @(posedge clk) begin
    if ((prev_split_ready == 1'b0) && (split_ready == 1'b1))
        start_comp_split <= 1'b1;
    else
        start_comp_split <= 1'b0;
    prev_split_ready <= split_ready;
end

reg [15:0] fetch_len; // Счетчик

reg signed [16:0] cur; // Счетчик
reg [15:0] cnt; // Счетчик
reg [15:0] cnt_input_data_b_max_w; // Счетчик
reg [15:0] cnt_input_data_b_max_l; // Счетчик

reg [15:0] cnt_input_data_w_max_w; // Счетчик
reg [15:0] cnt_input_data_w_max_l; // Счетчик

reg [15:0] cnt_output_data_max_w; // Счетчик
reg [15:0] cnt_output_data_max_l; // Счетчик


always @(posedge clk)
begin
    if (~reset_n) begin // reset
        cur <= -1;
        cnt <= 15'd0;
        control_sr_read <= {ARRAY_MAX_L*2{1'b0}};
        control_sr_write <= {ARRAY_MAX_W*2{1'b0}};
        ready <= 1'b0;
        input_data_b_max <= 'b0;
        input_data_w_max <= 'b0;
        cnt_input_data_b_max_w <= 16'd0;
        cnt_input_data_b_max_l <= 16'd0;
        cnt_input_data_w_max_w <= 16'd0;
        cnt_input_data_w_max_l <= 16'd0;
        cnt_output_data_max_w <= 16'd0;
        cnt_output_data_max_l <= 16'd0;
        out_data <= 'b0;
        load_params <= 1'b0;
        
        fetch_len <= 'b0;
        reset_n_basic <= 1'b1;
    end
    else if(en && start_comp_split) begin // Получено разбиение матриц на подматрицы
        cur <= first_none;
        cnt <= 15'd0;
        len_w_l <= 'b0;
        len_w_w <= 'b0;
        len_a_l <= 'b0;
        len_a_w <= 'b0;
    end
    else if (en && cur >= 0 && cur < last) begin // Начат процесс вычисления подматриц
        if (cnt == 0) begin // Задание сигналова на первом такте вычислений
            len_w_l <= (split_out_data[cur].A_L_1 - split_out_data[cur].A_L_0 + 1);
            len_w_w <= (split_out_data[cur].A_W_1 - split_out_data[cur].A_W_0 + 1);
            len_a_l <= (split_out_data[cur].B_L_1 - split_out_data[cur].B_L_0 + 1);
            len_a_w <= (split_out_data[cur].B_W_1 - split_out_data[cur].B_W_0 + 1);
            reset_n_basic <= 1'b0;
            if ((cnt_input_data_b_max_w > (split_out_data[cur].B_W_1 - split_out_data[cur].B_W_0)) &&
                (cnt_input_data_w_max_w > (split_out_data[cur].A_W_1 - split_out_data[cur].A_W_0))) begin
                cnt <= cnt + 'd1;
                load_params <= 1'b1;
                control_sr_read <= {ARRAY_MAX_L{2'b01}};
            end
            else begin
                if (cnt_input_data_b_max_w <= (split_out_data[cur].B_W_1 - split_out_data[cur].B_W_0)) begin
                    cnt_input_data_b_max_l <= ((cnt_input_data_b_max_l + 1) > (split_out_data[cur].B_L_1 - split_out_data[cur].B_L_0)) ?
                                                0 : (cnt_input_data_b_max_l + 1);
                    cnt_input_data_b_max_w <= ((cnt_input_data_b_max_l + 1) > (split_out_data[cur].B_L_1 - split_out_data[cur].B_L_0)) ?
                                                (cnt_input_data_b_max_w + 1) : cnt_input_data_b_max_w;
                    input_data_b_max[cnt_input_data_b_max_w][cnt_input_data_b_max_l] <= input_data_b[split_out_data[cur].B_W_0 + cnt_input_data_b_max_w][split_out_data[cur].B_L_0 + cnt_input_data_b_max_l];
                end
                
                if (cnt_input_data_w_max_w <= (split_out_data[cur].A_W_1 - split_out_data[cur].A_W_0)) begin
                    cnt_input_data_w_max_l <= ((cnt_input_data_w_max_l + 1) > (split_out_data[cur].A_L_1 - split_out_data[cur].A_L_0)) ?
                                                0 : (cnt_input_data_w_max_l + 1);
                    cnt_input_data_w_max_w <= ((cnt_input_data_w_max_l + 1) > (split_out_data[cur].A_L_1 - split_out_data[cur].A_L_0)) ?
                                                (cnt_input_data_w_max_w + 1) : cnt_input_data_w_max_w;
                    input_data_w_max[cnt_input_data_w_max_w][cnt_input_data_w_max_l] <= input_data_w[split_out_data[cur].A_W_0 + cnt_input_data_w_max_w][split_out_data[cur].A_L_0 + cnt_input_data_w_max_l];
                end
            end
        end
        else if (cnt == 1) begin // Задание сигналова на первом такте вычислений
            control_sr_read[ARRAY_MAX_L-1:1] <= {2*(ARRAY_MAX_L-1){1'b0}};
            control_sr_read[0] <= 2'b11;
            cnt <= cnt+1'b1;
            fetch_len <= len_a_l + len_a_w + len_w_w + 1;
            reset_n_basic <= 1'b1;
            load_params <= 1'b0;
        end
        else begin 
            if (cnt < len_w_l + 1) // Включение регистров чтения
                control_sr_read[cnt-1] = 2'b11; 
            if ((cnt > len_a_l) && (cnt < len_a_l + len_w_l + 1)) // Старт отключения регистров чтения
                control_sr_read[cnt - len_a_l - 1] = 2'b00;
            if ((cnt > len_w_l + 2) && (cnt < len_w_l + len_w_w + 3)) // Включение регистров записи
                control_sr_write[cnt - len_w_l - 3] = 2'b10;
            if ((cnt > len_w_l + len_a_l + 2) && (cnt <= fetch_len + 1)) // Старт отключения регистров записи
                control_sr_write[cnt-(len_w_l + len_a_l)-3] = 2'b00;
            
            if (cnt <= fetch_len+2)
                cnt = cnt+1'b1;
            else begin 
                if (cnt == fetch_len+3) begin
                    if (cnt_output_data_max_w > (split_out_data[cur].O_W_1 - split_out_data[cur].O_W_0))
                        cnt <= cnt + 'd1;
                    else begin
                        cnt_output_data_max_l <= ((cnt_output_data_max_l + 1) > (split_out_data[cur].O_L_1 - split_out_data[cur].O_L_0)) ?
                                                    0 : (cnt_output_data_max_l + 1);
                        cnt_output_data_max_w <= ((cnt_output_data_max_l + 1) > (split_out_data[cur].O_L_1 - split_out_data[cur].O_L_0)) ?
                                                    (cnt_output_data_max_w + 1) : cnt_output_data_max_w;
                        out_data[cnt_output_data_max_w + split_out_data[cur].O_W_0][cnt_output_data_max_l + split_out_data[cur].O_L_0] <= 
                        out_data[cnt_output_data_max_w + split_out_data[cur].O_W_0][cnt_output_data_max_l + split_out_data[cur].O_L_0] + 
                        output_wire[cnt_output_data_max_w][cnt_output_data_max_l + ARRAY_MAX_A_L - len_a_l];
                    end
                end
                else begin
                    cur <= cur + 1;
                    cnt <= 16'd0;
                    control_sr_read <= {ARRAY_MAX_L*2{1'b0}};
                    control_sr_write <= {ARRAY_MAX_W*2{1'b0}};
                    input_data_b_max <= 'b0;
                    input_data_w_max <= 'b0;
                    cnt_input_data_b_max_w <= 16'd0;
                    cnt_input_data_b_max_l <= 16'd0;
                    cnt_input_data_w_max_w <= 16'd0;
                    cnt_input_data_w_max_l <= 16'd0;
                    cnt_output_data_max_w <= 16'd0;
                    cnt_output_data_max_l <= 16'd0;
                end  
            end          
        end
    end
    else if (cur >= $signed(last))
    begin
        ready <= 1'b1;
        cur <= 0;
        
    end

end
endmodule