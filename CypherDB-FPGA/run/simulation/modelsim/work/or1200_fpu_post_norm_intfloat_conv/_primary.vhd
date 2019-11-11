library verilog;
use verilog.vl_types.all;
entity or1200_fpu_post_norm_intfloat_conv is
    generic(
        f2i_emax        : vl_logic_vector(0 to 7) := (Hi1, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        fpu_op          : in     vl_logic_vector(2 downto 0);
        opas            : in     vl_logic;
        sign            : in     vl_logic;
        rmode           : in     vl_logic_vector(1 downto 0);
        fract_in        : in     vl_logic_vector(47 downto 0);
        exp_in          : in     vl_logic_vector(7 downto 0);
        opa_dn          : in     vl_logic;
        opa_nan         : in     vl_logic;
        opa_inf         : in     vl_logic;
        opb_dn          : in     vl_logic;
        \out\           : out    vl_logic_vector(30 downto 0);
        ine             : out    vl_logic;
        inv             : out    vl_logic;
        overflow        : out    vl_logic;
        underflow       : out    vl_logic;
        f2i_out_sign    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of f2i_emax : constant is 1;
end or1200_fpu_post_norm_intfloat_conv;
