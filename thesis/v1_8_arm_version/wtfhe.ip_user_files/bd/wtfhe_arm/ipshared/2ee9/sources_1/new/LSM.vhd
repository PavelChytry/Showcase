library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.const.all;

-- linear shift memory - right shift
-- B part in LSB multiplier (BHW)
entity LSM is
	port (
		CLK, RST, LOAD, PULSE : in std_logic; -- PULSE := shift array
		A : in INT_POLY;
		Y : out UNSIGNED(GAMMA - 1 downto 0)
	);
end LSM;

architecture LSM_BODY of LSM is

	signal O : INT_POLY;
	
begin

	Y <= O(0);
	
	-- control signal priority : RST > LOAD > PULSE
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				O <= (others => (others => '0'));
			elsif (LOAD = '1') then
				O <= A;
			elsif (PULSE = '1') then
				for I in N - 1 downto 1 loop
					O(I - 1) <= O(I);
				end loop;
				O(N - 1) <= (others => '0');
			end if;
		end if;
	end process;
	
end LSM_BODY;

