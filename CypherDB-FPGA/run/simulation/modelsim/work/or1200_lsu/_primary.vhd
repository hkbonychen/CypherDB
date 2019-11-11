library verilog;
use verilog.vl_types.all;
entity or1200_lsu is
    generic(
        dw              : integer := 32;
        aw              : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        id_addrbase     : in     vl_logic_vector(31 downto 0);
        ex_addrbase     : in     vl_logic_vector(31 downto 0);
        id_addrofs      : in     vl_logic_vector(31 downto 0);
        ex_addrofs      : in     vl_logic_vector(31 downto 0);
        id_lsu_op       : in     vl_logic_vector(3 downto 0);
        lsu_datain      : in     vl_logic_vector;
        lsu_dataout     : out    vl_logic_vector;
        lsu_stall       : out    vl_logic;
        lsu_unstall     : out    vl_logic;
        du_stall        : in     vl_logic;
        except_align    : out    vl_logic;
        except_dtlbmiss : out    vl_logic;
        except_dmmufault: out    vl_logic;
        except_dbuserr  : out    vl_logic;
        id_freeze       : in     vl_logic;
        ex_freeze       : in     vl_logic;
        flushpipe       : in     vl_logic;
        dcpu_adr_o      : out    vl_logic_vector(31 downto 0);
        dcpu_cycstb_o   : out    vl_logic;
        dcpu_we_o       : out    vl_logic;
        dcpu_sel_o      : out    vl_logic_vector(3 downto 0);
        dcpu_tag_o      : out    vl_logic_vector(3 downto 0);
        dcpu_dat_o      : out    vl_logic_vector(31 downto 0);
        dcpu_dat_i      : in     vl_logic_vector(31 downto 0);
        dcpu_ack_i      : in     vl_logic;
        dcpu_rty_i      : in     vl_logic;
        dcpu_err_i      : in     vl_logic;
        dcpu_tag_i      : in     vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_lsu;
