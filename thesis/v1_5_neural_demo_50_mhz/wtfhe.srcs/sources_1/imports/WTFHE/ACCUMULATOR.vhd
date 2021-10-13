library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.const.all;

-- C part in LSB multiplier (BHW)
-- Accumulates torus polynom
-- control signal priority : RST > PULSE
entity ACCUMULATOR is
	port (
		CLK : in std_logic;
		RST : in std_logic; -- Resets accumulator to zero
		PULSE : in std_logic; -- PULSE := add array
		A : in TORUS_POLY;
		Y : out TORUS_POLY
	);
end ACCUMULATOR;

architecture ACCUMULATOR_BODY of ACCUMULATOR is

	signal O : TORUS_POLY;

begin

	Y <= O;
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				O <= (others => (others => '0'));
			elsif (PULSE = '1') then
				for I in N - 1 downto 0 loop
					O(I) <= O(I) + A(I);
				end loop;
			end if;
		end if;
	end process;

end ACCUMULATOR_BODY;


