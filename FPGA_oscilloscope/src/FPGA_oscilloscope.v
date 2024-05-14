module FPGA_oscilloscope(
    input wire Clk,
    input wire Reset_n,
    input wire [7:0] I_AD_Data,
    output wire ADC_Clk,
    output wire uart_tx
);
    wire [7:0] F_O_ADC0_Data;
    wire uart_done;
    wire ADC0_rdempty;
    reg ADC0_bg;
    reg ADC0_rdreq;
    reg send_en;
    reg [7:0] uart_data;
    reg data_ready;

    // 实例化 ADC0_drive 模块
    ADC0_drive adc0_inst (
        .rdclk(Clk), // 假设 rdclk 与 Clk 相同
        .I_AD_Data(I_AD_Data), // ADC 输入数据
        .ADC0_bg(ADC0_bg), // ADC0 开始标志
        .ADC0_Clk(Clk), // ADC0 输入时钟
        .ADC_Clk(ADC_Clk),
        .Reset_n(Reset_n), // 复位
        .F_O_ADC0_Data(F_O_ADC0_Data), // FIFO 数据出口
        .ADC0_rdreq(ADC0_rdreq), // FIFO 读请求
        .ADC0_rdempty(ADC0_rdempty), // ADC0 空标志
        .Trigger_lever(8'd100) // 触发电平
    );

    // 实例化 Uart 模块
    Uart uart_inst (
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data(uart_data),
        .uart_tx(uart_tx),
        .send_en(send_en),
        .tx_done(uart_done)
    );
//	reg [2:0] con;
//	reg clk2;
//	always @(posedge Clk or negedge Reset_n)begin
//		if (!Reset_n)
//			con<= 0;
//		else if(con == 4)begin
//			clk2 <= ~clk2;
//			con<=0;
//		end else con <= con+1'd1; 
//	end
    // 控制逻辑
    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            ADC0_rdreq <= 0;
            send_en <= 0;
            ADC0_bg <= 0;
            data_ready <= 0;
        end else begin
            if (!ADC0_rdempty && !data_ready) begin
                ADC0_bg <= 1;
                ADC0_rdreq <= 1;
                uart_data <= F_O_ADC0_Data;
                data_ready <= 1;
            end else begin
                ADC0_rdreq <= 0;
                ADC0_bg <= 0;
            end
            if (data_ready) begin
                send_en <= 1;
                if (uart_done) begin
                    send_en <= 0;
                    data_ready <= 0;
                end
            end
        end
    end

endmodule
