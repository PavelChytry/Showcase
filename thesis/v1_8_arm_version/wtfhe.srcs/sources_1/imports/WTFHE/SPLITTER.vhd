library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

-- splits 32 bit chunks into 8 bit chunks for UART
entity SPLITTER is
	port (
		CLK, RST, SEND, TXD_READY : in std_logic;
		DATA_IN : in std_logic_vector(NO_OF_OUTPUT_BITS - 1 downto 0);
		TXD_DATA : out std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		TXD_STROBE, DONE : out std_logic
	);
end SPLITTER;

architecture SPLITTER_BODY of SPLITTER is

	signal ACTIVE, EDGE : std_logic;
	signal REG : std_logic_vector(NO_OF_OUTPUT_BITS - 1 downto 0);
	
begin

	process (CLK)
		variable CNT : integer range 0 to NO_OF_OUTPUT_BITS / NO_OF_TRANSFERRED_BITS + 1;
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				TXD_DATA <= (others => '0');
				TXD_STROBE <= '0';
				ACTIVE <= '0';
				EDGE <= '0';
				DONE <= '0';
			elsif SEND = '1' then
				CNT := 0;
				ACTIVE <= '1';
				REG <= DATA_IN;
				DONE <= '0';
			elsif ACTIVE = '1' then
				if TXD_READY = '1' then
					EDGE <= not EDGE;
					if EDGE = '1' then
						if CNT = (NO_OF_OUTPUT_BITS / NO_OF_TRANSFERRED_BITS) then
							CNT := 0;
							ACTIVE <= '0';
							DONE <= '1';
						else
							TXD_DATA <= REG(NO_OF_OUTPUT_BITS - CNT * 8 - 1 downto NO_OF_OUTPUT_BITS - CNT * 8 - 8);
							CNT := CNT + 1;
							TXD_STROBE <= '1';
						end if;
					end if;
				else
					TXD_STROBE <= '0';
				end if;
			else
				DONE <= '0';
			end if;
		end if;
	end process;


end SPLITTER_BODY;

