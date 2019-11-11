library verilog;
use verilog.vl_types.all;
entity or1200_freeze is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        multicycle      : in     vl_logic_vector(2 downto 0);
        wait_on         : in     vl_logic_vector(1 downto 0);
        flushpipe       : in     vl_logic;
        extend_flush    : in     vl_logic;
        lsu_stall       : in     vl_logic;
        if_stall        : in     vl_logic;
        lsu_unstall     : in     vl_logic;
        du_stall        : in     vl_logic;
        mac_stall       : in     vl_logic;
        force_dslot_fetch: in     vl_logic;
        abort_ex        : in     vl_logic;
        genpc_freeze    : out    vl_logic;
        if_freeze       : out    vl_logic;
        id_freeze       : out    vl_logic;
        ex_freeze       : out    vl_logic;
        wb_freeze       : out    vl_logic;
        saving_if_insn  : in     vl_logic;
        fpu_done        : in     vl_logic;
        mtspr_done      : in     vl_logic;
        icpu_ack_i      : in     vl_logic;
        icpu_err_i      : in     vl_logic
    );
end or1200_freeze;
