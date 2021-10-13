library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.const.all;

-- Decrementing counter
-- control signal priority : RST > CE
entity COUNTER is
	port (
		CLK : in std_logic;
		RST : in std_logic; -- Resets internal value to N - 1
		CE : in std_logic; -- Clock Enable for counter
		ZERO : out std_logic -- High if counter is zero
	);
end COUNTER;

architecture COUNTER_BODY of COUNTER is

	signal CNT : UNSIGNED(CNT_WIDTH - 1 downto 0);
	
	constant C_ZERO : UNSIGNED(CNT_WIDTH - 1 downto 0) := to_unsigned(0, CNT_WIDTH);
	
begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				CNT <= to_unsigned(N - 1, CNT_WIDTH);
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
	
end COUNTER_BODY;

