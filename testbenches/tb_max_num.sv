`timescale 1 ns / 100 ps

module tb_max_num
#(parameter DATA_WIDTH = 8);//Разрядность шины входных данных

reg signed [0:9] [0:9] [DATA_WIDTH-1:0] input_data;
reg [0:9] [9:0] output_data;

reg clk, reset_n, start;
reg signed [0:9] [DATA_WIDTH-1:0] matrix;
wire [9:0] classes;
wire ready;
integer i;

max_num #(.DATA_WIDTH(DATA_WIDTH)) max_num0 (
	.clk(clk),
	.reset_n(reset_n),
    .start(start),
	.matrix(matrix),
	.classes(classes),
	.ready(ready)
);

initial
begin
    input_data[0] = 'h00010203040506070809;
    output_data[0]= 10'b1000000000;

    input_data[1] = 'h09080706050403020100;
    output_data[1]= 10'b0000000001;

    input_data[2] = 'h090f0706050403020100;
    output_data[2]= 10'b0000000010;
    
    input_data[3] = 'h090807060f0403020100;
    output_data[3]= 10'b0000010000;
end

initial begin
    clk = 0;
    forever #10 clk=!clk;
end

initial
    begin
        reset_n=0; start = 0;
        #80; reset_n=1;
        #20;
        for (i = 0; i < 4; i = i + 1)
        begin
            matrix = input_data[i];
            start = 1'b1;
            #20;
            start = 1'b0;
            while (~ready)
                #20;
            if (classes != output_data[i])
            begin
                $display("FAIL. Test number = %d", i);
                //$finish;
            end
        end
        $display("PASSED");
        $finish;
    end
endmodule
