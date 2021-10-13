library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.const.all;

-- only works with K = 1
-- left side index = 0
-- right side index = 1
entity MATRIXMULT is
	port (
		CLK, RST, START : in std_logic;
		I : in INT_VECTOR;
		T : in TORUS_MATRIX;
		Y : out TORUS_POLYS;
		DONE : out std_logic
	);
end MATRIXMULT;

architecture MATRIXMULT_BODY of MATRIXMULT is

	component ACCUMULATOR is
	port (
		CLK, RST, PULSE : in std_logic;
		A : in TORUS_POLY;
		Y : out TORUS_POLY
	);
	end component;
	
	component EXTENDED_COUNTER is
	port (
		CLK : in std_logic;
		RST : in std_logic;
		CE : in std_logic;
		SET : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
    end component;
    
	component EXTCOUNTER is
	port (
		CLK, RST, CE : in std_logic;
		CNT_R : out UNSIGNED(CNT_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
	end component;
	
	component LATCH is
	port (
		CLK, RST, A : in std_logic;
		Y : out std_logic
	);
	end component;

	component MULT_CONTROLLER is
	port (
		CLK, RST, START, MULT_DONE, ZERO : in std_logic;
		DONE, MULT_START, PULSE_ADD, PULSE_CNT : out std_logic
	);
	end component;

	component POLYMULT is
	port (
		CLK, RST, START : in std_logic;
		I : in INT_POLY; -- integer poly
		T : in TORUS_POLY; -- torus poly
		Y : out TORUS_POLY; -- torus poly
		DONE : out std_logic
	);
	end component;

	signal T_IN_L, T_IN_R, T_OUT_L, T_OUT_R : TORUS_POLY;
	signal I_IN_L, I_IN_R : INT_POLY;
	
	--signal CNT_R, CNT_L : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
	signal CNT_R, CNT_L : UNSIGNED(CNT_WIDTH - 1 downto 0);
	
	signal MULT_START_L, MULT_START_R, DONE_L, DONE_R, MULT_DONE_L, MULT_DONE_R, ZERO_L, ZERO_R, LATCH_L, LATCH_R, PULSE_ADD_L, PULSE_ADD_R, PULSE_CNT_L, PULSE_CNT_R, CNT_RST : std_logic;
	
begin

	CNT_RST <= RST or START;

	I_IN_L <= I(to_integer(CNT_L));
	T_IN_L <= T(0)(to_integer(CNT_L));
	
	l_acc : ACCUMULATOR port map (CLK => CLK, RST => START, PULSE => PULSE_ADD_L, A => T_OUT_L, Y => Y(0));
	--l_cnt : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST, CE => PULSE_CNT_L, CNT_R => CNT_L, ZERO => ZERO_L, SET => to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH));
	l_cnt : EXTCOUNTER port map (CLK => CLK, RST => CNT_RST, CE => PULSE_CNT_L, CNT_R => CNT_L, ZERO => ZERO_L);
	l_ctrl : MULT_CONTROLLER port map (CLK => CLK, RST => RST, START => START, MULT_DONE => MULT_DONE_L,
			ZERO => ZERO_L, DONE => DONE_L, MULT_START => MULT_START_L, PULSE_ADD => PULSE_ADD_L, PULSE_CNT => PULSE_CNT_L);
	l_mult : POLYMULT port map (CLK => CLK, RST => RST, START => MULT_START_L, I => I_IN_L, T => T_IN_L, Y => T_OUT_L, DONE => MULT_DONE_L);
	
	I_IN_R <= I(to_integer(CNT_R));
	T_IN_R <= T(1)(to_integer(CNT_R));
	
	r_acc : ACCUMULATOR port map (CLK => CLK, RST => START, PULSE => PULSE_ADD_R, A => T_OUT_R, Y => Y(1));
	--r_cnt : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST, CE => PULSE_CNT_R, CNT_R => CNT_R, ZERO => ZERO_R, SET => to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH));
	r_cnt : EXTCOUNTER port map (CLK => CLK, RST => CNT_RST, CE => PULSE_CNT_R, CNT_R => CNT_R, ZERO => ZERO_R);
	r_ctrl : MULT_CONTROLLER port map (CLK => CLK, RST => RST, START => START, MULT_DONE => MULT_DONE_R,
			ZERO => ZERO_R, DONE => DONE_R, MULT_START => MULT_START_R, PULSE_ADD => PULSE_ADD_R, PULSE_CNT => PULSE_CNT_R);
	r_mult : POLYMULT port map (CLK => CLK, RST => RST, START => MULT_START_R, I => I_IN_R, T => T_IN_R, Y => T_OUT_R, DONE => MULT_DONE_R);
	
	l_latch : LATCH port map (CLK => CLK, RST => START, A => DONE_L, Y => LATCH_L);
	r_latch : LATCH port map (CLK => CLK, RST => START, A => DONE_R, Y => LATCH_R);
	
	DONE <= LATCH_L and LATCH_R;
	
end MATRIXMULT_BODY;

