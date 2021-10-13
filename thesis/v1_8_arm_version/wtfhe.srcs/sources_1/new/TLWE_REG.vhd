library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity TLWE_REG is
    port (
        CLK, RST, WE : in std_logic;
        INDEX : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        TLWE_OUT : out TLWE
    );
end TLWE_REG;

architecture TLWE_REG_BODY of TLWE_REG is

    --signal TMP : TLWE;
    
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                TLWE_OUT <= (others => to_unsigned(0, TAU));
            elsif WE = '1' then
                TLWE_OUT(to_integer(INDEX(CNT_WIDTH downto 0))) <= DATA;
            end if;
        end if;
    end process;
    
end TLWE_REG_BODY;