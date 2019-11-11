library verilog;
use verilog.vl_types.all;
entity or1200_pm is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pic_wakeup      : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        pm_clksd        : out    vl_logic_vector(3 downto 0);
        pm_cpustall     : in     vl_logic;
        pm_dc_gate      : out    vl_logic;
        pm_ic_gate      : out    vl_logic;
        pm_dmmu_gate    : out    vl_logic;
        pm_immu_gate    : out    vl_logic;
        pm_tt_gate      : out    vl_logic;
        pm_cpu_gate     : out    vl_logic;
        pm_wakeup       : out    vl_logic;
        pm_lvolt        : out    vl_logic
    );
end or1200_pm;
