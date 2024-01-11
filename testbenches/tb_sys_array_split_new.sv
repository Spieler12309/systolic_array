module tb_sys_array_split #(
    parameter ARRAY_A_W = 5,  //Строк в массиве данных
    parameter ARRAY_A_L = 2,  //Столбцов в массиве данных
    parameter ARRAY_W_W = 2,  //Строк в массиве весов
    parameter ARRAY_W_L = 5,  //Столбцов в массиве весов    
    parameter ARRAY_W = 4, //Максимальное число строк в систолическом массиве
    parameter ARRAY_L = 4, //Максимальное число столбцов в систолическом массиве 
    parameter ARRAY_MAX_A_W = 4,
    parameter OUT_SIZE = 10
);


  reg clk, reset_n, ready, start;

  wire [15:0] n [OUT_SIZE];
  wire [15:0] A_W_0 [OUT_SIZE];
  wire [15:0] A_L_0 [OUT_SIZE];
  wire [15:0] A_W_1 [OUT_SIZE];
  wire [15:0] A_L_1 [OUT_SIZE];
  wire [15:0] B_W_0 [OUT_SIZE];
  wire [15:0] B_L_0 [OUT_SIZE];
  wire [15:0] B_W_1 [OUT_SIZE];
  wire [15:0] B_L_1 [OUT_SIZE];
  wire [15:0] O_W_0 [OUT_SIZE];
  wire [15:0] O_L_0 [OUT_SIZE];
  wire [15:0] O_W_1 [OUT_SIZE];
  wire [15:0] O_L_1 [OUT_SIZE];
  wire [15:0] to_n1 [OUT_SIZE];
  wire [15:0] to_n2 [OUT_SIZE];
  wire signed [16:0] parent [OUT_SIZE];
  wire [15:0] first_none;
  wire [15:0] last;

  sys_array_split #(
      .ARRAY_W      (ARRAY_W),
      .ARRAY_L      (ARRAY_L),
      .ARRAY_MAX_A_W(ARRAY_MAX_A_W),
      .OUT_SIZE     (OUT_SIZE)
  ) systolic_array_split (
      .clk(clk),
      .reset_n(reset_n),
      .start(start),
      .ARRAY_W_W(ARRAY_W_W),
      .ARRAY_W_L(ARRAY_W_L),
      .ARRAY_A_W(ARRAY_A_W),
      .ARRAY_A_L(ARRAY_A_L),

      .ready(ready),
      .n(n),
      .A_W_0(A_W_0),
      .A_L_0(A_L_0),
      .A_W_1(A_W_1),
      .A_L_1(A_L_1),
      .B_W_0(B_W_0),
      .B_L_0(B_L_0),
      .B_W_1(B_W_1),
      .B_L_1(B_L_1),
      .O_W_0(O_W_0),
      .O_L_0(O_L_0),
      .O_W_1(O_W_1),
      .O_L_1(O_L_1),
      .to_n1(to_n1),
      .to_n2(to_n2),
      .parent(parent),

      .first_none(first_none),
      .last(last)
  );

  initial $dumpvars;
  initial begin
    clk = 0;
    forever #10 clk = !clk;
  end

  initial begin
    reset_n = 0;
    start   = 0;
    #20;
    reset_n = 1;
    #20;
    start = 1;
    #20;
    start = 0;
    #20;
    while (!ready) begin
      #20;
    end
    $finish;
  end
endmodule
