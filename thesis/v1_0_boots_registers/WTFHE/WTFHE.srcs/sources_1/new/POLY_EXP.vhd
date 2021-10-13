library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity POLY_EXP is
    port (
        CLK, RST, DIR, START : in std_logic; -- DIR 0 := normal direction, 1 := reverse
        EXP : in UNSIGNED(NU downto 0);
        P_IN : in TORUS_POLYS;
        P_OUT : out TORUS_POLYS;
        DONE : out std_logic
    );
end POLY_EXP;

architecture POLY_EXP_BODY of POLY_EXP is

    component EXTCOUNTER2 is
	port (
		CLK, RST, CE : in std_logic;
		DATA : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
    end component;
    
    component NEGACYCLICMEM is
	port (
		CLK, RST, LOAD, PULSE : in std_logic; -- PULSE := rotate array
		DIR : in std_logic := '0';
		A : in TORUS_POLY;
		Y : out TORUS_POLY
	);
    end component;
    
    signal CNT_RST, CNT_ZERO, PULSE : std_logic;
    
    signal PAD : UNSIGNED(CNT_UART_WIDTH - 1 downto 0) := to_unsigned(0, CNT_UART_WIDTH);
    
    type T_STATE is (IDLE, DELAY, BUSY);
	signal STATE, NEXT_STATE : T_STATE;
	
begin

    gen_j:
    for i_i in 0 to K generate
        mem : NEGACYCLICMEM port map (CLK => CLK, RST => RST, LOAD => START, PULSE => PULSE, DIR => DIR, A => P_IN(i_i), Y => P_OUT(i_i));
    end generate;
	
	PAD(NU downto 0) <= EXP;
	cnt : EXTCOUNTER2 port map (CLK => CLK, RST => CNT_RST, CE => PULSE, DATA => PAD, CNT_R => open, ZERO => CNT_ZERO);
	
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
	
    process (STATE, RST, START, CNT_ZERO)
	begin
		NEXT_STATE <= STATE;
		PULSE <= '0';
		CNT_RST <= '0';
	    DONE <= '0';
	    
		case STATE is
			when IDLE =>
				if START = '1' then
				    CNT_RST <= '1';
					NEXT_STATE <= DELAY;
				end if;
		    when DELAY => 
				NEXT_STATE <= BUSY;
			when BUSY =>
			    if CNT_ZERO = '1' then
			        DONE <= '1';
				    NEXT_STATE <= IDLE;
				else
		            PULSE <= '1';
					NEXT_STATE <= DELAY;
				end if;
		end case;
	end process;
	
end POLY_EXP_BODY;
