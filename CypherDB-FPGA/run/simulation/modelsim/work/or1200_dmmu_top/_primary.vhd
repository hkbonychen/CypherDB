library verilog;
use verilog.vl_types.all;
entity or1200_dmmu_top is
    generic(
        dw              : integer := 32;
        aw              : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        dc_en           : in     vl_logic;
        dmmu_en         : in     vl_logic;
        supv            : in     vl_logic;
        dcpu_adr_i      : in     vl_logic_vector;
        dcpu_cycstb_i   : in     vl_logic;
        dcpu_we_i       : in     vl_logic;
        dcpu_tag_o      : out    vl_logic_vector(3 downto 0);
        dcpu_err_o      : out    vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector;
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        qmemdmmu_err_i  : in     vl_logic;
        qmemdmmu_tag_i  : in     vl_logic_vector(3 downto 0);
        qmemdmmu_adr_o  : out    vl_logic_vector;
        qmemdmmu_cycstb_o: out    vl_logic;
        qmemdmmu_ci_o   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_dmmu_top;
