library verilog;
use verilog.vl_types.all;
entity or1200_fpu_intfloat_conv is
    generic(
        INF             : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        QNAN            : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        \SNAN\          : vl_logic_vector(0 to 30) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rmode           : in     vl_logic_vector(1 downto 0);
        fpu_op          : in     vl_logic_vector(2 downto 0);
        opa             : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0);
        snan            : out    vl_logic;
        ine             : out    vl_logic;
        inv             : out    vl_logic;
        overflow        : out    vl_logic;
        underflow       : out    vl_logic;
        zero            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INF : constant is 1;
    attribute mti_svvh_generic_type of QNAN : constant is 1;
    attribute mti_svvh_generic_type of \SNAN\ : constant is 1;
end or1200_fpu_intfloat_conv;
