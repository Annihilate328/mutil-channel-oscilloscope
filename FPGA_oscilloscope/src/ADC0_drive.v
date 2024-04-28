module ADC0_drive(
	ADC0_Clk,
	Reset_n,
	F_ADC0_Data,
	rdreq,
	almost_empty,
	empty
);

	input ADC0_Clk;
	input Reset_n;
	input rdreq;
	output F_ADC0_Data;
	output almost_empty;
	output empty;
	
	wire Data;
	reg [7:0] AD_Data;
	reg rdreg;
	reg almost_full;
	reg full;
	
	Ms9280_drive Ms9280_drive(	
		.I_AD_Clk(ADC0_Clk),
		.O_AD_Data(Data)
	);
	ADC0_FIFO(
		.clock(ADC0_Clk),
		.data(AD_Data),
		.rdreq(rdreq),
		.wrreq(wrreq),
		.almost_empty(almost_empty),
		.almost_full(almost_full),
		.empty(empty),
		.full(full),
		.q(F_ADC_Data)
	);
	
	always@(posedge ADC0_Clk or negedge Reset_n)
		AD_Data <= Data;
endmodule
