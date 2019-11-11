library verilog;
use verilog.vl_types.all;
entity or1200_if is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        icpu_dat_i      : in     vl_logic_vector(31 downto 0);
        icpu_ack_i      : in     vl_logic;
        icpu_err_i      : in     vl_logic;
        icpu_adr_i      : in     vl_logic_vector(31 downto 0);
        icpu_tag_i      : in     vl_logic_vector(3 downto 0);
        if_freeze       : in     vl_logic;
        if_insn         : out    vl_logic_vector(31 downto 0);
        if_pc           : out    vl_logic_vector(31 downto 0);
        if_flushpipe    : in     vl_logic;
        saving_if_insn  : out    vl_logic;
        if_stall        : out    vl_logic;
        no_more_dslot   : in     vl_logic;
        genpc_refetch   : out    vl_logic;
        rfe             : in     vl_logic;
        except_itlbmiss : out    vl_logic;
        except_immufault: out    vl_logic;
        except_ibuserr  : out    vl_logic
    );
end or1200_if;
