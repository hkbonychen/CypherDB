library verilog;
use verilog.vl_types.all;
entity or1200_fpu_pre_norm_addsub is
    generic(
        FP_WIDTH        : integer := 32;
        MUL_SERIAL      : integer := 0;
        MUL_COUNT       : integer := 11;
        FRAC_WIDTH      : integer := 23;
        EXP_WIDTH       : integer := 8;
        ZERO_VECTOR     : vl_logic_vector(0 to 30) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        INF             : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        QNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        SNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        clk_i           : in     vl_logic;
        opa_i           : in     vl_logic_vector;
        opb_i           : in     vl_logic_vector;
        fracta_28_o     : out    vl_logic_vector;
        fractb_28_o     : out    vl_logic_vector;
        exp_o           : out    vl_logic_vector
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
end or1200_fpu_pre_norm_addsub;
