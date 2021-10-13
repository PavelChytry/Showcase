library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

entity EXTCOUNTER2 is
	port (
		CLK, RST, CE : in std_logic;
		DATA : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
end EXTCOUNTER2;

architecture EXTCOUNTER_BODY of EXTCOUNTER2 is

	signal CNT : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
	
	constant C_ZERO : UNSIGNED(CNT_UART_WIDTH - 1 downto 0) := to_unsigned(0, CNT_UART_WIDTH);
	
begin

	CNT_R <= CNT;
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				CNT <= DATA;
			elsif CE = '1' then
				CNT <= CNT - 1;
			end if;
			if CNT = C_ZERO then
				ZERO <= '1';
			else
				ZERO <= '0';
			end if;
		end if;
	end process;

end EXTCOUNTER_BODY;
