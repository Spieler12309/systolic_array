# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_fetcher_split.sv ../source/sys_array_fetcher_split.sv ../source/sys_array_basic_split.sv ../source/sys_array_cell.sv ../source/shift_reg.sv ../source/sys_array_split.sv
vlog +incdir+./ ../source/rom.sv 

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_fetcher_split

# добавление сигналов к отображению
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/clk
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/reset_n
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/input_data_a
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/weights
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/result_data

add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/weights_max
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/input_data_a_max
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/weights_load
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/input_sys_array
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/output_sys_array
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/output_wire
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/split_ready
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/split_out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/first_none
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/last
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/len_w_l
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/len_w_w
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/len_a_l
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/len_a_w
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/reset_n_basic
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/prev_split_ready
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/start_comp_split
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/fetch_len
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cur
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt_input_data_a_max_w
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt_input_data_a_max_l
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt_weights_max_w
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt_weights_max_l
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt_output_data_max_w
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/cnt_output_data_max_l
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/control_sr_read
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/control_sr_write


add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/systolic_array/weights_load
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/systolic_array/temp_output_data

# симуляция и отображение результатов
run -all
#run 1000000
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 