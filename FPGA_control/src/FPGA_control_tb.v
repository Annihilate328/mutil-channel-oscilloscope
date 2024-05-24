`timescale 1ns / 1ps

module textbench;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Signals
    reg Clk;
    reg Reset_n;
    reg [7:0] ADC0_Data;
    reg [7:0] ADC1_Data;
    reg ADC0_bg;
    reg ADC1_bg;
    reg [1:0] ADC_FIFO_O_EN;
    reg FFT_enable;
    reg FFT_select;
    wire ADC0_Clk;
    wire ADC1_Clk;
    wire [7:0] ADC_FIFO_Data;
    wire FFT_complete;
    wire [7:0] FFT_real;
    wire [7:0] FFT_imag;

    // Instantiate the module under test
    FPGA_control uut (
        .Clk(Clk),
        .Reset_n(Reset_n),
        .ADC0_Data(ADC0_Data),
        .ADC1_Data(ADC1_Data),
        .ADC0_bg(ADC0_bg),
        .ADC1_bg(ADC1_bg),
        .ADC_FIFO_O_EN(ADC_FIFO_O_EN),
        .FFT_enable(FFT_enable),
        .FFT_select(FFT_select),
        .ADC0_Clk(ADC0_Clk),
        .ADC1_Clk(ADC1_Clk),
        .ADC_FIFO_Data(ADC_FIFO_Data),
        .FFT_complete(FFT_complete),
        .FFT_real(FFT_real),
        .FFT_imag(FFT_imag)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) Clk <= ~Clk;

    // Reset generation
    initial begin
        Clk = 0;
        Reset_n = 0;
        ADC0_Data = 8'b0;
        ADC1_Data = 8'b0;
        ADC0_bg = 0;
        ADC1_bg = 0;
        ADC_FIFO_O_EN = 2'b00;
        FFT_enable = 0;
        FFT_select = 0;
        #100; // Wait for 100 ns
        Reset_n = 1;
        #1000; // Simulate for 1000 ns
        $finish; // End simulation
    end

    // Testbench stimulus
    initial begin
        #200; // Wait for 200 ns
        // Simulate ADC data and FFT enable
        repeat (5) begin
            ADC0_Data = $random;
            ADC1_Data = $random;
            ADC_FIFO_O_EN = $urandom_range(0, 2);
            FFT_enable = $urandom_range(0, 2);
            FFT_select = $urandom_range(0, 2);
            #100; // Wait for 100 ns
        end
    end

endmodule
