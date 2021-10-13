library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity SHIFTER is
	generic (
		SIZE : INTEGER
	);
	port (
		AO : in std_logic;
		A : in std_logic_vector((SIZE - 1) downto 0);
		Y : out std_logic_vector((SIZE - 1) downto 0);
		YO : out std_logic
	);
end SHIFTER;

architecture SHIFTER_BODY of SHIFTER is

begin

	--left shift by one
	process (AO, A)
	begin
		YO <= A(SIZE - 1);
		Y <= A((SIZE - 2) downto 0) & AO;
	end process;
	
end SHIFTER_BODY;
