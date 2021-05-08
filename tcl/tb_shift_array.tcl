# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_shift_array.sv ../source/shift_array.sv
vlog +incdir+./ ../source/fifo/fifo_mem.sv ../source/fifo/write_pointer.sv ../source/fifo/read_pointer.sv ../source/fifo/status_signal.sv ../source/fifo/memory_array.sv

# указываем топовый TestBench
vsim -novopt work.tb_shift_array

# добавление сигналов к отображению
add wave sim:/tb_shift_array/clk
add wave sim:/tb_shift_array/reset_n
add wave sim:/tb_shift_array/ctrl_code
add wave sim:/tb_shift_array/data_in
add wave sim:/tb_shift_array/data_write

add wave sim:/tb_shift_array/data_read
add wave sim:/tb_shift_array/data_out

add wave sim:/tb_shift_array/fifo_full
add wave sim:/tb_shift_array/fifo_empty
add wave sim:/tb_shift_array/fifo_threshold
add wave sim:/tb_shift_array/fifo_overflow
add wave sim:/tb_shift_array/fifo_underflow

# симуляция и отображение результатов
run -all
#wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 