library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- BRAM address register
-- control signal priority : RST > CE > PASS
entity ADDR_REG is
    port (
        CLK : in std_logic;
        RST : in std_logic; -- Resets registers to value on SET input
        CE : in std_logic; -- Enables address increment/decrement
        DIR : in std_logic; -- DIR 1: increment next address, DIR 0: decrement next address
        SET : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        Y : out UNSIGNED(ADDR_WIDTH - 1 downto 0)
    );
end ADDR_REG;

architecture ADDR_REG_BODY of ADDR_REG is

    signal TMP : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    
begin
    
    Y <= TMP;
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                TMP <= SET;
            elsif CE = '1' then
                if DIR = '1' then
                    TMP <= TMP + 1;
                else
                    TMP <= TMP - 1;
                end if;
            end if;
        end if;
    end process;

end ADDR_REG_BODY;
