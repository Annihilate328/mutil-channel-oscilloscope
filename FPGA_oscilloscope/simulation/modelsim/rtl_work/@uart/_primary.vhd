library verilog;
use verilog.vl_types.all;
entity Uart is
    generic(
        CLOCK_FREQ      : integer := 50000000;
        BAUD            : integer := 115200;
        MCNT_BIT        : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1);
        MCNT_BAUD       : vl_logic_vector(0 to 19) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0)
    );
    port(
        Clk             : in     vl_logic;
        Reset_n         : in     vl_logic;
        Data            : in     vl_logic_vector(7 downto 0);
        send_en         : in     vl_logic;
        uart_tx         : out    vl_logic;
        tx_done         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLOCK_FREQ : constant is 1;
    attribute mti_svvh_generic_type of BAUD : constant is 1;
    attribute mti_svvh_generic_type of MCNT_BIT : constant is 1;
    attribute mti_svvh_generic_type of MCNT_BAUD : constant is 1;
end Uart;
