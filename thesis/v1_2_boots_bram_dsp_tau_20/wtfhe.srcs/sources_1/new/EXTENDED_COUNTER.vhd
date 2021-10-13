library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

-- Decrementing counter with custom SET and register output
-- control signal priority : RST > CE
entity EXTENDED_COUNTER is
	port (
		CLK : in std_logic;
		RST : in std_logic; -- Resets counter to a value on SET input
		CE : in std_logic; -- Count enable
		SET : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0); -- Current internal value of counter
		ZERO : out std_logic
	);
end EXTENDED_COUNTER;

architecture EXTENDED_COUNTER_BODY of EXTENDED_COUNTER is

	signal CNT : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
	
	constant C_ZERO : UNSIGNED(CNT_UART_WIDTH - 1 downto 0) := to_unsigned(0, CNT_UART_WIDTH);
	
begin

	CNT_R <= CNT;
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				CNT <= SET;
			elsif CE = '1' then
				CNT <= CNT - 1;
			end if;
			if CNT = C_ZERO then
				ZERO <= '1';
			else
				ZERO <= '0';
			end if;
		end if;
	end process;

end EXTENDED_COUNTER_BODY;
