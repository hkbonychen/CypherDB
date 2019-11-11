library verilog;
use verilog.vl_types.all;
entity or1200_cfgr is
    port(
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0)
    );
end or1200_cfgr;
