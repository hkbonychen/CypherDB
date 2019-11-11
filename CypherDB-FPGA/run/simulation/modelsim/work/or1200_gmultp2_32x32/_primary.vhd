library verilog;
use verilog.vl_types.all;
entity or1200_gmultp2_32x32 is
    port(
        X               : in     vl_logic_vector(31 downto 0);
        Y               : in     vl_logic_vector(31 downto 0);
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        P               : out    vl_logic_vector(63 downto 0)
    );
end or1200_gmultp2_32x32;
