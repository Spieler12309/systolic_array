# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_clock_divider.sv ../source/clock_divider.sv

# указываем топовый TestBench
vsim -novopt work.tb_clock_divider

# добавление сигналов к отображению
add wave -noupdate -radix decimal sim:/tb_clock_divider/clk
add wave -noupdate -radix decimal sim:/tb_clock_divider/div_clk

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 