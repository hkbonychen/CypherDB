library verilog;
use verilog.vl_types.all;
entity or1200_dpram is
    generic(
        aw              : integer := 5;
        dw              : integer := 32
    );
    port(
        clk_a           : in     vl_logic;
        ce_a            : in     vl_logic;
        addr_a          : in     vl_logic_vector;
        do_a            : out    vl_logic_vector;
        clk_b           : in     vl_logic;
        ce_b            : in     vl_logic;
        we_b            : in     vl_logic;
        addr_b          : in     vl_logic_vector;
        di_b            : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of aw : constant is 1;
    attribute mti_svvh_generic_type of dw : constant is 1;
end or1200_dpram;
