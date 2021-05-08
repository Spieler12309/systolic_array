# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_cell.sv ../source/sys_array_cell.sv

# указываем топовый TestBench
vsim -novopt work.tb_sys_array_cell

# добавление сигналов к отображению
# add wave sim:/tb_sys_array_cell/clk
# add wave sim:/tb_sys_array_cell/reset_n
# add wave sim:/tb_sys_array_cell/param_load
# add wave sim:/tb_sys_array_cell/input_data
# add wave sim:/tb_sys_array_cell/prop_data
# add wave sim:/tb_sys_array_cell/param_data
# add wave sim:/tb_sys_array_cell/out_data
# add wave sim:/tb_sys_array_cell/prop_param

add wave sim:/tb_sys_array_cell/*

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 