library verilog;
use verilog.vl_types.all;
entity or1200_genpc is
    generic(
        boot_adr        : integer := 256
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        icpu_adr_o      : out    vl_logic_vector(31 downto 0);
        icpu_cycstb_o   : out    vl_logic;
        icpu_sel_o      : out    vl_logic_vector(3 downto 0);
        icpu_tag_o      : out    vl_logic_vector(3 downto 0);
        icpu_rty_i      : in     vl_logic;
        icpu_adr_i      : in     vl_logic_vector(31 downto 0);
        pre_branch_op   : in     vl_logic_vector(2 downto 0);
        branch_op       : in     vl_logic_vector(2 downto 0);
        except_type     : in     vl_logic_vector(3 downto 0);
        except_prefix   : in     vl_logic;
        id_branch_addrtarget: in     vl_logic_vector(31 downto 2);
        ex_branch_addrtarget: in     vl_logic_vector(31 downto 2);
        muxed_b         : in     vl_logic_vector(31 downto 0);
        operand_b       : in     vl_logic_vector(31 downto 0);
        flag            : in     vl_logic;
        flagforw        : in     vl_logic;
        ex_branch_taken : out    vl_logic;
        except_start    : in     vl_logic;
        epcr            : in     vl_logic_vector(31 downto 0);
        spr_dat_i       : in     vl_logic_vector(31 downto 0);
        spr_pc_we       : in     vl_logic;
        genpc_refetch   : in     vl_logic;
        genpc_freeze    : in     vl_logic;
        no_more_dslot   : in     vl_logic;
        lsu_stall       : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of boot_adr : constant is 1;
end or1200_genpc;
