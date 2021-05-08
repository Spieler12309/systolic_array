# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_fetcher.sv ../source/sys_array_fetcher.sv ../source/sys_array_basic.sv ../source/sys_array_cell.sv ../source/shift_reg.sv

# указываем топовый TestBench
vsim -novopt work.tb_sys_array_fetcher

# добавление сигналов к отображению
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/sys_array_fetcher0/clk
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/sys_array_fetcher0/reset_n
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/sys_array_fetcher0/load_params
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/sys_array_fetcher0/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/sys_array_fetcher0/input_data_a
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/sys_array_fetcher0/input_data_b

add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/sys_array_fetcher0/ready
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/sys_array_fetcher0/out_data

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 