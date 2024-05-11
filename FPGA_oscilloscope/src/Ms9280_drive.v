module Ms9280_drive(
	O_AD_Clk,
	I_AD_Clk,
	I_AD_Data,
	O_AD_Data
);

	input [7:0] I_AD_Data;
	input I_AD_Clk;
	output [7:0] O_AD_Data;
	output O_AD_Clk;
	
	assign O_AD_Clk = I_AD_Clk;
	assign O_AD_Data = I_AD_Data;
	
endmodule
