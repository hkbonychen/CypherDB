library verilog;
use verilog.vl_types.all;
entity or1200_ic_ram is
    generic(
        dw              : integer := 32;
        aw              : integer := 13
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr            : in     vl_logic_vector;
        en              : in     vl_logic;
        we              : in     vl_logic_vector(3 downto 0);
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_ic_ram;
