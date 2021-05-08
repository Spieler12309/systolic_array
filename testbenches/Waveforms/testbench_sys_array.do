onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_sys_array/clk
add wave -noupdate /testbench_sys_array/reset_n
add wave -noupdate /testbench_sys_array/param_load
add wave -noupdate -expand -subitemconfig {{/testbench_sys_array/parameters_test[3]} {-childformat {{{/testbench_sys_array/parameters_test[3][3]} -radix decimal} {{/testbench_sys_array/parameters_test[3][2]} -radix decimal} {{/testbench_sys_array/parameters_test[3][1]} -radix decimal} {{/testbench_sys_array/parameters_test[3][0]} -radix decimal}} -expand} {/testbench_sys_array/parameters_test[3][3]} {-radix decimal} {/testbench_sys_array/parameters_test[3][2]} {-radix decimal} {/testbench_sys_array/parameters_test[3][1]} {-radix decimal} {/testbench_sys_array/parameters_test[3][0]} {-radix decimal} {/testbench_sys_array/parameters_test[2]} {-childformat {{{/testbench_sys_array/parameters_test[2][3]} -radix decimal} {{/testbench_sys_array/parameters_test[2][2]} -radix decimal} {{/testbench_sys_array/parameters_test[2][1]} -radix decimal} {{/testbench_sys_array/parameters_test[2][0]} -radix decimal}} -expand} {/testbench_sys_array/parameters_test[2][3]} {-radix decimal} {/testbench_sys_array/parameters_test[2][2]} {-radix decimal} {/testbench_sys_array/parameters_test[2][1]} {-radix decimal} {/testbench_sys_array/parameters_test[2][0]} {-radix decimal} {/testbench_sys_array/parameters_test[1]} {-childformat {{{/testbench_sys_array/parameters_test[1][3]} -radix decimal} {{/testbench_sys_array/parameters_test[1][2]} -radix decimal} {{/testbench_sys_array/parameters_test[1][1]} -radix decimal} {{/testbench_sys_array/parameters_test[1][0]} -radix decimal}} -expand} {/testbench_sys_array/parameters_test[1][3]} {-radix decimal} {/testbench_sys_array/parameters_test[1][2]} {-radix decimal} {/testbench_sys_array/parameters_test[1][1]} {-radix decimal} {/testbench_sys_array/parameters_test[1][0]} {-radix decimal} {/testbench_sys_array/parameters_test[0]} {-childformat {{{/testbench_sys_array/parameters_test[0][3]} -radix decimal} {{/testbench_sys_array/parameters_test[0][2]} -radix decimal} {{/testbench_sys_array/parameters_test[0][1]} -radix decimal} {{/testbench_sys_array/parameters_test[0][0]} -radix decimal}} -expand} {/testbench_sys_array/parameters_test[0][3]} {-radix decimal} {/testbench_sys_array/parameters_test[0][2]} {-radix decimal} {/testbench_sys_array/parameters_test[0][1]} {-radix decimal} {/testbench_sys_array/parameters_test[0][0]} {-radix decimal}} /testbench_sys_array/parameters_test
add wave -noupdate -childformat {{{/testbench_sys_array/inputs_test[3]} -radix decimal} {{/testbench_sys_array/inputs_test[2]} -radix decimal} {{/testbench_sys_array/inputs_test[1]} -radix decimal} {{/testbench_sys_array/inputs_test[0]} -radix decimal}} -expand -subitemconfig {{/testbench_sys_array/inputs_test[3]} {-radix decimal} {/testbench_sys_array/inputs_test[2]} {-radix decimal} {/testbench_sys_array/inputs_test[1]} {-radix decimal} {/testbench_sys_array/inputs_test[0]} {-radix decimal}} /testbench_sys_array/inputs_test
add wave -noupdate -childformat {{{/testbench_sys_array/outputs_test[3]} -radix decimal} {{/testbench_sys_array/outputs_test[2]} -radix decimal} {{/testbench_sys_array/outputs_test[1]} -radix decimal} {{/testbench_sys_array/outputs_test[0]} -radix decimal}} -expand -subitemconfig {{/testbench_sys_array/outputs_test[3]} {-radix decimal} {/testbench_sys_array/outputs_test[2]} {-radix decimal} {/testbench_sys_array/outputs_test[1]} {-radix decimal} {/testbench_sys_array/outputs_test[0]} {-radix decimal}} /testbench_sys_array/outputs_test
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {502 ps}
