library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity MULTIPLEX is
	generic (
		SIZE : INTEGER
	);
	port (
		A, B : in std_logic_vector((SIZE - 1) downto 0);
		SEL : in std_logic;
		Y : out std_logic_vector((SIZE - 1) downto 0)
	);
end MULTIPLEX;

architecture MULTIPLEX_BODY of MULTIPLEX is

begin

	process(A, B, SEL)
	begin
		if SEL = '1' then
			Y <= A;
		else
			Y <= B;
		end if;
	end process;

end MULTIPLEX_BODY;