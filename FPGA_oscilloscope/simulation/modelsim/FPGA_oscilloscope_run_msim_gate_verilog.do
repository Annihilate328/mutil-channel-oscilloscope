transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {FPGA_oscilloscope_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+E:/Graduation\ Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src {E:/Graduation Design/mutil-channel-oscilloscope/FPGA_oscilloscope/src/FPGA_oscilloscope_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  FPGA_oscilloscope_tb

add wave *
view structure
view signals
run -all
