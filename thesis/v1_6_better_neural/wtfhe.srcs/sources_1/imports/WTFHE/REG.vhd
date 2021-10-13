library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity REG is
	generic (
		REG_SIZE : INTEGER
	);
	port (
		CLK, WE, RST : in std_logic;
		A : in UNSIGNED((REG_SIZE - 1) downto 0);
		Y : out UNSIGNED((REG_SIZE - 1) downto 0)
	);
end REG;

architecture REG_BODY of REG is

begin
	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Y <= to_unsigned(0, REG_SIZE);
			elsif WE = '1' then
				Y <= A;
			end if;
		end if;
	end process;

end REG_BODY;

