library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity MULTIPLEX4 is
	generic (
		SIZE : INTEGER
	);
	port (
		A, B, C, D : in std_logic_vector((SIZE - 1) downto 0);
		SEL0, SEL1 : in std_logic;
		Y : out std_logic_vector((SIZE - 1) downto 0)
	);
end MULTIPLEX4;

architecture MULTIPLEX4_BODY of MULTIPLEX4 is

begin

	process(A, B, C, D, SEL0, SEL1)
	begin
		if (SEL0 = '0' and SEL1 = '0') then
			Y <= A;
		elsif (SEL0 = '1' and SEL1 = '0') then
			Y <= B;
		elsif (SEL0 = '0' and SEL1 = '1') then
			Y <= C;
		else
			Y <= D;
		end if;
	end process;

end MULTIPLEX4_BODY;