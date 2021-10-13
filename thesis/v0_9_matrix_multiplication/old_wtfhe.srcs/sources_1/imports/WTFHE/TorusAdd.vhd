library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.CONST.ALL;

-- add two torus numbers
entity TORUSADD is
	port (
		CLK : in std_logic;
		A, B : in std_logic_vector(TAU - 1 downto 0);
		Y : out std_logic_vector(TAU - 1 downto 0)
	);
end TORUSADD;

architecture TORUSADD_BODY of TORUSADD is

begin

	process (CLK)
	begin
		-- not sure if synchronous or not
		if rising_edge(CLK) then
			Y <= A + B;
		end if;
	end process;

end TORUSADD_BODY;

