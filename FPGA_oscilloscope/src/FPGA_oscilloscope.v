module FPGA_oscilloscope(
	Clk,
	Reset_n,
	Data,
	ADC_CLK0,
	
);
	input Clk;
	input Reset_n;
	input [7:0] Data;
	output reg uart_tx;
	output reg Led;
	//波特率计数器
	//1/9600*1_000_000_000/20-1
	
	reg [12:0] baud_div_cnt; 
	reg en_baud_cnt;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			baud_div_cnt <= 0;
		else if (en_baud_cnt) begin
			if(baud_div_cnt == 5207)
				baud_div_cnt <= 0;
			else 
				baud_div_cnt <= baud_div_cnt + 1'd1;
		end
		else 
			baud_div_cnt <= 0;
			
	//位计数器
	reg [3:0] bit_cnt;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			bit_cnt <= 0;
		else if(baud_div_cnt == 5207 ) begin
			if(bit_cnt == 9)
				bit_cnt <= 0;
			else
				bit_cnt <= bit_cnt + 1'd1;
		end
	
	//延时计数器
	reg [25:0] delay_cnt;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			delay_cnt <= 0;
		else if(delay_cnt == 50_000_000-1)
			delay_cnt <= 0;
		else 
			delay_cnt <= delay_cnt + 1'd1;
			
	//位发送逻辑
	reg [7:0] r_Data;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			r_Data <= 0;
		else if(delay_cnt == 50_000_000 - 1)
			r_Data <= Data;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			uart_tx <= 1;
		else begin
			case(bit_cnt)
				0:uart_tx <= 0;
				1:uart_tx <=r_Data[0];
				2:uart_tx <=r_Data[1];
				3:uart_tx <=r_Data[2];
				4:uart_tx <=r_Data[3];
				5:uart_tx <=r_Data[4];
				6:uart_tx <=r_Data[5];
				7:uart_tx <=r_Data[6];
				8:uart_tx <=r_Data[7];
				9:uart_tx <=1;
				default:uart_tx <= uart_tx;
			endcase
		end
				
	//led翻转逻辑
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			Led <= 0;
		else if((bit_cnt == 9)&&(baud_div_cnt == 5207))
			Led <= !Led;
endmodule
			