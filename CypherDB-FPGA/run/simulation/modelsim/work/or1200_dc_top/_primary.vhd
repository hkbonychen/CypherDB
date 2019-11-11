library verilog;
use verilog.vl_types.all;
entity or1200_dc_top is
    generic(
        dw              : integer := 32;
        aw              : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        dcsb_dat_o      : out    vl_logic_vector;
        dcsb_adr_o      : out    vl_logic_vector(31 downto 0);
        dcsb_cyc_o      : out    vl_logic;
        dcsb_stb_o      : out    vl_logic;
        dcsb_we_o       : out    vl_logic;
        dcsb_sel_o      : out    vl_logic_vector(3 downto 0);
        dcsb_cab_o      : out    vl_logic;
        dcsb_dat_i      : in     vl_logic_vector;
        dcsb_ack_i      : in     vl_logic;
        dcsb_err_i      : in     vl_logic;
        dc_en           : in     vl_logic;
        dcqmem_adr_i    : in     vl_logic_vector(31 downto 0);
        dcqmem_cycstb_i : in     vl_logic;
        dcqmem_ci_i     : in     vl_logic;
        dcqmem_we_i     : in     vl_logic;
        dcqmem_sel_i    : in     vl_logic_vector(3 downto 0);
        dcqmem_tag_i    : in     vl_logic_vector(3 downto 0);
        dcqmem_dat_i    : in     vl_logic_vector;
        dcqmem_dat_o    : out    vl_logic_vector;
        dcqmem_ack_o    : out    vl_logic;
        dcqmem_rty_o    : out    vl_logic;
        dcqmem_err_o    : out    vl_logic;
        dcqmem_tag_o    : out    vl_logic_vector(3 downto 0);
        dc_no_writethrough: in     vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_addr        : in     vl_logic_vector;
        mtspr_dc_done   : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_dc_top;
