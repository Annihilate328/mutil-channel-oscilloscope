module Ms9280_driver(
	Clk,
	AD_Clk,
	out_data,
	AD_Data
);
	input Clk;
	input [7:0]AD_Data;
	output reg [7:0]out_data;
	output AD_Clk;
	
	assign AD_Clk = Clk;
	
	always@(posedge Clk)
		out_data <= AD_Data;

endmodule
