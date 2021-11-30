//Модуль вывода данных размером 16 бит на семисементные индикаторы.

module data_to_segments
(	input 		clk,
	input 		[15:0] data,
   output 	   [7:0] segment,
	output reg  [3:0] digit
);

reg [3:0] code;

seg7_tohex sh1
(   .code(code),
    .hexadecimal(segment)
);

wire clk2;

clock_divider #(.DIVIDE_LEN(17))
cd1
(	.clk(clk),
	.div_clock(clk2)
);

initial
begin
	digit = 4'b1110;
	code = 4'd0;
end

always @(posedge clk2)
begin
	case(digit)
		'b0111: begin
				      code = data[3:0];
						digit = 4'b1110;
				  end
		'b1110: begin
				      code = data[7:4];
						digit = 4'b1101;
				  end
		'b1101: begin
				      code = data[11:8];
						digit = 4'b1011;
				  end 
		'b1011: begin
				      code = data[15:12];
						digit = 4'b0111;
				  end 
		default: begin
					    code = 4'd2;
						 digit = 4'b1110;
				   end
	endcase
	
end

endmodule
