library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity COMPARATOR is
	port (
		A, B : in std_logic_vector((WIDTH - 1) downto 0);
		EQ : out std_logic
	);
end COMPARATOR;

architecture COMPARATOR_BODY of COMPARATOR is

begin

	process (A, B)
	begin
		if A = B then
			EQ <= '1';
		else 
			EQ <= '0';
		end if;
	end process;
	
end COMPARATOR_BODY;

