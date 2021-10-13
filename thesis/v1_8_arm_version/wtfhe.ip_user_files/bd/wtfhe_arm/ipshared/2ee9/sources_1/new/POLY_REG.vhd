library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- register field capable of storing one TRLWE Sample
entity POLY_REG is
    port (
		CLK, WE, RST : in std_logic;
		A : in TORUS_POLYS;
		Y : out TORUS_POLYS
	);
end POLY_REG;

architecture POLY_REG_BODY of POLY_REG is
begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				Y <= (others => (others => to_unsigned(0, TAU)));
			elsif WE = '1' then
				Y <= A;
			end if;
		end if;
	end process;

end POLY_REG_BODY;