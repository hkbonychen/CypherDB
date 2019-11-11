library verilog;
use verilog.vl_types.all;
entity or1200_fpu_div is
    generic(
        FP_WIDTH        : integer := 32;
        MUL_SERIAL      : integer := 0;
        MUL_COUNT       : integer := 11;
        FRAC_WIDTH      : integer := 23;
        EXP_WIDTH       : integer := 8;
        ZERO_VECTOR     : vl_logic_vector(0 to 30) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        INF             : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        QNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        SNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        t_state_waiting : vl_logic := Hi0;
        t_state_busy    : vl_logic := Hi1
    );
    port(
        clk_i           : in     vl_logic;
        dvdnd_i         : in     vl_logic_vector;
        dvsor_i         : in     vl_logic_vector;
        sign_dvd_i      : in     vl_logic;
        sign_div_i      : in     vl_logic;
        start_i         : in     vl_logic;
        ready_o         : out    vl_logic;
        qutnt_o         : out    vl_logic_vector;
        rmndr_o         : out    vl_logic_vector;
        sign_o          : out    vl_logic;
        div_zero_o      : out    vl_logic
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
end or1200_fpu_div;
