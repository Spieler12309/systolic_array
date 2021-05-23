@echo off
cls

if exist sim\*.* rd /S /Q sim
if not exist sim md sim

rem Дополнительные действия, перед запуском симуляции
copy a_data.hex sim
copy b_data.hex sim

rem Запуск симуляции
cd sim
vsim -do ../tcl/%1
