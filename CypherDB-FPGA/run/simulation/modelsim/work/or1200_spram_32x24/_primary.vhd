library verilog;
use verilog.vl_types.all;
entity or1200_spram_32x24 is
    generic(
        aw              : integer := 5;
        dw              : integer := 24
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ce              : in     vl_logic;
        we              : in     vl_logic;
        oe              : in     vl_logic;
        addr            : in     vl_logic_vector;
        di              : in     vl_logic_vector;
        doq             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of aw : constant is 1;
    attribute mti_svvh_generic_type of dw : constant is 1;
end or1200_spram_32x24;
