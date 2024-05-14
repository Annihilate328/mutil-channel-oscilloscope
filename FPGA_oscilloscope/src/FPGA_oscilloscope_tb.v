`timescale 1ns/1ps
module FPGA_oscilloscope_tb;

    // 时钟周期
    parameter CLK_PERIOD = 20;

    // 信号定义
    reg Clk;
    reg Reset_n;
    reg [7:0] I_AD_Data;
    wire ADC_Clk;
    wire uart_tx;

    // 实例化被测试模块
    FPGA_oscilloscope uut (
        .Clk(Clk),
        .Reset_n(Reset_n),
        .I_AD_Data(I_AD_Data),
        .ADC_Clk(ADC_Clk),
        .uart_tx(uart_tx)
    );

    // 时钟产生
    initial begin
        Clk = 0;
        forever #(CLK_PERIOD/2) Clk = ~Clk;
    end

    // 复位过程
    initial begin
        Reset_n = 0;
        #100;
        Reset_n = 1;
    end

    // 测试过程
    initial begin
        // 初始化信号
        I_AD_Data = 8'd0;

        // 触发电平为100，设置输入数据在不同的时刻模拟ADC数据变化
        #200;
        I_AD_Data = 8'd50; // 未达到触发电平
        #200;
        I_AD_Data = 8'd150; // 超过触发电平，触发采样开始
        #20;
        #200;
        I_AD_Data = 8'd75; // 继续采样
        #200;
        I_AD_Data = 8'd25; // 继续采样
        #200;
        I_AD_Data = 8'd100; // 再次触发
        #20;
        I_AD_Data = 8'd50;
        #200;
        I_AD_Data = 8'd200;
        #200;

        // 模拟FIFO数据被读取和UART发送的过程
        #2000;

        // 结束仿真
        $stop;
    end

endmodule
