library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.const.all;

-- A part in LSB multiplier (BHW)
-- Stores TRLWE Sample, negacyclically rotates when PULSE = 1
entity NEGACYCLICMEM is
	port (
		CLK, RST, LOAD, PULSE : in std_logic; -- PULSE := rotate array
		DIR : in std_logic := '0';
		A : in TORUS_POLY;
		Y : out TORUS_POLY
	);
end NEGACYCLICMEM;

architecture NEGACYCLICMEM_BODY of NEGACYCLICMEM is

	signal O : TORUS_POLY;

begin

	Y <= O;
	
	-- control signal priority : RST > LOAD > PULSE
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				O <= (others => (others => '0'));
			elsif (LOAD = '1') then
				O <= A;
			elsif (PULSE = '1') then
			    if DIR = '0' then
				    for I in N - 1 downto 1 loop
					   O(I) <= O(I - 1);
				    end loop;
				    O(0) <= not(O(N - 1)) + 1;
				else
				    for I in N - 1 downto 1 loop
					   O(I - 1) <= O(I);
				    end loop;
				    O(N - 1) <= not(O(0)) + 1;
				end if;
			end if;
		end if;
	end process;

end NEGACYCLICMEM_BODY;

