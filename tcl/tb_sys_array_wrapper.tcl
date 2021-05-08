# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_wrapper.sv ../source/sys_array_wrapper.sv ../source/sys_array_fetcher.sv ../source/sys_array_basic.sv ../source/sys_array_cell.sv ../source/clock_divider.sv ../source/shift_reg.sv
vlog +incdir+./ ../source/roma.sv ../source/romb.sv ../source/seg7_tohex.sv

# указываем топовый TestBench
vsim -novopt work.tb_sys_array_wrapper

# добавление сигналов к отображению
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper/sys_array_wrapper0/clk
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper/sys_array_wrapper0/reset_n
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper/sys_array_wrapper0/load_params
add wave -noupdate -radix binary sim:/tb_sys_array_wrapper/sys_array_wrapper0/start_comp
add wave -noupdate -radix hexadecimal sim:/tb_sys_array_wrapper/sys_array_wrapper0/hex_connect

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns}