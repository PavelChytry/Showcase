library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity LOOP_SQUARER is
	port (
		CLK, RST, START : in std_logic;
		A : in std_logic_vector((WIDTH - 1) downto 0);
		K : in std_logic_vector((CNT_WIDTH - 1) downto 0);
		Y : out std_logic_vector((WIDTH - 1) downto 0);
		DONE : out std_logic
	);
end LOOP_SQUARER;

architecture LOOP_SQUARER_BODY of LOOP_SQUARER is

	component COUNTER is
		port (
			CLK, RST, CE : in std_logic;
			LOAD : in std_logic := '0';
			DATA : in std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '1');
			ZERO, ONE : out std_logic
		);
	end component;
	
	component SQUARER is
		port (
			A : in std_logic_vector((WIDTH - 1) downto 0);
			Y : out std_logic_vector((WIDTH - 1) downto 0)
		);
	end component;
	
	component REG is
		generic (
			REG_SIZE : INTEGER
		);
		port (
			CLK, WE, RST : in std_logic;
			A : in std_logic_vector((REG_SIZE - 1) downto 0);
			Y : out std_logic_vector((REG_SIZE - 1) downto 0)
		);
	end component;
	
	component MULTIPLEX is
		generic (
			SIZE : INTEGER
		);
		port (
			A, B : in std_logic_vector((SIZE - 1) downto 0);
			SEL : in std_logic;
			Y : out std_logic_vector((SIZE - 1) downto 0)
		);
	end component;

	type T_STATE is (INIT, RUN);
	signal STATE, NEXT_STATE : T_STATE;
	signal REG_IN, REG_OUT, SQ_OUT : std_logic_vector((WIDTH - 1) downto 0);
	signal CE_CNT, WE_R, CNT_ZERO, CNT_ONE : std_logic;
begin

	r : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_R, A => REG_IN, Y => REG_OUT);
	multiplexer : MULTIPLEX generic map (SIZE => WIDTH)
									port map (A => A, B => SQ_OUT, SEL => START, Y => REG_IN);
	cnt : COUNTER port map (CLK => CLK, RST => RST, CE => CE_CNT, LOAD => START, DATA => K, ZERO => CNT_ZERO, ONE => CNT_ONE);
	sqr : SQUARER port map (A => REG_OUT, Y => SQ_OUT);
	
	Y <= REG_OUT;
	
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
					NEXT_STATE <= RUN;
				end if;
			when RUN =>
				if CNT_ZERO = '1' then
					NEXT_STATE <= INIT;
				end if;
		end case;
	end process;
	
	process (STATE, RST, START, CNT_ZERO, CNT_ONE)
	begin
		WE_R <= '0';		
		DONE <= '0';
		CE_CNT <= '0';
		
		case STATE is
			when INIT =>
				if START = '1' then
					WE_R <= '1';
				end if;
			when RUN =>
				if CNT_ZERO = '0' then
					if CNT_ONE = '0' then
						WE_R <= '1';
					end if;
					CE_CNT <= '1';
				else
					DONE <= '1';
				end if;
		end case;
	end process;

end LOOP_SQUARER_BODY;

