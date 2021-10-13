library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.CONST.ALL;

entity INVERSION is
	port (
		CLK, RST, START : in std_logic;
		A : in std_logic_vector((WIDTH - 1) downto 0);
		Y : out std_logic_vector((WIDTH - 1) downto 0);
		DONE : out std_logic
	);
end INVERSION;

architecture INVERSION_BODY of INVERSION is
	
	component BIT_SEL is
		port (
			A : in std_logic_vector((CNT_WIDTH - 1) downto 0);
			K : in std_logic_vector((MSB_WIDTH - 1) downto 0);
			uI : out std_logic
		);
	end component;	
	
	component COUNTER is
		port (
			CLK, RST, CE : in std_logic;
			LOAD : in std_logic := '0';
			DATA : in std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '1');
			ZERO, ONE : out std_logic
		);
	end component;
	
	component LOOP_SQUARER is
		port (
			CLK, RST, START : in std_logic;
			A : in std_logic_vector((WIDTH - 1) downto 0);
			K : in std_logic_vector((CNT_WIDTH - 1) downto 0);
			Y : out std_logic_vector((WIDTH - 1) downto 0);
			DONE : out std_logic
		);
	end component;
	
	component INCREMENT is
		port (
			A : in std_logic_vector((CNT_WIDTH - 1) downto 0);
			Y : out std_logic_vector((CNT_WIDTH - 1) downto 0)
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

	component MULTIPLIER is
		port (
			CLK, RST, START : in std_logic;
			A, B : in std_logic_vector((WIDTH - 1) downto 0);
			Y : out std_logic_vector((WIDTH - 1) downto 0);
			DONE : out std_logic
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
	
	component SQUARER is
		port (
			A : in std_logic_vector((WIDTH - 1) downto 0);
			Y : out std_logic_vector((WIDTH - 1) downto 0)
		);
	end component;

	component SHIFTER is
		generic (
			SIZE : INTEGER
		);
		port (
			AO : in std_logic;
			A : in std_logic_vector((SIZE - 1) downto 0);
			Y : out std_logic_vector((SIZE - 1) downto 0);
			YO : out std_logic
		);
	end component;
	
	constant C_ZERO : std_logic_vector((CNT_WIDTH - 1) downto 0) := (others => '0');
	constant C_ONE : std_logic_vector((CNT_WIDTH - 1) downto 0) := (0 => '1', others => '0');
	
	type T_STATE is (INIT, LOAD_B, SQ_B, WAIT_SQ_B, MULT_BC, DELAY, MULT_AC, INC_R, FINISHED);
	signal STATE, NEXT_STATE : T_STATE;
	
	signal SQ_START, SQ_DONE, AC_START, AC_DONE, BC_START, BC_DONE, WE_B, WE_C, WE_K, CE_R, R_ZERO, uI, RST_R : std_logic;
	signal C_IN, C_OUT, B_OUT, B_SQ, BC_MULT, BC_SQ, AC_MULT, C_NEW : std_logic_vector((WIDTH - 1) downto 0);
	signal K_IN, K_OUT, K_SHIFT, K_ONE, K_NEW : std_logic_vector((CNT_WIDTH - 1) downto 0);
	signal CNT_R : std_logic_vector((MSB_WIDTH - 1) downto 0);
	
begin

	b : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_B, A => C_OUT, Y => B_OUT);
	c : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_C, A => C_IN, Y => C_OUT);
	k : REG generic map (REG_SIZE => CNT_WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_K, A => K_IN, Y => K_OUT);
			  
	c_mpx : MULTIPLEX generic map (SIZE => WIDTH)
							port map (A => A, B => C_NEW, SEL => START, Y => C_IN);
	ac_bc_mpx : MULTIPLEX generic map (SIZE => WIDTH)
								 port map (A => AC_MULT, B => BC_MULT, SEL => uI, Y => C_NEW);
	k_mpx : MULTIPLEX generic map (SIZE => CNT_WIDTH)
							port map (A => C_ONE, B => K_NEW, SEL => START, Y => K_IN);
	k_one_mpx : MULTIPLEX generic map (SIZE => CNT_WIDTH)
								 port map (A => K_ONE, B => K_SHIFT, SEL => uI, Y => K_NEW);
	
	sq_bc : SQUARER port map (A => BC_MULT, Y => BC_SQ);
	sq_c : SQUARER port map (A => C_NEW, Y => Y);
	
	loop_sq : LOOP_SQUARER port map (CLK => CLK, RST => RST, START => SQ_START, A => B_OUT, K => K_OUT, Y => B_SQ, DONE => SQ_DONE);

	axc : MULTIPLIER port map (CLK => CLK, RST => RST, START => AC_START, A => BC_SQ, B => A, Y => AC_MULT, DONE => AC_DONE);
	bxc : MULTIPLIER port map (CLK => CLK, RST => RST, START => BC_START, A => C_OUT, B => B_SQ, Y => BC_MULT, DONE => BC_DONE);
	
	lshift : SHIFTER generic map (SIZE => CNT_WIDTH)
						  port map (AO => '0', A => K_OUT, Y => K_SHIFT, YO => open);
	
	inc : INCREMENT port map (A => K_SHIFT, Y => K_ONE);
	
	bit_s : BIT_SEL port map (A => std_logic_vector(to_unsigned(WIDTH - 1, CNT_WIDTH)), K => CNT_R, uI => uI);
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= INIT;
			else
				STATE <= NEXT_STATE;
			end if;
			if RST_R = '1' then
				CNT_R <= std_logic_vector(to_unsigned(MSB_WIDTH, MSB_WIDTH));
			elsif CE_R = '1' then
				CNT_R <= CNT_R - 1;
			end if;
			if CNT_R = C_ZERO then
				R_ZERO <= '1';
			else
				R_ZERO <= '0';
			end if;
		end if;
	end process;
	
	process (STATE, RST, START, SQ_DONE, AC_DONE, BC_DONE, uI, R_ZERO)
	begin
		NEXT_STATE <= STATE;
		case STATE is
			when INIT =>
				if START = '1' then
					NEXT_STATE <= LOAD_B;
				end if;
			when LOAD_B =>
				NEXT_STATE <= SQ_B;
			when SQ_B =>
				NEXT_STATE <= WAIT_SQ_B;
			when WAIT_SQ_B =>
				if SQ_DONE = '1' then
					NEXT_STATE <= MULT_BC;
				end if;
			when MULT_BC =>
				if BC_DONE = '1' then
					if uI = '1' then
						NEXT_STATE <= DELAY;
					else
						NEXT_STATE <= INC_R;
					end if;
				end if;
			when DELAY =>
				NEXT_STATE <= MULT_AC;
			when MULT_AC =>
				if AC_DONE = '1' then
					NEXT_STATE <= INC_R;
				end if;
			when INC_R =>
				if R_ZERO = '1' then
					NEXT_STATE <= FINISHED;
				else
					NEXT_STATE <= LOAD_B;
				end if;
			when FINISHED =>
				NEXT_STATE <= INIT;
		end case;
	end process;
	
	process (STATE, RST, START, SQ_DONE, AC_DONE, BC_DONE, uI, R_ZERO)
	begin
		WE_B <= '0';
		WE_C <= '0';
		WE_K <= '0';
		CE_R <= '0';
		SQ_START <= '0';
		AC_START <= '0';
		BC_START <= '0';
		DONE <= '0';
		RST_R <= '0';
		
		case STATE is
			when INIT =>
				if START = '1' then
					WE_C <= '1';
					WE_K <= '1';
					RST_R <= '1';
				end if;
			when LOAD_B =>
				WE_B <= '1';
			when SQ_B =>
				SQ_START <= '1';
			when WAIT_SQ_B =>
				if SQ_DONE = '1' then
					BC_START <= '1';
					CE_R <= '1';
				end if;
			when MULT_BC =>
			when DELAY =>
				AC_START <= '1';
			when MULT_AC =>
			when INC_R =>
				if R_ZERO = '0' then
					WE_K <= '1';
					WE_C <= '1';
				end if;
			when FINISHED =>
				DONE <= '1';
		end case;
	end process;
	
end INVERSION_BODY;