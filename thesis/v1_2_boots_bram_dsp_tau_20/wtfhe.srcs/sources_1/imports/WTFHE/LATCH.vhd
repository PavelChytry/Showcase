library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.all;

entity LATCH is
	port (
		CLK, RST, A : in std_logic;
		Y : out std_logic
	);
end LATCH;

architecture LATCH_BODY of LATCH is

begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Y <= '0';
			elsif A = '1' then
				Y <= '1';
			end if;
		end if;
	end process;
	
end LATCH_BODY;

