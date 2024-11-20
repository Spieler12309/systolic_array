# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_cell.sv ../source/sys_array_cell.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_cell

# добавление сигналов к отображению
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/clk
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/reset_n
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/weight_load
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/input_data
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/prop_data
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/weights
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_cell/systolic_array_cell/prop_output

# симуляция и отображение результатов
run -all
#wave zoom full
WaveRestoreZoom {0 ns} [simtime]
#WaveRestoreZoom {0 ns} {1000 ns} 