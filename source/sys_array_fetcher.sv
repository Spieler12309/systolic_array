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
wire [0:ARRAY_W-1] [0:ARRAY_W-1] [2*DATA_WIDTH-1:0] output_wire;

genvar i,j;
wire [0:ARRAY_L-1] [0:ARRAY_W-1] [DATA_WIDTH-1:0] transposed_a; //transposing a matrix
//transpose matrix a
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
generate //переделать на FIFO
    for (i=0;i<ARRAY_W;i=i+1) begin: generate_writes_shift_reg
        shift_reg #(.DATA_WIDTH(2*DATA_WIDTH), .LENGTH(ARRAY_W)) writes
        (   .clk(clk),
            .reset_n(reset_n),
            .ctrl_code(control_sr_write[i]),
            .data_in(empty_wire_writes[i]),
            .data_write(output_sys_array[i]),
            .data_read(empty_wire2_writes[i]),
            .data_out(output_wire[i])
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

always @(posedge clk)
begin
    if (~reset_n) begin //reset case
        cnt <= 15'd0;
        control_sr_read <= {ARRAY_L*2{1'b0}};
        control_sr_write <= {ARRAY_W*2{1'b0}};
        ready <= 1'b0;
    end
    else if(start_comp) begin //initiate computation
        cnt <= 15'd1;
        control_sr_read <= {ARRAY_L{2'b01}}; //initiate loading read registers
    end
    else if (cnt>0) begin //compute the whole thing
        if (cnt == 1) begin //fetch data into first array input
            control_sr_read[ARRAY_L-1:1] <= {2*(ARRAY_L-1){1'b0}};
            control_sr_read[0] <= 2'b11;
            cnt <= cnt+1'b1; end
        else begin //fetching logic
            if (cnt < ARRAY_L+1) //enable read registers
                control_sr_read[cnt-1] = 2'b11; 

            if ((cnt > ARRAY_W) && (cnt < ARRAY_L+ARRAY_W+1)) //start disabling read registers
                control_sr_read[cnt-ARRAY_W-1] = 2'b00;

            if ((cnt > ARRAY_L+1) && (cnt < ARRAY_L+ARRAY_W+2)) //enable write registers
                control_sr_write[cnt-ARRAY_L-2] = 2'b10;

            if ((cnt>ARRAY_L+ARRAY_W+1) && (cnt<=FETCH_LENGTH)) //start disabling write registers
                control_sr_write[cnt-(ARRAY_L+ARRAY_W)-2] = 2'b00;
            
            if (cnt <= FETCH_LENGTH+1)
                cnt = cnt+1'b1;
            else begin //propagate outputs.
                cnt <= 15'd0;
                out_data <= output_wire;
                ready <= 1'b1;
            end
        end
    end
end
endmodule
