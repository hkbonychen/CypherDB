library verilog;
use verilog.vl_types.all;
entity or1200_rf is
    generic(
        dw              : integer := 32;
        aw              : integer := 5
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        cy_we_i         : in     vl_logic;
        cy_we_o         : out    vl_logic;
        supv            : in     vl_logic;
        wb_freeze       : in     vl_logic;
        addrw           : in     vl_logic_vector;
        dataw           : in     vl_logic_vector;
        we              : in     vl_logic;
        flushpipe       : in     vl_logic;
        id_freeze       : in     vl_logic;
        addra           : in     vl_logic_vector;
        addrb           : in     vl_logic_vector;
        dataa           : out    vl_logic_vector;
        datab           : out    vl_logic_vector;
        rda             : in     vl_logic;
        rdb             : in     vl_logic;
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0);
        du_read         : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
    attribute mti_svvh_generic_type of aw : constant is 1;
end or1200_rf;
