library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity REG is
	generic (
		REG_SIZE : INTEGER
	);
	port (
		CLK, WE, RST : in std_logic;
		A : in std_logic_vector((REG_SIZE - 1) downto 0);
		Y : out std_logic_vector((REG_SIZE - 1) downto 0)
	);
end REG;

architecture REG_BODY of REG is

begin
	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Y <= (others => '0');
			elsif WE = '1' then
				Y <= A;
			end if;
		end if;
	end process;

end REG_BODY;

