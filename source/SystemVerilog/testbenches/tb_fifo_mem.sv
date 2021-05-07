//`timescale     10 ps/ 10 ps  

`define DELAY 10  

module tb_fifo_mem;  
parameter ENDTIME      = 40000;  
parameter DATA_WIDTH = 8;
parameter LENGTH = 16;
parameter PTR_LENGTH = 5;

reg clk;  
reg reset_n;  
reg write;  
reg read;  
reg [7:0] data_in;  

wire [7:0] data_out;  
wire fifo_empty;  
wire fifo_full;  
wire fifo_threshold;  
wire fifo_overflow;  
wire fifo_underflow;  
integer i;  
 
fifo_mem tb 
(
    .clk(clk),
    .reset_n(reset_n),
    .write(write),
    .read(read),
    .data_in(data_in),

    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_threshold(fifo_threshold),
    .fifo_overflow(fifo_overflow),
    .fifo_underflow(fifo_underflow),
    .data_out(data_out)
 );  

initial  
begin  
    clk     = 1'b0;  
    reset_n     = 1'b0;  
    write     = 1'b0;  
    read     = 1'b0;  
    data_in     = 8'd0;  
end  

initial  
begin  
    main;  
end  

task main;  
    fork  
         clock_generator;  
         reset_generator;  
         operation_process;  
         debug_fifo;  
         endsimulation;  
    join
endtask  

task clock_generator;  
begin  
     forever #`DELAY clk = !clk;  
end  
endtask  

task reset_generator;  
begin  
     #(`DELAY*2)  
     reset_n = 1'b1;  
     # 7.9  
     reset_n = 1'b0;  
     # 7.09  
     reset_n = 1'b1;  
end  
endtask  

task operation_process;  
begin  
     for (i = 0; i < 17; i = i + 1) begin: writeE  
          #(`DELAY*5)  
          write = 1'b1;  
          data_in = data_in + 8'd1;  
          #(`DELAY*2)  
          write = 1'b0;  
     end  
     #(`DELAY)  
     for (i = 0; i < 17; i = i + 1) begin: readE  
          #(`DELAY*2)  
          read = 1'b1;  
          #(`DELAY*2)  
          read = 1'b0;  
     end  
end  
endtask  

task debug_fifo;  
begin  
     $display("----------------------------------------------");  
     $display("------------------   -----------------------");  
     $display("----------- SIMULATION RESULT ----------------");  
     $display("--------------       -------------------");  
     $display("----------------     ---------------------");  
     $display("----------------------------------------------");  
     $monitor("TIME = %d, write = %b, read = %b, data_in = %h",$time, write, read, data_in);  
end
endtask  

reg [5:0] waddr, raddr;  
reg [7:0] mem [64:0];  

always @ (posedge clk)
begin  
    if (~reset_n) begin  
         waddr     <= 6'd0;  
    end  
    else if (write) 
    begin  
         mem[waddr] <= data_in;  
         waddr <= waddr + 1;  
    end  
    $display("TIME = %d, data_out = %d, mem = %d",$time, data_out,mem[raddr]);  
    if (~reset_n) 
        raddr     <= 6'd0;  
    else if (read & (~fifo_empty)) 
        raddr <= raddr + 1;  

    if (read & (~fifo_empty)) 
    begin  
         if (mem[raddr] == data_out) 
         begin  
              $display("=== PASS ===== PASS ==== PASS ==== PASS ===");  
              if (raddr == 16) 
                $finish;  
         end  
         else 
         begin  
              $display ("=== FAIL ==== FAIL ==== FAIL ==== FAIL ===");  
              $display("-------------- THE SIMUALTION FINISHED ------------");  
              $finish;  
         end  
    end  
end 
  
task endsimulation;  
begin  
     #ENDTIME  
     $display("-------------- THE SIMUALTION FINISHED ------------");  
     $finish;  
end  
endtask  

endmodule  