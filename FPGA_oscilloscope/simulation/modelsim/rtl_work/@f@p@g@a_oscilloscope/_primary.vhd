library verilog;
use verilog.vl_types.all;
entity FPGA_oscilloscope is
    port(
        Clk             : in     vl_logic;
        Reset_n         : in     vl_logic;
        I_AD_Data       : in     vl_logic_vector(7 downto 0);
        ADC_Clk         : out    vl_logic;
        uart_tx         : out    vl_logic
    );
end FPGA_oscilloscope;
