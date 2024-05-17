module FPGA_control(
	input Clk,
	input Reset_n,
	input wire [9:0] ADC0_Data,
	input ADC0_bg,
//   input Trigger,
	output wire ADC0_Clk,
	output wire [9:0] ADC0_O_Data
);
//	reg ADC0_bg;
	wire empty;
	wire ADC0_end;
	reg ADC0_rdreq;
	assign ADC0_Clk = Clk;
	ADC0_drive ADC0_drive(
		.Clk(ADC0_Clk),
		.Reset_n(Reset_n),
		.AD_Data(ADC0_Data),
		.Trigger(8'd512),
		.ADC0_bg(ADC0_bg),
		.ADC0_end(ADC0_end),
		.rdreq(ADC0_rdreq),
		.empty(empty),
		.ADC0_F_O_Data(ADC0_O_Data)
	);
//	always@(posedge Clk or negedge Reset_n)begin
//		if(!Reset_n)begin
//			ADC0_bg <= 1;
//		end else begin
//			if(ADC0_end == 1)
//				ADC0_bg <= 0;
//			else if (empty == 1 && text ==1024)
//				ADC0_bg <= 1;
//		end
//	end
//	reg [8:0] text;
//	always@(posedge Clk)begin
//		if(empty == 1 && text < 1024)
//			text <= text +1'd1;
//		else if(empty ==0)
//			text <= 0;
//	end
	always@(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
		end else begin
			if(ADC0_end == 1 && empty == 0)begin
				ADC0_rdreq <= 1;
			end else if(empty == 1)
				ADC0_rdreq <= 0;
		end
	end

endmodule
