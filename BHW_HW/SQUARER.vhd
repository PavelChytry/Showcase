library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity SQUARER is
	port (
		A : in std_logic_vector((WIDTH - 1) downto 0);
		Y : out std_logic_vector((WIDTH - 1) downto 0)
	);
end SQUARER;

architecture SQUARER_BODY of SQUARER is

begin

	SQUARER : process(A)
		variable A2 : std_logic_vector(2 * WIDTH - 1 downto 0);
	begin
	A2 := (others=>'0');
	
	for i in WIDTH - 1 downto 0 loop -- A^2
		A2(i * 2) := A(i);
	end loop;
	
	for i in 2 * WIDTH - 1 downto WIDTH loop -- reduction
		if A2(i) = '1' then
			A2(i downto i - WIDTH) := A2(i downto i - WIDTH) xor Fx;
		end if;
	end loop;
	Y <= A2(WIDTH - 1 downto 0);
	end process;

end SQUARER_BODY;