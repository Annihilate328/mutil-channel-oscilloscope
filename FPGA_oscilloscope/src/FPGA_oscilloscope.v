module FPGA_oscilloscope(
	ADC0_bg,
	Clk,
	ADC0_Clk,
	Reset_n,
	F_O_ADC0_Data,
	ADC0_rdreq,
	ADC0_almost_empty,
	ADC0_empty,
	ADC0_sclr,
	ADC0_Trigger_lever,
	Trigger_lever,
);
	input Clk;
	input Reset_n;
	input F_O_ADC0_Data;
	input ADC0_almost_empty;
	input ADC0_empty;
	input Trigger_lever;
	
	output ADC0_bg;
	output ADC0_Clk;
	output ADC0_rdreq;
	output ADC0_Trigger_lever;
	output ADC0_sclr;
	
ADC0_drive ADC0_drive(
	.ADC0_bg(ADC0_bg),//ADC0开始标志位
	.ADC0_Clk(ADC0_Clk),//ADC0输入时钟
	.Reset_n(Reset_n),//复位
	.F_O_ADC0_Data(F_O_ADC0_Data),//FIFO数据出口
	.ADC0_rdreq(ADC0_rdreq),//FIFO读标志位
	.ADC0_almost_empty(ADC0_almost_empty),//ADC0快空引脚
	.ADC0_empty(ADC0_empty),//ADC0空引脚
	.ADC0_sclr(ADC0_sclr),//FIFO清零
	.Trigger_lever(ADC0_Trigger_lever)//触发电平
);
endmodule
