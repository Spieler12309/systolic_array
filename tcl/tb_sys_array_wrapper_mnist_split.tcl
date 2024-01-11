# путь к папке Quartus и Intel ModelSim для подключения платформозависимых библиотек (при необходимости)
#set QUARTUS_ROOTDIR "C:/intelFPGA/18.1/quartus"
# берём из пользовательских переменных сред
set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)

# создание рабочей библиотеки для симуляцииx

# компиляция исходников (добавляем необходимые)
vlog +incdir+./ ../testbenches/tb_sys_array_wrapper_mnist_split.sv ../source/sys_array_wrapper_mnist_split.sv ../source/sys_array_fetcher_split.sv ../source/sys_array_basic_split.sv ../source/sys_array_cell.sv ../source/shift_reg.sv
vlog +incdir+./ ../source/rom.sv ../source/seg7_tohex_mnist.sv ../source/max_num.sv ../source/sys_array_split.sv

# указываем топовый TestBench
vsim -voptargs=+acc work.tb_sys_array_wrapper_mnist_split

# добавление сигналов к отображению
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/clk
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/reset_n
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/start_comp
add wave -noupdate -radix decimal     sim:/tb_sys_array_wrapper_mnist_split/image_num
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/ready
add wave -noupdate -radix hexadecimal sim:/tb_sys_array_wrapper_mnist_split/out_data
add wave -noupdate -radix binary      sim:/tb_sys_array_wrapper_mnist_split/classes
add wave -noupdate -radix decimal      sim:/tb_sys_array_wrapper_mnist_split/ii
add wave -noupdate -radix decimal      sim:/tb_sys_array_wrapper_mnist_split/sys_array_wrapper_mnist0/fetching_unit/*
add wave -noupdate -radix decimal      sim:/tb_sys_array_wrapper_mnist_split/sys_array_wrapper_mnist0/fetching_unit/out_data

add wave -noupdate -radix decimal      sim:/tb_sys_array_wrapper_mnist_split/sys_array_wrapper_mnist0/fetching_unit/split_out_data
add wave -noupdate -radix decimal      sim:/tb_sys_array_wrapper_mnist_split/sys_array_wrapper_mnist0/fetching_unit/first_none
add wave -noupdate -radix decimal      sim:/tb_sys_array_wrapper_mnist_split/sys_array_wrapper_mnist0/fetching_unit/last

# симуляция и отображение результатов
run -all
wave zoom full
#WaveRestoreZoom {0 ns} [simtime]
WaveRestoreZoom {0 ns} {1000 ns} 