library verilog;
use verilog.vl_types.all;
entity or1200_fpu_arith is
    generic(
        FP_WIDTH        : integer := 32;
        MUL_SERIAL      : integer := 1;
        MUL_COUNT       : integer := 34;
        FRAC_WIDTH      : integer := 23;
        EXP_WIDTH       : integer := 8;
        ZERO_VECTOR     : vl_logic_vector(0 to 30) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        INF             : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        QNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        SNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        t_state_waiting : integer := 0;
        t_state_busy    : integer := 1
    );
    port(
        clk_i           : in     vl_logic;
        opa_i           : in     vl_logic_vector;
        opb_i           : in     vl_logic_vector;
        fpu_op_i        : in     vl_logic_vector(2 downto 0);
        rmode_i         : in     vl_logic_vector(1 downto 0);
        output_o        : out    vl_logic_vector;
        start_i         : in     vl_logic;
        ready_o         : out    vl_logic;
        ine_o           : out    vl_logic;
        overflow_o      : out    vl_logic;
        underflow_o     : out    vl_logic;
        div_zero_o      : out    vl_logic;
        inf_o           : out    vl_logic;
        zero_o          : out    vl_logic;
        qnan_o          : out    vl_logic;
        snan_o          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FP_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of MUL_SERIAL : constant is 1;
    attribute mti_svvh_generic_type of MUL_COUNT : constant is 1;
    attribute mti_svvh_generic_type of FRAC_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of EXP_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ZERO_VECTOR : constant is 1;
    attribute mti_svvh_generic_type of INF : constant is 1;
    attribute mti_svvh_generic_type of QNAN : constant is 1;
    attribute mti_svvh_generic_type of SNAN : constant is 1;
    attribute mti_svvh_generic_type of t_state_waiting : constant is 1;
    attribute mti_svvh_generic_type of t_state_busy : constant is 1;
end or1200_fpu_arith;
