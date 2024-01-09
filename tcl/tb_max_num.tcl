# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_max_num.sv ../source/max_num.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_max_num

# добавление сигналов к отображению
add wave -noupdate -radix binary sim:/tb_max_num/clk
add wave -noupdate -radix binary sim:/tb_max_num/reset_n
add wave -noupdate -radix binary sim:/tb_max_num/start
add wave -noupdate -radix decimal sim:/tb_max_num/matrix
add wave -noupdate -radix binary sim:/tb_max_num/classes
add wave -noupdate -radix binary sim:/tb_max_num/ready

add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/half_max
add wave -noupdate -radix binary sim:/tb_max_num/max_num0/half_max_reg
add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/three_max
add wave -noupdate -radix binary sim:/tb_max_num/max_num0/three_max_reg
add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/i_var
add wave -noupdate -radix decimal sim:/tb_max_num/max_num0/maximum

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 