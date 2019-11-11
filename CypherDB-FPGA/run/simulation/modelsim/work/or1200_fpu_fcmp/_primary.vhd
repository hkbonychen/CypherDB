library verilog;
use verilog.vl_types.all;
entity or1200_fpu_fcmp is
    port(
        opa             : in     vl_logic_vector(31 downto 0);
        opb             : in     vl_logic_vector(31 downto 0);
        unordered       : out    vl_logic;
        altb            : out    vl_logic;
        blta            : out    vl_logic;
        aeqb            : out    vl_logic;
        inf             : out    vl_logic;
        zero            : out    vl_logic
    );
end or1200_fpu_fcmp;
