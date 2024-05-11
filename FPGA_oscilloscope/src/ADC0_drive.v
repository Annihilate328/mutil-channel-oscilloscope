module ADC0_drive(
	ADC0_bg,
	ADC0_Clk,//ADC0输入时钟
	ADC_Clk,
	Reset_n,//复位
	I_AD_Data,//ADC输入数据
	F_I_ADC0_Data,//FIFO数据入口
	F_O_ADC0_Data,//FIFO数据出口
	ADC0_rdreq,//FIFO读标志位
	wrreq,//FIFO写标志位置
	ADC0_almost_empty,//几乎空
	ADC0_empty,//空信号
	ADC0_sclr,//FIFO清零
	Trigger_lever//触发电平
);
	input ADC0_bg;
	input ADC0_Clk;
	input Reset_n;
	input [7:0] Trigger_lever;
	input [7:0] I_AD_Data;
	input ADC0_almost_empty;
	input ADC0_empty;
	input ADC0_rdreq;
	output reg [7:0]F_I_ADC0_Data;
	output [7:0] F_O_ADC0_Data;
	output ADC0_sclr;
	output reg wrreq;
	output ADC_Clk;
	
	reg [7:0] AD_Data;
	reg [9:0] add;
	reg bg;
	wire ADC0_almost_full;
	wire full;
	
	assign ADC_Clk = ADC0_Clk;
	
	ADC0_FIFO ADC0_FIFO(
		.clock(ADC0_Clk),
		.data(AD_Data),
		.rdreq(ADC0_rdreq),
		.wrreq(wrreq),
		.sclr(ADC0_sclr),
		.almost_empty(ADC0_almost_empty),
		.almost_full(ADC0_almost_full),
		.empty(ADC0_empty),
		.full(full),
		.q(F_O_ADC0_Data)
	);
	//计数器，采集一段时间的电平，如果都没达到触发电平，那么就直接开始采样
	always@(posedge ADC0_Clk)
		if(add != 10'd1023&&I_AD_Data != Trigger_lever)
			add <= add + 1'd1;
		else if(bg == 1'd0&&ADC0_bg == 1'd1)
			add <= 10'd0;
	//采集信号,如果经过1024个点的采样仍然没有采到电平那就瞎采传
	always@(posedge ADC0_Clk)
		if(!bg) AD_Data <= I_AD_Data;
	//FIFO传入数据
	always@(posedge ADC0_Clk)
		if(full !=1'd1 && ADC0_almost_full !=1'd1 && bg == 1'd1)begin
			wrreq <= 1'd1;
			F_I_ADC0_Data <= AD_Data;
		end		
		else if(full == 1'd1||ADC0_almost_full == 1'd1)
			bg <= 1'd0;
		else if(I_AD_Data == Trigger_lever||add == 10'd1023)
			bg <= 1'd1;
endmodule
