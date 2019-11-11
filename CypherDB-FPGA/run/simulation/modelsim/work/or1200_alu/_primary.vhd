library verilog;
use verilog.vl_types.all;
entity or1200_alu is
    generic(
        width           : integer := 32
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        mult_mac_result : in     vl_logic_vector;
        macrc_op        : in     vl_logic;
        alu_op          : in     vl_logic_vector(4 downto 0);
        alu_op2         : in     vl_logic_vector(3 downto 0);
        comp_op         : in     vl_logic_vector(3 downto 0);
        cust5_op        : in     vl_logic_vector(4 downto 0);
        cust5_limm      : in     vl_logic_vector(5 downto 0);
        result          : out    vl_logic_vector;
        flagforw        : out    vl_logic;
        flag_we         : out    vl_logic;
        ovforw          : out    vl_logic;
        ov_we           : out    vl_logic;
        cyforw          : out    vl_logic;
        cy_we           : out    vl_logic;
        carry           : in     vl_logic;
        flag            : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end or1200_alu;
