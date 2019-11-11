library verilog;
use verilog.vl_types.all;
entity or1200_mult_mac is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ex_freeze       : in     vl_logic;
        id_macrc_op     : in     vl_logic;
        macrc_op        : in     vl_logic;
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        mac_op          : in     vl_logic_vector(2 downto 0);
        alu_op          : in     vl_logic_vector(4 downto 0);
        result          : out    vl_logic_vector;
        mult_mac_stall  : out    vl_logic;
        ovforw          : out    vl_logic;
        ov_we           : out    vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end or1200_mult_mac;
