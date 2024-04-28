module Ms9280_driver(
	Clk,
	AD_Clk,
	O_AD_Data,
	I_AD_Data,
	OTR,
//模拟双四选一驱动逻辑	
//	I_S0,
//	I_S1,
	O_S0,
	O_S1,
//继电器驱动逻辑	
//	I_relay,
	O_relay,
//交直流耦合驱动逻辑	
//	I_AC_DC_coupling,
	O_AC_DC_coupling
);
	input Clk;//输入50Mhz的时钟
	input [9:0] I_AD_Data;//ADC数据输入
	output reg [9:0] O_AD_Data;//ADC数据输出
	output AD_Clk;//ADC时钟输出
	
//	input I_S0;
//	input I_S1;
	output O_S0;
	output O_S1;//模拟四选一驱动引脚
	
//	input I_relay;
	output O_relay;
	
	input I_AC_DC_coupling;
	output O_AC_DC_coupling;
	
	assign AD_Clk = Clk;
	
	always@(posedge Clk)
		out_data <= AD_Data;

endmodule
