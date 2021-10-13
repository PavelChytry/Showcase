library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.const.all;

-- controller for MATRIX_MULT entity
entity MULT_CONTROLLER is
	port (
		CLK, RST, START, MULT_DONE : in std_logic;
		ZERO : in std_logic; -- counter is zero
		DONE : out std_logic;
		MULT_START : out std_logic; -- begin multiplication
		PULSE_ADD : out std_logic; -- sum output
		PULSE_CNT : out std_logic -- pulse counter
	);
end MULT_CONTROLLER;

architecture MULT_CONTROLLER_BODY of MULT_CONTROLLER is

	type T_STATE is (IDLE, INIT, MULT_BEGIN, MULT_WAIT);
	signal STATE, NEXT_STATE : T_STATE;
	
begin

    -- controller
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= IDLE;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	process (STATE, RST, START, MULT_DONE, ZERO)
	begin
		NEXT_STATE <= STATE;
		DONE <= '0';
		MULT_START <= '0';
		PULSE_ADD <= '0';
		PULSE_CNT <= '0';
	
		case STATE is
			when IDLE => -- wait for start
				if START = '1' then
					NEXT_STATE <= INIT;
				end if;
			when INIT => -- begin the multiplication
				NEXT_STATE <= MULT_WAIT;
				MULT_START <= '1';
			when MULT_BEGIN => -- begin the multiplication
				if ZERO = '1' then -- we multiplied all polynomials, return to idle
					DONE <= '1';
					NEXT_STATE <= IDLE;
				else
					NEXT_STATE <= MULT_WAIT;
					MULT_START <= '1';
				end if;
			when MULT_WAIT => -- not everything multiplied yet, add the output to the accumulator and run multiplication on next polynomial
				if MULT_DONE = '1' then
					NEXT_STATE <= MULT_BEGIN;
					PULSE_ADD <= '1';
					if ZERO = '0' then
						PULSE_CNT <= '1';
					end if;
				end if;
		end case;
	end process;
	
end MULT_CONTROLLER_BODY;

