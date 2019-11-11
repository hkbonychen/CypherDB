library verilog;
use verilog.vl_types.all;
entity or1200_qmem_top is
    generic(
        dw              : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        qmemimmu_adr_i  : in     vl_logic_vector(31 downto 0);
        qmemimmu_cycstb_i: in     vl_logic;
        qmemimmu_ci_i   : in     vl_logic;
        qmemicpu_sel_i  : in     vl_logic_vector(3 downto 0);
        qmemicpu_tag_i  : in     vl_logic_vector(3 downto 0);
        qmemicpu_dat_o  : out    vl_logic_vector(31 downto 0);
        qmemicpu_ack_o  : out    vl_logic;
        qmemimmu_rty_o  : out    vl_logic;
        qmemimmu_err_o  : out    vl_logic;
        qmemimmu_tag_o  : out    vl_logic_vector(3 downto 0);
        icqmem_adr_o    : out    vl_logic_vector(31 downto 0);
        icqmem_cycstb_o : out    vl_logic;
        icqmem_ci_o     : out    vl_logic;
        icqmem_sel_o    : out    vl_logic_vector(3 downto 0);
        icqmem_tag_o    : out    vl_logic_vector(3 downto 0);
        icqmem_dat_i    : in     vl_logic_vector(31 downto 0);
        icqmem_ack_i    : in     vl_logic;
        icqmem_rty_i    : in     vl_logic;
        icqmem_err_i    : in     vl_logic;
        icqmem_tag_i    : in     vl_logic_vector(3 downto 0);
        qmemdmmu_adr_i  : in     vl_logic_vector(31 downto 0);
        qmemdmmu_cycstb_i: in     vl_logic;
        qmemdmmu_ci_i   : in     vl_logic;
        qmemdcpu_we_i   : in     vl_logic;
        qmemdcpu_sel_i  : in     vl_logic_vector(3 downto 0);
        qmemdcpu_tag_i  : in     vl_logic_vector(3 downto 0);
        qmemdcpu_dat_i  : in     vl_logic_vector(31 downto 0);
        qmemdcpu_dat_o  : out    vl_logic_vector(31 downto 0);
        qmemdcpu_ack_o  : out    vl_logic;
        qmemdcpu_rty_o  : out    vl_logic;
        qmemdmmu_err_o  : out    vl_logic;
        qmemdmmu_tag_o  : out    vl_logic_vector(3 downto 0);
        dcqmem_adr_o    : out    vl_logic_vector(31 downto 0);
        dcqmem_cycstb_o : out    vl_logic;
        dcqmem_ci_o     : out    vl_logic;
        dcqmem_we_o     : out    vl_logic;
        dcqmem_sel_o    : out    vl_logic_vector(3 downto 0);
        dcqmem_tag_o    : out    vl_logic_vector(3 downto 0);
        dcqmem_dat_o    : out    vl_logic_vector;
        dcqmem_dat_i    : in     vl_logic_vector;
        dcqmem_ack_i    : in     vl_logic;
        dcqmem_rty_i    : in     vl_logic;
        dcqmem_err_i    : in     vl_logic;
        dcqmem_tag_i    : in     vl_logic_vector(3 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of dw : constant is 1;
end or1200_qmem_top;
