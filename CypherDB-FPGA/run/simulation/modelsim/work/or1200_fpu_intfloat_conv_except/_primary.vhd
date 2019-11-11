library verilog;
use verilog.vl_types.all;
entity or1200_fpu_intfloat_conv_except is
    port(
        clk             : in     vl_logic;
        opa             : in     vl_logic_vector(31 downto 0);
        opb             : in     vl_logic_vector(31 downto 0);
        inf             : out    vl_logic;
        ind             : out    vl_logic;
        qnan            : out    vl_logic;
        snan            : out    vl_logic;
        opa_nan         : out    vl_logic;
        opb_nan         : out    vl_logic;
        opa_00          : out    vl_logic;
        opb_00          : out    vl_logic;
        opa_inf         : out    vl_logic;
        opb_inf         : out    vl_logic;
        opa_dn          : out    vl_logic;
        opb_dn          : out    vl_logic
    );
end or1200_fpu_intfloat_conv_except;
