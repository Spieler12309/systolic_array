module seg7_tohex
(   input [3:0] code,
    output reg [7:0] hexadecimal
);

always @ (*)
begin
    case (code)
        4'b0000: hexadecimal <= 8'b11000000;//  0 - c0
        4'b0001: hexadecimal <= 8'b11111001;//  1 - f9
        4'b0010: hexadecimal <= 8'b10100100;//  2 - a4
        4'b0011: hexadecimal <= 8'b10110000;//  3 - b0
        4'b0100: hexadecimal <= 8'b10011001;//  4 - 99
        4'b0101: hexadecimal <= 8'b10010010;//  5 - 92
        4'b0110: hexadecimal <= 8'b10000010;//  6 - 82
        4'b0111: hexadecimal <= 8'b11111000;//  7 - f8
        4'b1000: hexadecimal <= 8'b10000000;//  8 - 80
        4'b1001: hexadecimal <= 8'b10010000;//  9 - 90
        4'b1010: hexadecimal <= 8'b10001000;//  a - 88
        4'b1011: hexadecimal <= 8'b10000011;//  b - 83
        4'b1100: hexadecimal <= 8'b11000110;//  c - c6
        4'b1101: hexadecimal <= 8'b10100001;//  d - a1
        4'b1110: hexadecimal <= 8'b10000110;//  e - 86
        4'b1111: hexadecimal <= 8'b10001110;//  f - 8e
        default: hexadecimal <= 8'b11111111;//  default - ff
    endcase
end
endmodule
