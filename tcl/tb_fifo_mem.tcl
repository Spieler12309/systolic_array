# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_fifo_mem.sv ../source/fifo/fifo_mem.sv ../source/fifo/write_pointer.sv ../source/fifo/read_pointer.sv ../source/fifo/status_signal.sv ../source/fifo/memory_array.sv

# указываем топовый TestBench
vsim -novopt work.tb_fifo_mem

# добавление сигналов к отображению
add wave -noupdate -radix decimal sim:/tb_fifo_mem/clk
add wave -noupdate -radix decimal sim:/tb_fifo_mem/reset_n
add wave -noupdate -radix decimal sim:/tb_fifo_mem/write
add wave -noupdate -radix decimal sim:/tb_fifo_mem/read
add wave -noupdate -radix decimal sim:/tb_fifo_mem/data_in

add wave -noupdate -radix decimal sim:/tb_fifo_mem/fifo_full
add wave -noupdate -radix decimal sim:/tb_fifo_mem/fifo_empty
add wave -noupdate -radix decimal sim:/tb_fifo_mem/fifo_threshold
add wave -noupdate -radix decimal sim:/tb_fifo_mem/fifo_overflow
add wave -noupdate -radix decimal sim:/tb_fifo_mem/fifo_underflow
add wave -noupdate -radix decimal sim:/tb_fifo_mem/data_out

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 