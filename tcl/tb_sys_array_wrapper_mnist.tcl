# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляции
vlib work

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_wrapper_mnist.sv ../source/sys_array_wrapper_mnist.sv ../source/sys_array_fetcher.sv ../source/sys_array_basic.sv ../source/sys_array_cell.sv ../source/shift_reg.sv
vlog +incdir+./ ../source/rom.sv ../source/seg7_tohex_mnist.sv ../source/max_num.sv ../source/sys_array_split.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_wrapper_mnist

# добавление сигналов к отображению
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/clk
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/reset_n
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/load_params
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/start_comp
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/image_num
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/ready
add wave -noupdate -radix hexadecimal sim:/tb_sys_array_wrapper_mnist/out_data
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/classes

add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/ready1
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/ready1_prev
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/ready2
add wave -noupdate -radix binary  sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/ready

add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/input_image
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/weights
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/outputs_fetcher
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/matrix_sum
add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/classes

add wave -noupdate -radix decimal sim:/tb_sys_array_wrapper_mnist/sys_array_wrapper_mnist0/max_num0/*

# симуляция и отображение результатов
run -all
wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns}