library verilog;
use verilog.vl_types.all;
entity FPGA_oscilloscope_tb is
    generic(
        CLK_PERIOD      : integer := 20
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_PERIOD : constant is 1;
end FPGA_oscilloscope_tb;
