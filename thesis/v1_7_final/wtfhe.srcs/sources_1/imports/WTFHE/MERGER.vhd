library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

-- merges 8 bit inputs from UART into 32 bit chunks
entity MERGER is
	port (
		CLK, RST, RXD_STROBE : in std_logic;
		RXD_DATA : in std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		DATA_OUT : out std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
		DONE : out std_logic
	);
end MERGER;

architecture MERGER_BODY of MERGER is
	
begin

	process (CLK)
		variable CNT : integer range 0 to NO_OF_INPUT_BITS / NO_OF_TRANSFERRED_BITS;
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				DATA_OUT <= (others => '0');
				DONE <= '0';
				CNT := 0;
			elsif RXD_STROBE = '1' then
				DATA_OUT(NO_OF_INPUT_BITS - CNT * 8 - 1 downto NO_OF_INPUT_BITS - CNT * 8 - 8) <= RXD_DATA;
				if CNT = (NO_OF_INPUT_BITS / NO_OF_TRANSFERRED_BITS - 1) then
					CNT := 0;
					DONE <= '1';
				else
					CNT := CNT + 1;
				end if;
			else
				DONE <= '0';
			end if;
		end if;
	end process;

end MERGER_BODY;

