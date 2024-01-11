module sys_array_split_new #(
    parameter ARRAY_W = 10, //Максимальное число строк в систолическом массиве
    parameter ARRAY_L = 10, //Максимальное число столбцов в систолическом массиве 
    parameter ARRAY_MAX_A_W = 10,
    parameter OUT_SIZE = 100
) (
    input clk,
    input reset_n,
    input start,
    input [15:0] ARRAY_W_W,
    input [15:0] ARRAY_W_L,
    input [15:0] ARRAY_A_W,
    input [15:0] ARRAY_A_L,

    output reg ready,

    output reg [15:0] n[OUT_SIZE],
    output reg [15:0] A_W_0[OUT_SIZE],
    output reg [15:0] A_L_0[OUT_SIZE],
    output reg [15:0] A_W_1[OUT_SIZE],
    output reg [15:0] A_L_1[OUT_SIZE],
    output reg [15:0] B_W_0[OUT_SIZE],
    output reg [15:0] B_L_0[OUT_SIZE],
    output reg [15:0] B_W_1[OUT_SIZE],
    output reg [15:0] B_L_1[OUT_SIZE],
    output reg [15:0] O_W_0[OUT_SIZE],
    output reg [15:0] O_L_0[OUT_SIZE],
    output reg [15:0] O_W_1[OUT_SIZE],
    output reg [15:0] O_L_1[OUT_SIZE],
    output reg [15:0] to_n1[OUT_SIZE],
    output reg [15:0] to_n2[OUT_SIZE],
    output reg signed [16:0] parent[OUT_SIZE],
    output reg [15:0] first_none,
    output reg [15:0] last
);

  reg [15:0] cnt, cur;

  always @(posedge clk) begin
    if (~reset_n) begin
      cnt <= 16'd0;
      cur <= 16'd0;
      ready <= 1'b0;
      last <= 16'd0;
      first_none <= 16'd0;
      n <= '{OUT_SIZE{15'b0}};
      A_W_0 <= '{OUT_SIZE{15'b0}};
      A_L_0 <= '{OUT_SIZE{15'b0}};
      A_W_1 <= '{OUT_SIZE{15'b0}};
      A_L_1 <= '{OUT_SIZE{15'b0}};
      B_W_0 <= '{OUT_SIZE{15'b0}};
      B_L_0 <= '{OUT_SIZE{15'b0}};
      B_W_1 <= '{OUT_SIZE{15'b0}};
      B_L_1 <= '{OUT_SIZE{15'b0}};
      O_W_0 <= '{OUT_SIZE{15'b0}};
      O_L_0 <= '{OUT_SIZE{15'b0}};
      O_W_1 <= '{OUT_SIZE{15'b0}};
      O_L_1 <= '{OUT_SIZE{15'b0}};
      to_n1 <= '{OUT_SIZE{15'b0}};
      to_n2 <= '{OUT_SIZE{15'b0}};
      parent <= '{OUT_SIZE{16'b0}};

    end else if (start) begin
      cnt <= 16'd0;
      cur <= 16'd0;
      ready <= 1'b0;
      first_none <= 16'd0;
      last <= 16'd0;
      n <= '{OUT_SIZE{15'b0}};
      A_W_0 <= '{OUT_SIZE{15'b0}};
      A_L_0 <= '{OUT_SIZE{15'b0}};
      A_W_1 <= '{OUT_SIZE{15'b0}};
      A_L_1 <= '{OUT_SIZE{15'b0}};
      B_W_0 <= '{OUT_SIZE{15'b0}};
      B_L_0 <= '{OUT_SIZE{15'b0}};
      B_W_1 <= '{OUT_SIZE{15'b0}};
      B_L_1 <= '{OUT_SIZE{15'b0}};
      O_W_0 <= '{OUT_SIZE{15'b0}};
      O_L_0 <= '{OUT_SIZE{15'b0}};
      O_W_1 <= '{OUT_SIZE{15'b0}};
      O_L_1 <= '{OUT_SIZE{15'b0}};
      to_n1 <= '{OUT_SIZE{15'b0}};
      to_n2 <= '{OUT_SIZE{15'b0}};
      parent <= '{OUT_SIZE{16'b0}};
    end else begin
      if (cnt == 0) begin
        n[cnt] <= cnt;

        A_W_0[cnt] <= 'b0;
        A_L_0[cnt] <= 'b0;
        A_W_1[cnt] <= ARRAY_A_W - 1;
        A_L_1[cnt] <= ARRAY_A_L - 1;

        B_W_0[cnt] <= 'b0;
        B_L_0[cnt] <= 'b0;
        B_W_1[cnt] <= ARRAY_W_W - 1;
        B_L_1[cnt] <= ARRAY_W_L - 1;

        O_W_0[cnt] <= 'b0;
        O_L_0[cnt] <= 'b0;
        O_W_1[cnt] <= ARRAY_A_W - 1;
        O_L_1[cnt] <= ARRAY_W_L - 1;

        cur <= cnt;
        parent[cnt] = -1;

        cnt <= cnt + 1;
      end else begin
        if (cur < cnt) begin
          //LEN_A_W <= (A_W_1[cur] - A_W_0[cur]);
          //LEN_A_L <= (A_L_1[cur] - A_L_0[cur]);
          //LEN_B_W <= (B_W_1[cur] - B_W_0[cur]);
          //LEN_B_L <= (B_L_1[cur] - B_L_0[cur]);
          if (!((((A_L_1[cur] - A_L_0[cur])) < ARRAY_L) && (((A_W_1[cur] - A_W_0[cur])) < ARRAY_MAX_A_W) && ((B_L_1[cur] - B_L_0[cur]) < ARRAY_W)))
                begin
            if ((((A_W_1[cur] - A_W_0[cur])) >= ((A_L_1[cur] - A_L_0[cur]))) && (((A_W_1[cur] - A_W_0[cur])) >= (B_L_1[cur] - B_L_0[cur]))) begin

              n[cnt] <= cnt;

              A_W_0[cnt] <= A_W_0[cur];
              A_L_0[cnt] <= A_L_0[cur];
              A_W_1[cnt] <= A_W_0[cur] + (((A_W_1[cur] - A_W_0[cur]) + 1) >> 1) - 1;
              A_L_1[cnt] <= A_L_1[cur];

              B_W_0[cnt] <= B_W_0[cur];
              B_L_0[cnt] <= B_L_0[cur];
              B_W_1[cnt] <= B_W_1[cur];
              B_L_1[cnt] <= B_L_1[cur];

              O_W_0[cnt] <= O_W_0[cur];
              O_L_0[cnt] <= O_L_0[cur];
              O_W_1[cnt] <= O_W_0[cur] + (((A_W_1[cur] - A_W_0[cur]) + 1) >> 1) - 1;
              O_L_1[cnt] <= O_L_1[cur];

              to_n1[cur] <= cnt;



              n[cnt+1] <= cnt + 1;

              A_W_0[cnt+1] <= A_W_0[cur] + (((A_W_1[cur] - A_W_0[cur]) + 1) >> 1);
              A_L_0[cnt+1] <= A_L_0[cur];
              A_W_1[cnt+1] <= A_W_1[cur];
              A_L_1[cnt+1] <= A_L_1[cur];

              B_W_0[cnt+1] <= B_W_0[cur];
              B_L_0[cnt+1] <= B_L_0[cur];
              B_W_1[cnt+1] <= B_W_1[cur];
              B_L_1[cnt+1] <= B_L_1[cur];

              O_W_0[cnt+1] <= O_W_0[cur] + (((A_W_1[cur] - A_W_0[cur]) + 1) >> 1);
              O_L_0[cnt+1] <= O_L_0[cur];
              O_W_1[cnt+1] <= O_W_1[cur];
              O_L_1[cnt+1] <= O_L_1[cur];

              to_n2[cur] <= cnt + 1;
              cnt <= cnt + 2;
            end else begin
              if (((B_L_1[cur] - B_L_0[cur]) >= ((A_L_1[cur] - A_L_0[cur]))) && ((B_L_1[cur] - B_L_0[cur]) >= ((A_W_1[cur] - A_W_0[cur]))))
                        begin

                n[cnt] <= cnt;

                A_W_0[cnt] <= A_W_0[cur];
                A_L_0[cnt] <= A_L_0[cur];
                A_W_1[cnt] <= A_W_1[cur];
                A_L_1[cnt] <= A_L_1[cur];

                B_W_0[cnt] <= B_W_0[cur];
                B_L_0[cnt] <= B_L_0[cur];
                B_W_1[cnt] <= B_W_1[cur];
                B_L_1[cnt] <= B_L_0[cur] + ((B_L_1[cur] - B_L_0[cur] + 1) >> 1) - 1;
                to_n1[cur] <= cnt;

                O_W_0[cnt] <= O_W_0[cur];
                O_L_0[cnt] <= O_L_0[cur];
                O_W_1[cnt] <= O_W_1[cur];
                O_L_1[cnt] <= O_L_0[cur] + ((B_L_1[cur] - B_L_0[cur] + 1) >> 1) - 1;



                n[cnt+1] <= cnt + 1;

                A_W_0[cnt+1] <= A_W_0[cur];
                A_L_0[cnt+1] <= A_L_0[cur];
                A_W_1[cnt+1] <= A_W_1[cur];
                A_L_1[cnt+1] <= A_L_1[cur];

                B_W_0[cnt+1] <= B_W_0[cur];
                B_L_0[cnt+1] <= B_L_0[cur] + ((B_L_1[cur] - B_L_0[cur] + 1) >> 1);
                B_W_1[cnt+1] <= B_W_1[cur];
                B_L_1[cnt+1] <= B_L_1[cur];

                O_W_0[cnt+1] <= O_W_0[cur];
                O_L_0[cnt+1] <= O_L_0[cur] + ((B_L_1[cur] - B_L_0[cur] + 1) >> 1);
                O_W_1[cnt+1] <= O_W_1[cur];
                O_L_1[cnt+1] <= O_L_1[cur];

                to_n2[cur] <= cnt + 1;
                cnt <= cnt + 2;
              end else begin
                if ((((A_L_1[cur] - A_L_0[cur])) >= (B_L_1[cur] - B_L_0[cur])) && (((A_L_1[cur] - A_L_0[cur])) >= ((A_W_1[cur] - A_W_0[cur]))))
                            begin

                  n[cnt] <= cnt;

                  A_W_0[cnt] <= A_W_0[cur];
                  A_L_0[cnt] <= A_L_0[cur];
                  A_W_1[cnt] <= A_W_1[cur];
                  A_L_1[cnt] <= A_L_0[cur] + (((A_L_1[cur] - A_L_0[cur]) + 1) >> 1) - 1;

                  B_W_0[cnt] <= B_W_0[cur];
                  B_L_0[cnt] <= B_L_0[cur];
                  B_W_1[cnt] <= B_W_0[cur] + ((B_W_1[cur] - B_W_0[cur] + 1) >> 1) - 1;
                  B_L_1[cnt] <= B_L_1[cur];
                  to_n1[cur] <= cnt;
                  O_W_0[cnt] <= O_W_0[cur];
                  O_L_0[cnt] <= O_L_0[cur];
                  O_W_1[cnt] <= O_W_1[cur];
                  O_L_1[cnt] <= O_L_1[cur];



                  n[cnt+1] <= cnt + 1;

                  A_W_0[cnt+1] <= A_W_0[cur];
                  A_L_0[cnt+1] <= A_L_0[cur] + (((A_L_1[cur] - A_L_0[cur]) + 1) >> 1);
                  A_W_1[cnt+1] <= A_W_1[cur];
                  A_L_1[cnt+1] <= A_L_1[cur];

                  B_W_0[cnt+1] <= B_W_0[cur] + (((B_W_1[cur] - B_W_0[cur]) + 1) >> 1);
                  B_L_0[cnt+1] <= B_L_0[cur];
                  B_W_1[cnt+1] <= B_W_1[cur];
                  B_L_1[cnt+1] <= B_L_1[cur];

                  O_W_0[cnt+1] <= O_W_0[cur];
                  O_L_0[cnt+1] <= O_L_0[cur];
                  O_W_1[cnt+1] <= O_W_1[cur];
                  O_L_1[cnt+1] <= O_L_1[cur];

                  to_n2[cur] <= cnt + 'd1;
                  cnt <= cnt + 'd2;
                end
              end
            end
            parent[cnt]   <= cur;
            parent[cnt+1] <= cur;
          end else begin
            if (first_none == 0) first_none <= cur;
          end
          cur <= cur + 'd1;

        end else begin
          ready <= 1'b1;
          last  <= cur;
        end
      end
    end
  end
endmodule
