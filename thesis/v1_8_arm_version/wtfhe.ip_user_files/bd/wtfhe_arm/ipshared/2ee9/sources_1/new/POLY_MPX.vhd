library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.const.all;

-- multiplex of two TRLWE Samples
entity POLY_MPX is
    port (
		A, B : in TORUS_POLYS;
		SEL : in std_logic;
		Y : out TORUS_POLYS
	);
end POLY_MPX;

architecture POLY_MPX_BODY of POLY_MPX is

begin

	process(A, B, SEL)
	begin
		if SEL = '1' then
			Y <= A;
		else
			Y <= B;
		end if;
	end process;

end POLY_MPX_BODY;
