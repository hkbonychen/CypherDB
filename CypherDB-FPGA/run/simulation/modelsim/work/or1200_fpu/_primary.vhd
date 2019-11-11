library verilog;
use verilog.vl_types.all;
entity or1200_fpu is
    generic(
        width           : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ex_freeze       : in     vl_logic;
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        fpu_op          : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector;
        done            : out    vl_logic;
        flagforw        : out    vl_logic;
        flag_we         : out    vl_logic;
        sig_fp          : out    vl_logic;
        except_started  : in     vl_logic;
        fpcsr_we        : in     vl_logic;
        fpcsr           : out    vl_logic_vector(11 downto 0);
        spr_cs          : in     vl_logic;
        spr_write       : in     vl_logic;
        spr_addr        : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_dat_o       : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end or1200_fpu;
