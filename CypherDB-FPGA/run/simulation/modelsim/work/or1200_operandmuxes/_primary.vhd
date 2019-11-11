library verilog;
use verilog.vl_types.all;
entity or1200_operandmuxes is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        id_freeze       : in     vl_logic;
        ex_freeze       : in     vl_logic;
        rf_dataa        : in     vl_logic_vector;
        rf_datab        : in     vl_logic_vector;
        ex_forw         : in     vl_logic_vector;
        wb_forw         : in     vl_logic_vector;
        simm            : in     vl_logic_vector;
        sel_a           : in     vl_logic_vector(1 downto 0);
        sel_b           : in     vl_logic_vector(1 downto 0);
        operand_a       : out    vl_logic_vector;
        operand_b       : out    vl_logic_vector;
        muxed_a         : out    vl_logic_vector;
        muxed_b         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end or1200_operandmuxes;
