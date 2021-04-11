onerror {resume}
quietly virtual function -install /testbench_shift_array -env /testbench_shift_array { &{/testbench_shift_array/data_in[7], /testbench_shift_array/data_in[6], /testbench_shift_array/data_in[5], /testbench_shift_array/data_in[4], /testbench_shift_array/data_in[3], /testbench_shift_array/data_in[2], /testbench_shift_array/data_in[1], /testbench_shift_array/data_in[0] }} data_in0
quietly virtual function -install /testbench_shift_array -env /testbench_shift_array { &{/testbench_shift_array/data_in[15], /testbench_shift_array/data_in[14], /testbench_shift_array/data_in[13], /testbench_shift_array/data_in[12], /testbench_shift_array/data_in[11], /testbench_shift_array/data_in[10], /testbench_shift_array/data_in[9], /testbench_shift_array/data_in[8] }} data_in1
quietly virtual function -install /testbench_shift_array -env /testbench_shift_array { &{/testbench_shift_array/data_in[23], /testbench_shift_array/data_in[22], /testbench_shift_array/data_in[21], /testbench_shift_array/data_in[20], /testbench_shift_array/data_in[19], /testbench_shift_array/data_in[18], /testbench_shift_array/data_in[17], /testbench_shift_array/data_in[16] }} data_in2
quietly virtual function -install /testbench_shift_array -env /testbench_shift_array { &{/testbench_shift_array/data_in[31], /testbench_shift_array/data_in[30], /testbench_shift_array/data_in[29], /testbench_shift_array/data_in[28], /testbench_shift_array/data_in[27], /testbench_shift_array/data_in[26], /testbench_shift_array/data_in[25], /testbench_shift_array/data_in[24] }} data_in3
quietly virtual signal -install /testbench_shift_array { /testbench_shift_array/data_out[7:0]} data_out0
quietly virtual signal -install /testbench_shift_array { /testbench_shift_array/data_out[15:8]} data_out1
quietly virtual signal -install /testbench_shift_array { /testbench_shift_array/data_out[23:16]} data_out2
quietly virtual signal -install /testbench_shift_array { /testbench_shift_array/data_out[31:24]} data_out3
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_shift_array/clk
add wave -noupdate /testbench_shift_array/reset_n
add wave -noupdate /testbench_shift_array/ctrl_code
add wave -noupdate -radix decimal /testbench_shift_array/data_in0
add wave -noupdate -radix decimal /testbench_shift_array/data_in1
add wave -noupdate -radix decimal /testbench_shift_array/data_in2
add wave -noupdate -radix decimal /testbench_shift_array/data_in3
add wave -noupdate -radix decimal /testbench_shift_array/data_write
add wave -noupdate -radix decimal /testbench_shift_array/data_out0
add wave -noupdate -radix decimal /testbench_shift_array/data_out1
add wave -noupdate -radix decimal /testbench_shift_array/data_out2
add wave -noupdate -radix decimal /testbench_shift_array/data_out3
add wave -noupdate -radix decimal /testbench_shift_array/data_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {481 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 214
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {665 ps}
