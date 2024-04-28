module Uart(
	Clk,
	Reset_n,
	Data,
	send_en,
	uart_tx,
	tx_done,
);
	input Clk;
	input Reset_n;
	input [7:0] Data;
	input send_en;
	output reg uart_tx;
	output reg tx_done;
	
	parameter CLOCK_FREQ = 50_000_000;
	parameter BAUD = 9600;
	parameter MCNT_BIT = 10 - 1;
	parameter MCNT_BAUD =CLOCK_FREQ/BAUD - 1;
	
	//波特率计数器
	//1/9600*1_000_000_000/20-1
	
	reg [29:0] baud_div_cnt; 
	reg en_baud_cnt;
	reg [3:0] bit_cnt;
	reg [7:0] r_Data;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			en_baud_cnt <= 0;
		else if(send_en)
			en_baud_cnt <= 1;
		else if(w_tx_done)
			en_baud_cnt <= 0;
	
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			baud_div_cnt <= 0;
		else if (en_baud_cnt) begin
			if(baud_div_cnt == MCNT_BAUD)
				baud_div_cnt <= 0;
			else 
				baud_div_cnt <= baud_div_cnt + 1'd1;
		end
		else 
			baud_div_cnt <= 0;
			
	//位计数器
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			bit_cnt <= 0;
		else if(baud_div_cnt == MCNT_BAUD ) begin
			if(bit_cnt == MCNT_BIT)
				bit_cnt <= 0;
			else
				bit_cnt <= bit_cnt + 1'd1;
		end
	//位发送逻辑
	always@(posedge Clk or negedge Reset_n)
		if(!Reset_n)
			r_Data <= 0;
		else if(send_en)
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
	//发送完成信号位逻辑
	wire w_tx_done;
	
	assign w_tx_done = ((bit_cnt == MCNT_BIT)&&(baud_div_cnt == MCNT_BAUD));
	
	always@(posedge Clk)
		tx_done <= w_tx_done;
		
endmodule
			