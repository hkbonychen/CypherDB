library verilog;
use verilog.vl_types.all;
entity or1200_immu_top is
    generic(
        dw              : integer := 32;
        aw              : integer := 32;
        boot_adr        : integer := 256
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ic_en           : in     vl_logic;
        immu_en         : in     vl_logic;
        supv            : in     vl_logic;
        icpu_adr_i      : in     vl_logic_vector;
        icpu_cycstb_i   : in     vl_logic;
        icpu_adr_o      : out    vl_logic_vector(31 downto 0);
        icpu_tag_o      : out    vl_logic_vector(3 downto 0);
        icpu_rty_o      : out    vl_logic;
        icpu_err_o      : out    vl_logic;
        boot_adr_sel_i  : in     vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector;
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        qmemimmu_rty_i  : in     vl_logic;
        qmemimmu_err_i  : in     vl_logic;
        qmemimmu_tag_i  : in     vl_logic_vector(3 downto 0);
        qmemimmu_adr_o  : out    vl_logic_vector;
        qmemimmu_cycstb_o: out    vl_logic;
        qmemimmu_ci_o   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
    attribute mti_svvh_generic_type of boot_adr : constant is 1;
end or1200_immu_top;
