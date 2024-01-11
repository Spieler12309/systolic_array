# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции]
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_basic_simple.sv ../source/sys_array_basic_simple.sv ../source/sys_array_cell.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_basic

# добавление сигналов к отображению
add wave -noupdate -radix binary  sim:/tb_sys_array_basic/clk
add wave -noupdate -radix binary  sim:/tb_sys_array_basic/reset_n
add wave -noupdate -radix binary  sim:/tb_sys_array_basic/weights_load
add wave -noupdate -radix decimal sim:/tb_sys_array_basic/inputs_test
add wave -noupdate -radix decimal sim:/tb_sys_array_basic/weight_test
add wave -noupdate -radix decimal sim:/tb_sys_array_basic/outputs_test

# симуляция и отображение результатов   
run -all
    
#wave zoom full
WaveRestoreZoom {0 ns} [simtime]
#WaveRestoreZoom {0 ns} {1000 ns}