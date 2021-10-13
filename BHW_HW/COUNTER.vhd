library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.CONST.ALL;

entity COUNTER is
	port (
		CLK, RST, CE : in std_logic;
		LOAD : in std_logic := '0';
		DATA : in std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '1');
		ZERO, ONE : out std_logic
	);
end COUNTER;

architecture COUNTER_BODY of COUNTER is

	signal CNT : std_logic_vector((CNT_WIDTH - 1) downto 0);
	
	constant C_ZERO : std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '0');
	constant C_ONE : std_logic_vector((CNT_WIDTH - 1) downto 0) := (0 => '1', others => '0');
begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				CNT <= std_logic_vector(to_unsigned(WIDTH - 1, CNT_WIDTH));
			elsif LOAD = '1' then
				CNT <= DATA;
			elsif CE = '1' then
				CNT <= CNT - 1;
			end if;
			if CNT = C_ZERO then
				ZERO <= '1';
			else
				ZERO <= '0';
			end if;
			if CNT = C_ONE then
				ONE <= '1';
			else
				ONE <= '0';
			end if;
		end if;
	end process;

end COUNTER_BODY;