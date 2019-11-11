library verilog;
use verilog.vl_types.all;
entity or1200_tt is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        du_stall        : in     vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        intr            : out    vl_logic
    );
end or1200_tt;
