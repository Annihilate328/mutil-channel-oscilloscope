module Ms9280_drive(
	O_AD_Clk,
	I_AD_Clk,
	I_AD_Data,
	O_AD_Data
);

	input wire [7:0] I_AD_Data;
	input wire I_AD_Clk;
	output wire [7:0] O_AD_Data;
	output wire O_AD_Clk;
	
	assign O_AD_Clk = I_AD_Clk;
	assign O_AD_Data = O_AD_Data;
	
endmodule
