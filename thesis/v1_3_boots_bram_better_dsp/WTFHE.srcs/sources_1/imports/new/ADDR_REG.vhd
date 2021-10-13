library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- bRAM address register
-- control signal priority : RST > CE > PASS
entity ADDR_REG is
    port (
        CLK : in std_logic;
        RST : in std_logic; -- Resets registers to value on SET input
        CE : in std_logic; -- Enables address increment/decrement
        DIR : in std_logic; -- DIR 1: increment next address, DIR 0: decrement next address
        PASS : in std_logic; -- PASS 1: , PASS 0: ignore passthrough
        SET : in UNSIGNED(10 downto 0);
        PASSTHROUGH : in UNSIGNED(10 downto 0) := to_unsigned(0, 11);
        Y : out UNSIGNED(10 downto 0)
    );
end ADDR_REG;

architecture ADDR_REG_BODY of ADDR_REG is

    signal TMP : UNSIGNED(10 downto 0);
    
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
            elsif PASS = '1' then
                TMP <= PASSTHROUGH;
            end if;
        end if;
    end process;

end ADDR_REG_BODY;
