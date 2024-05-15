library verilog;
use verilog.vl_types.all;
entity ADC0_drive is
    port(
        ADC0_bg         : in     vl_logic;
        ADC0_Clk        : in     vl_logic;
        rdclk           : in     vl_logic;
        Reset_n         : in     vl_logic;
        Trigger_lever   : in     vl_logic_vector(7 downto 0);
        I_AD_Data       : in     vl_logic_vector(7 downto 0);
        ADC0_rdreq      : in     vl_logic;
        F_O_ADC0_Data   : out    vl_logic_vector(7 downto 0);
        ADC_Clk         : out    vl_logic;
        ADC0_F_rdempty  : out    vl_logic;
        ADC0_F_full     : out    vl_logic
    );
end ADC0_drive;
