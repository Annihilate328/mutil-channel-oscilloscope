module FPGA_control(
    input Clk,
    input Reset_n,
	 
    input wire [7:0] ADC0_Data,
    input wire [7:0] ADC1_Data,
	 
    input ADC0_bg,
    input ADC1_bg,
    input [1:0] ADC_FIFO_O_EN,
	 input FFT_EN,
	 input [1:0] FFT_I_EN,
	 output reg FFT_BG,
    output wire ADC0_Clk,
    output wire ADC1_Clk,
	 output wire [7:0] FFT_O_real,
	 output wire [7:0] FFT_O_imag,
    output reg [7:0] ADC_FIFO_Data
);

    // Signals for FIFO
    wire ADC0_empty, ADC1_empty;
    wire ADC0_end, ADC1_end;
    wire [7:0] ADC0_FIFO_O, ADC1_FIFO_O;

    reg ADC0_rdreq, ADC1_rdreq;

    assign ADC0_Clk = Clk;
    assign ADC1_Clk = Clk;
	 

	// Instantiate ADC0_drive
	ADC0_drive ADC0_drive(
		.Clk(ADC0_Clk),
		.wdclk()
		.Reset_n(Reset_n),
		.AD_Data(ADC0_Data),
		.Trigger(8'd50),
		.ADC0_bg(ADC0_bg),
		.ADC0_end(ADC0_end),
		.rdreq(ADC0_rdreq),
		.empty(ADC0_empty),
		.ADC0_F_O_Data(ADC0_FIFO_O)
	);

    // Instantiate ADC1_drive
	ADC1_drive ADC1_drive(
		.Clk(ADC1_Clk),
		.Reset_n(Reset_n),
		.AD_Data(ADC1_Data),
		.Trigger(8'd50),
		.ADC1_bg(ADC1_bg),
		.ADC1_end(ADC1_end),
		.rdreq(ADC1_rdreq),
		.empty(ADC1_empty),
		.ADC1_F_O_Data(ADC1_FIFO_O)
	);
	
	reg [7:0]sink_real;
	reg source_ready;
	reg sink_sop;
	reg sink_eop;
	reg sink_valid;
	wire sink_ready;
	wire source_valid;
	
	always @(posedge Clk or negedge Reset_n) begin
		if (!Reset_n) begin
			ADC0_rdreq <= 0;
			ADC1_rdreq <= 0;
			ADC_FIFO_Data <= 8'b0;
		end else begin
			if (ADC0_end && !ADC0_empty && (ADC_FIFO_O_EN == 2'b00)) begin
				ADC_FIFO_Data <= ADC0_FIFO_O;
				ADC0_rdreq <= 1;
			end else begin
				ADC0_rdreq <= 0;
			end
			if (ADC1_end && !ADC1_empty && (ADC_FIFO_O_EN == 2'b01)) begin
				ADC_FIFO_Data <= ADC1_FIFO_O;
				ADC1_rdreq <= 1;
			end else begin
				ADC1_rdreq <= 0;
			end
		end
	end
//	if(FFT_EN == 1 && FFT_I_EN == 1 && sink_valid == 1)
//			sink_real <= ADC1_FIFO_O;
//	if(FFT_EN == 1 && FFT_I_EN == 0 && sink_valid == 1)
//			sink_real <= ADC0_FIFO_O;
	reg [9:0] FFT_cnt;
	//FFT输入点数计数器
	always @(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
			FFT_cnt <= 0;
			sink_valid <=0;
			sink_sop <= 0;
		end else begin
			if(FFT_EN == 1 && FFT_cnt !=1023)begin
//				if(FFT_cnt == 0)begin
					FFT_cnt <= FFT_cnt + 1'd1;
					sink_valid <= 1;
					sink_sop <= 0;
			end else if(FFT_EN == 1 && FFT_cnt == 1023)begin
//				sink_valid <= 0;
				FFT_cnt <= 0;
				sink_sop <= 1;
//				if(sink_ready == 1 && source_valid != 1 && source_valid != 1)begin
//					if(ADC1_rdreq==1 || ADC0_rdreq==1)
//						FFT_cnt <= 0;
//				end
			end
		end
	end
	//FFT使能逻辑
	always@(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
			sink_eop <= 0;
		end else begin	
			if(sink_valid == 1 && FFT_cnt == 1022)begin
				sink_eop <= 1;
			end else begin
				sink_eop <= 0;
			end
		end
	end
	//FFT读取逻辑
	always@(posedge Clk)begin
		if(source_valid == 1)begin
			source_ready <= 1;
			if(source_sop == 1)
				FFT_BG <= 1;
		end else if(source_valid == 0)begin
			FFT_BG <= 0;
		end
	end
	wire source_sop;
	wire source_eop;
	FFT FFT(
		.clk(Clk),
		.reset_n(Reset_n),
		.inverse(1'd0),
		.sink_valid(sink_valid),
		.sink_sop(sink_sop),
		.sink_eop(sink_eop),
		.sink_real(ADC0_Data),
		.sink_imag(7'd0),
		.sink_error(1'd0),
		.source_ready(source_ready),
		.sink_ready(sink_ready),
		.source_error(),
		.source_sop(source_sop),
		.source_eop(source_eop),
		.source_valid(source_valid),
		.source_exp(),
		.source_real(FFT_O_real),
		.source_imag(FFT_O_imag)
	);
	
endmodule
