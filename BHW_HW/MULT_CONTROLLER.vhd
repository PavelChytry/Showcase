library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity MULT_CONTROLLER is
	port (
		CLK, RST, START : in std_logic;
		DONE, RST_C, WE_B, WE_C, CE_B, CE_C : out std_logic
	);
end MULT_CONTROLLER;

architecture MULT_CONTROLLER_BODY of MULT_CONTROLLER is

	component COUNTER is
		port (
			CLK, RST, CE : in std_logic;
			LOAD : in std_logic := '0';
			DATA : in std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '1');
			ZERO, ONE : out std_logic
		);
	end component;

	type T_STATE is (INIT, MULT);
	signal STATE, NEXT_STATE : T_STATE;
	signal CE_CNT, RST_CNT, CNT_ZERO : std_logic;
	
begin

	cnt : COUNTER port map (CLK => CLK, RST => RST_CNT, CE => CE_CNT, ZERO => CNT_ZERO, ONE => open);
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= INIT;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	process (STATE, RST, START, CNT_ZERO)
	begin
		NEXT_STATE <= STATE;
		case STATE is
			when INIT =>
				if START = '1' then
					NEXT_STATE <= MULT;
				end if;
			when MULT =>
				if CNT_ZERO = '1' then
					NEXT_STATE <= INIT;
				end if;
		end case;
	end process;
	
	process (STATE, RST, START, CNT_ZERO)
	begin
		DONE <= '0';
		RST_C <= RST;
		RST_CNT <= RST;
		WE_B <= '0';
		WE_C <= '0';
		CE_B <= '0';
		CE_C <= '0';
		CE_CNT <= '0';
		
		case STATE is
			when INIT =>
				if START = '1' then
					RST_C <= '1';
					RST_CNT <= '1';
					WE_B <= '1';
				end if;
			when MULT =>
				if CNT_ZERO = '1' then
					DONE <= '1';
				else
					CE_B <= '1';
					CE_C <= '1';
					WE_C <= '1';
					CE_CNT <= '1';
				end if;
		end case;
	end process;

end MULT_CONTROLLER_BODY;

