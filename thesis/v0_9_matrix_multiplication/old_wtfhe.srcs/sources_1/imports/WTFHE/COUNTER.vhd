library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.const.all;

entity COUNTER is
	port (
		CLK, RST, CE : in std_logic;
		ZERO : out std_logic
	);
end COUNTER;

architecture COUNTER_BODY of COUNTER is

	signal CNT : std_logic_vector((CNT_WIDTH - 1) downto 0);
	
	constant C_ZERO : std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '0');
	
begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				CNT <= std_logic_vector(to_unsigned(N - 1, CNT_WIDTH));
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
