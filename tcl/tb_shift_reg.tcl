# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_shift_reg.sv ../source/shift_reg.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_shift_reg

# добавление сигналов к отображению
add wave -noupdate -radix binary sim:/tb_shift_reg/clk
add wave -noupdate -radix binary sim:/tb_shift_reg/reset_n
add wave -noupdate -radix unsigned sim:/tb_shift_reg/ctrl_code
add wave -noupdate -radix decimal sim:/tb_shift_reg/data_in
add wave -noupdate -radix decimal sim:/tb_shift_reg/data_write

add wave -noupdate -radix decimal sim:/tb_shift_reg/data_read
add wave -noupdate -radix decimal sim:/tb_shift_reg/data_out

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 