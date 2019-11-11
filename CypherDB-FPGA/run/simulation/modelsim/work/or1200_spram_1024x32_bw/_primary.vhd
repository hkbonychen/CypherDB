library verilog;
use verilog.vl_types.all;
entity or1200_spram_1024x32_bw is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ce              : in     vl_logic;
        we              : in     vl_logic_vector(3 downto 0);
        oe              : in     vl_logic;
        addr            : in     vl_logic_vector(9 downto 0);
        di              : in     vl_logic_vector(31 downto 0);
        doq             : out    vl_logic_vector(31 downto 0)
    );
end or1200_spram_1024x32_bw;
