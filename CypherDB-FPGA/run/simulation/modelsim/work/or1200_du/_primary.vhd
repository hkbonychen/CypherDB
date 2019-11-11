library verilog;
use verilog.vl_types.all;
entity or1200_du is
    generic(
        dw              : integer := 32;
        aw              : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        dcpu_cycstb_i   : in     vl_logic;
        dcpu_we_i       : in     vl_logic;
        dcpu_adr_i      : in     vl_logic_vector(31 downto 0);
        dcpu_dat_lsu    : in     vl_logic_vector(31 downto 0);
        dcpu_dat_dc     : in     vl_logic_vector(31 downto 0);
        icpu_cycstb_i   : in     vl_logic_vector(0 downto 0);
        ex_freeze       : in     vl_logic;
        branch_op       : in     vl_logic_vector(2 downto 0);
        ex_insn         : in     vl_logic_vector;
        id_pc           : in     vl_logic_vector(31 downto 0);
        spr_dat_npc     : in     vl_logic_vector(31 downto 0);
        rf_dataw        : in     vl_logic_vector(31 downto 0);
        du_dsr          : out    vl_logic_vector(13 downto 0);
        du_dmr1         : out    vl_logic_vector(24 downto 0);
        du_stall        : out    vl_logic;
        du_addr         : out    vl_logic_vector;
        du_dat_i        : in     vl_logic_vector;
        du_dat_o        : out    vl_logic_vector;
        du_read         : out    vl_logic;
        du_write        : out    vl_logic;
        du_except_stop  : in     vl_logic_vector(13 downto 0);
        du_hwbkpt       : out    vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector;
        spr_dat_i       : in     vl_logic_vector;
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        dbg_stall_i     : in     vl_logic;
        dbg_ewt_i       : in     vl_logic;
        dbg_lss_o       : out    vl_logic_vector(3 downto 0);
        dbg_is_o        : out    vl_logic_vector(1 downto 0);
        dbg_wp_o        : out    vl_logic_vector(10 downto 0);
        dbg_bp_o        : out    vl_logic;
        dbg_stb_i       : in     vl_logic;
        dbg_we_i        : in     vl_logic;
        dbg_adr_i       : in     vl_logic_vector;
        dbg_dat_i       : in     vl_logic_vector;
        dbg_dat_o       : out    vl_logic_vector;
        dbg_ack_o       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_du;
