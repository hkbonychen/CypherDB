library verilog;
use verilog.vl_types.all;
entity or1200_wbmux is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        wb_freeze       : in     vl_logic;
        rfwb_op         : in     vl_logic_vector(3 downto 0);
        muxin_a         : in     vl_logic_vector;
        muxin_b         : in     vl_logic_vector;
        muxin_c         : in     vl_logic_vector;
        muxin_d         : in     vl_logic_vector;
        muxin_e         : in     vl_logic_vector;
        muxout          : out    vl_logic_vector;
        muxreg          : out    vl_logic_vector;
        muxreg_valid    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end or1200_wbmux;
