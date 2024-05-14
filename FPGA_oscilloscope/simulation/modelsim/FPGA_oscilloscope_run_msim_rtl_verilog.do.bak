transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Graduation\ Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src {E:/Graduation Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src/uart.v}
vlog -vlog01compat -work work +incdir+E:/Graduation\ Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src {E:/Graduation Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src/FPGA_oscilloscope.v}
vlog -vlog01compat -work work +incdir+E:/Graduation\ Design/mutil-channel-oscilloscope/FPGA_oscilloscope/IP {E:/Graduation Design/mutil-channel-oscilloscope/FPGA_oscilloscope/IP/ADC0_FIFO.v}
vlog -vlog01compat -work work +incdir+E:/Graduation\ Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src {E:/Graduation Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src/ADC0_drive.v}

vlog -vlog01compat -work work +incdir+E:/Graduation\ Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src {E:/Graduation Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src/FPGA_oscilloscope_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  FPGA_oscilloscope_tb

add wave *
view structure
view signals
run -all
