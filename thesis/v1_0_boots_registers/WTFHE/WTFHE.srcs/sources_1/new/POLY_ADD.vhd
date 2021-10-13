library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity POLY_ADD is
     port (
		CLK : in std_logic;
		A, B : in TORUS_POLYS;
		Y : out TORUS_POLYS
	);
end POLY_ADD;

architecture POLY_ADD_BODY of POLY_ADD is

begin

	process (CLK)
	begin
		if rising_edge(CLK) then
		  for i_j in K downto 0 loop
				for i_i in N - 1 downto 0 loop
					Y(i_j)(i_i) <= A(i_j)(i_i) + B(i_j)(i_i);
				end loop;
		  end loop;
		end if;
	end process;

end POLY_ADD_BODY;
