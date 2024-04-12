module FPGA_oscilloscope(
	Clk,
	Reset_n,
	AD_Clk,
	AD_Data
);
	Uart Uart(
	
	);
	input Clk;
	input [7:0]AD_Data;
	output AD_Clk;
	
	reg [7:0]AD_t_Data;
	
	assign AD_Clk = Clk;

	always @(posedge Clk or negedge Reset_n) 
		AD_t_Data <= AD_Data;

endmodule
