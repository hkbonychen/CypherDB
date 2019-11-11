library verilog;
use verilog.vl_types.all;
entity or1200_dc_tag is
    generic(
        dw              : integer := 19;
        aw              : integer := 10
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr            : in     vl_logic_vector;
        en              : in     vl_logic;
        we              : in     vl_logic;
        datain          : in     vl_logic_vector;
        tag_v           : out    vl_logic;
        tag             : out    vl_logic_vector;
        dirty           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_dc_tag;
