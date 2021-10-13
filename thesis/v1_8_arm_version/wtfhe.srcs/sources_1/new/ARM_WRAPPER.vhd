library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity ARM_WRAPPER is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        START : in std_logic;
        RAM_WE : in std_logic; -- WE for internal BRAM
        RAM_DATA : in UNSIGNED(DATA_WIDTH - 1 DOWNTO 0); -- input to BRAM
        RAM_WE_ADDR : in UNSIGNED(ADDR_WIDTH - 1 DOWNTO 0); -- BRAM address
        RAM_EN : in std_logic;
        
        TLWE_OUT : out TLWE; -- delete this
        
        DONE : out std_logic
    );
end ARM_WRAPPER;

architecture ARM_WRAPPER_BODY of ARM_WRAPPER is

    component BOOTSTRAPPING_ARM is
    port (
        CLK : in std_logic;
        HW_RST : in std_logic;
        CONTROL : in std_logic_vector(1 downto 0);
        DOUTB : in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        ENB : out std_logic;
        WEB : out std_logic_vector(3 DOWNTO 0);
        ADDRB : out std_logic_vector(31 DOWNTO 0);
        DINB : out std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        DONE : out std_logic_vector(0 downto 0)
    );
    end component BOOTSTRAPPING_ARM;

    component blk_mem_gen_0 IS
    port (
       CLKA : in std_logic;
       ENA : in std_logic;
       WEA : in std_logic_vector(0 DOWNTO 0);
       ADDRA : in std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
       DINA : in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
       DOUTA : out std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
    end component;
    
    signal HW_RST : std_logic := '0';
    signal EN, EN_ARM : std_logic;
    signal WE : std_logic_vector(0 downto 0);
    signal WE_ARM : std_logic_vector(3 downto 0);
    
    signal RAM_ADDR : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    signal RAM_ADDR_ARM : UNSIGNED(31 downto 0);
    
    signal DOUT, DIN, DOUT_ARM, DIN_ARM : std_logic_vector(DATA_WIDTH - 1 downto 0);
    
begin
    --RAM_ADDR <= RAM_ADDR_ARM;
    process (RAM_WE, RAM_WE_ADDR, RAM_DATA, DOUT, EN_ARM, WE_ARM, RAM_ADDR_ARM, DIN_ARM)
    begin
        if RAM_WE = '1' then
            EN <= RAM_WE;
            WE(0) <= RAM_WE;
            RAM_ADDR <= RAM_WE_ADDR;
            DIN <= std_logic_vector(RAM_DATA);
            DOUT_ARM <= DOUT;
        else
            EN <= EN_ARM;
            WE <= WE_ARM(0 downto 0);
            RAM_ADDR <= RAM_ADDR_ARM(ADDR_WIDTH - 1 downto 0);
            DIN <= DIN_ARM;
            DOUT_ARM <= DOUT;
        end if;
    end process;

    bs: BOOTSTRAPPING_ARM port map (CLK => CLK, HW_RST => HW_RST, CONTROL(1) => START, CONTROL(0) => RST, DOUTB => DOUT_ARM, ENB => EN_ARM, WEB => WE_ARM, std_logic_vector(ADDRB) => RAM_ADDR_ARM, DINB => DIN_ARM, DONE(0) => DONE);

    -- BlockRAM instantiation
    ram: blk_mem_gen_0 port map (CLKA => CLK, ENA => EN, WEA => WE, ADDRA => std_logic_vector(RAM_ADDR), DINA => std_logic_vector(DIN), DOUTA => DOUT);
    


end ARM_WRAPPER_BODY;
