# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_fetcher_simple.sv ../source/sys_array_fetcher_simple.sv ../source/sys_array_basic_simple.sv ../source/sys_array_cell.sv ../source/shift_reg.sv
            
# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_fetcher
 
# добавление сигналов к отображению
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/clk
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/reset_n
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/weights_load
add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/input_data
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/weights_data

add wave -noupdate -radix binary sim:/tb_sys_array_fetcher/ready
add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/out_data

add wave -noupdate -radix decimal sim:/tb_sys_array_fetcher/result_data

# симуляция и отображение результатов
run -all
wave zoom full
WaveRestoreZoom {0 ns} [simtime]
#WaveRestoreZoom {0 ns} {1000 ns} 