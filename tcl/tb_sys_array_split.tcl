# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_split.sv ../source/sys_array_split.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_split

# добавление сигналов к отображению
add wave -noupdate -radix decimal sim:/tb_sys_array_split/clk
add wave -noupdate -radix decimal sim:/tb_sys_array_split/reset_n
add wave -noupdate -radix decimal sim:/tb_sys_array_split/start
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_A_W
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_A_L
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_W_W
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ARRAY_W_L
add wave -noupdate -radix decimal sim:/tb_sys_array_split/ready
add wave -noupdate -radix decimal sim:/tb_sys_array_split/out_data
add wave -noupdate -radix decimal sim:/tb_sys_array_split/first_none
add wave -noupdate -radix decimal sim:/tb_sys_array_split/last

# симуляция и отображение результатов
run -all
#wave zoom full
WaveRestoreZoom {0 ns} [simtime]
#WaveRestoreZoom {0 ns} {1000 ns}