library verilog;
use verilog.vl_types.all;
entity or1200_ic_top is
    generic(
        dw              : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        icbiu_dat_o     : out    vl_logic_vector;
        icbiu_adr_o     : out    vl_logic_vector(31 downto 0);
        icbiu_cyc_o     : out    vl_logic;
        icbiu_stb_o     : out    vl_logic;
        icbiu_we_o      : out    vl_logic;
        icbiu_sel_o     : out    vl_logic_vector(3 downto 0);
        icbiu_cab_o     : out    vl_logic;
        icbiu_dat_i     : in     vl_logic_vector;
        icbiu_ack_i     : in     vl_logic;
        icbiu_err_i     : in     vl_logic;
        ic_en           : in     vl_logic;
        icqmem_adr_i    : in     vl_logic_vector(31 downto 0);
        icqmem_cycstb_i : in     vl_logic;
        icqmem_ci_i     : in     vl_logic;
        icqmem_sel_i    : in     vl_logic_vector(3 downto 0);
        icqmem_tag_i    : in     vl_logic_vector(3 downto 0);
        icqmem_dat_o    : out    vl_logic_vector;
        icqmem_ack_o    : out    vl_logic;
        icqmem_rty_o    : out    vl_logic;
        icqmem_err_o    : out    vl_logic;
        icqmem_tag_o    : out    vl_logic_vector(3 downto 0);
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_dat_i       : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
end or1200_ic_top;
