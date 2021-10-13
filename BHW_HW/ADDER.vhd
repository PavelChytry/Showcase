library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;


entity ADDER is
	port (
		A, B : in std_logic_vector((WIDTH - 1) downto 0);
		Y : out std_logic_vector((WIDTH - 1) downto 0)
	);
end ADDER;

architecture ADDER_BODY of ADDER is

begin

	process (A, B)
	begin
		Y <= A xor B;
	end process;

end ADDER_BODY;

