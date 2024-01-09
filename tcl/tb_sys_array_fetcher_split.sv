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
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/start_comp_split
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/input_data_a
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/weights
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/split_out_data

add wave -noupdate -radix binary sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/ready
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/output_sys_array
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher_split/sys_array_fetcher0/systolic_array/temp_output_data

# симуляция и отображение результатов
run -all
#run 1000000
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 