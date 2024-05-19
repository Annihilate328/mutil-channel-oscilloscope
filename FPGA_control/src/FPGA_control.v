module FPGA_control(
	input Clk,
	input Reset_n,
	input wire [7:0] ADC0_Data,
	input wire [7:0] ADC1_Data,
	input ADC0_bg,
	input ADC1_bg,
//   input Trigger,
	output wire ADC0_Clk,
	output wire ADC1_Clk,
	output wire [7:0] ADC0_O_Data,
	output wire [7:0] ADC1_O_Data
);
//	reg ADC0_bg;
	wire empty;
	wire ADC0_end;
	wire ADC1_end;
	reg ADC0_rdreq;
	reg ADC1_rdreq;
	assign ADC0_Clk = Clk;
	assign ADC1_Clk = Clk;
	ADC0_drive ADC0_drive(
		.Clk(ADC0_Clk),
		.Reset_n(Reset_n),
		.AD_Data(ADC0_Data),
		.Trigger(8'd512),
		.ADC0_bg(ADC0_bg),
		.ADC0_end(ADC0_end),
		.rdreq(ADC0_rdreq),
		.empty(ADC0_empty),
		.ADC0_F_O_Data(ADC0_O_Data)
	);
	ADC1_drive ADC1_drive(
		.Clk(ADC1_Clk),
		.Reset_n(Reset_n),
		.AD_Data(ADC1_Data),
		.Trigger(8'd512),
		.ADC1_bg(ADC1_bg),
		.ADC1_end(ADC1_end),
		.rdreq(ADC1_rdreq),
		.empty(ADC1_empty),
		.ADC1_F_O_Data(ADC1_O_Data)
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
			if(ADC0_end == 1 && ADC0_empty == 0)begin
				ADC0_rdreq <= 1;
			end else if(ADC0_empty == 1)
				ADC0_rdreq <= 0;
		end
	end
	
	always@(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
		end else begin
			if(ADC1_end == 1 && ADC1_empty == 0)begin
				ADC1_rdreq <= 1;
			end else if(ADC1_empty == 1)
				ADC1_rdreq <= 0;
		end
	end

endmodule
