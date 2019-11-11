library verilog;
use verilog.vl_types.all;
entity or1200_pic is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        pic_wakeup      : out    vl_logic;
        intr            : out    vl_logic;
        pic_int         : in     vl_logic_vector(19 downto 0)
    );
end or1200_pic;
