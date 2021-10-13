library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

-- multiply torus number by an integer
entity TORUSMULT is
	port (
		CLK : in std_logic; -- synchronous?
		I : in UNSIGNED(IOTA - 1 downto 0); -- integer
		T : in UNSIGNED(TAU - 1 downto 0); -- torus
		Y : out UNSIGNED(TAU - 1 downto 0)
	);
end TORUSMULT;

architecture TORUSMULT_BODY of TORUSMULT is

	signal R : UNSIGNED(TAU + IOTA - 1 downto 0);
	
begin
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			R <= I * T;
		end if;
	end process;

	Y <= R(TAU - 1 downto 0);
end TORUSMULT_BODY;

