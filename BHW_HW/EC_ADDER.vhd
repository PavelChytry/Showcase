library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

entity EC_ADDER is
	port (
		CLK, RST, START : in std_logic;
		infP, infQ : in std_logic;
		ap, x0, y0, x1, y1 : in std_logic_vector((WIDTH - 1) downto 0);
		x2, y2 : out std_logic_vector((WIDTH - 1) downto 0);
		infR : out std_logic;
		DONE : out std_logic
	);
end EC_ADDER;

architecture Behavioral of EC_ADDER is
	
	component ADDER is
		port (
			A, B : in std_logic_vector((WIDTH - 1) downto 0);
			Y : out std_logic_vector((WIDTH - 1) downto 0)
		);
	end component;
	
	component COMPARATOR is
		port (
			A, B : in std_logic_vector((WIDTH - 1) downto 0);
			EQ : out std_logic
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
	
	component INVERSION is
		port (
			CLK, RST, START : in std_logic;
			A : in std_logic_vector((WIDTH - 1) downto 0);
			Y : out std_logic_vector((WIDTH - 1) downto 0);
			DONE : out std_logic
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

	component MULTIPLEX4 is
		generic (
			SIZE : INTEGER
		);
		port (
			A, B, C, D : in std_logic_vector((SIZE - 1) downto 0);
			SEL0, SEL1 : in std_logic;
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
	
	constant ZEROS : std_logic_vector((WIDTH - 1) downto 0) := (others => '0');
	constant DATA_CNT : std_logic_vector((CNT_WIDTH - 1) downto 0) := std_logic_vector(to_unsigned(5, CNT_WIDTH));
	-- add, square, add, add, add delay
	
	signal a, xP, yP, xQ, yQ, xR, yR, x2_IN, y2_IN, AxPQ, LxQR, xPQ, xQR, xQ_SEL, INV_IN, INV_OUT, MULT_IN, MULT_OUT,  
		xPQ_SEL, yPQ, xRyQ, lambda, lambda_SQ, lambda_SUM: std_logic_vector((WIDTH - 1) downto 0);
		
	signal EQ, WE_X, WE_Y, CE_CNT, LOAD_CNT, ZERO_CNT, EQ_X, EQ_Y, EQ_X_ZERO, WE_P, WE_Q, WE_INFR, infR_REG,
		INV_START, INV_DONE, MULT_START, MULT_DONE, MULT_LxQR_START, MULT_LxQR_DONE : std_logic;
	
	type T_STATE is (INIT, CHECK, INF_P, INF_Q, INF_PQ, INF_R, DELAY_X, INVERT, MULT, DELAY_CNT, MULT_LQR, DELAY_Y, FINISHED);
	signal STATE, NEXT_STATE : T_STATE;
	
begin
	cmp_x : COMPARATOR port map (A => xP, B => xQ, EQ => EQ_X);
	cmp_y : COMPARATOR port map (A => yP, B => yQ, EQ => EQ_Y);
	cmp_x_zero : COMPARATOR port map (A => ZEROS, B => xQ, EQ => EQ_X_ZERO);
	EQ <= EQ_X and EQ_Y;

	sum_xpq : ADDER port map (A => xP, B => xQ, Y => xPQ);
	sum_ypq : ADDER port map (A => yP, B => yQ, Y => yPQ);
	sum_axp : ADDER port map (A => a, B => xPQ_SEL, Y => AxPQ);
	sum_mult : ADDER port map (A => MULT_OUT, B => xQ_SEL, Y => lambda);
	sum_lambda : ADDER port map (A => lambda, B => lambda_SQ, Y => lambda_SUM);
	sum_x_2 : ADDER port map (A => AxPQ, B => lambda_SUM, Y => xR);
	sum_xqr : ADDER port map (A => xQ, B => xR, Y => xQR);
	sum_xryq : ADDER port map (A => yQ, B => xR, Y => xRyQ);
	sum_y_2 : ADDER port map (A => xRyQ, B => LxQR, Y => yR);
	
	xpq_mpx : MULTIPLEX generic map (SIZE => WIDTH)
							  port map (A => ZEROS, B => xPQ, SEL => EQ, Y => xPQ_SEL);
	inv_mpx : MULTIPLEX generic map (SIZE => WIDTH)
							  port map (A => xQ, B => xPQ, SEL => EQ, Y => INV_IN);
	mult_mpx : MULTIPLEX generic map (SIZE => WIDTH)
							  port map (A => yQ, B => yPQ, SEL => EQ, Y => MULT_IN);
	add_mpx : MULTIPLEX generic map (SIZE => WIDTH)
							  port map (A => xQ, B => ZEROS, SEL => EQ, Y => xQ_SEL);
							  
	x_mpx4 : MULTIPLEX4 generic map (SIZE => WIDTH)
							  port map (A => xR, B => xP, C => xQ, D => ZEROS, SEL1 => infP, SEL0 => infQ, Y => x2_IN);
	y_mpx4 : MULTIPLEX4 generic map (SIZE => WIDTH)
							  port map (A => yR, B => yP, C => yQ, D => ZEROS, SEL1 => infP, SEL0 => infQ, Y => y2_IN);
	
	invertor : INVERSION port map (CLK => CLK, RST => RST, START => INV_START, A => INV_IN, Y => INV_OUT, DONE => INV_DONE);
	
	mult_inv : MULTIPLIER port map (CLK => CLK, RST => RST, START => MULT_START, A => INV_OUT, B => MULT_IN, Y => MULT_OUT, DONE => MULT_DONE);
	mult_lxqr : MULTIPLIER port map (CLK => CLK, RST => RST, START => MULT_LxQR_START, A => lambda, B => xQR, Y => LxQR, DONE => MULT_LxQR_DONE);
	
	sq_lambda : SQUARER port map (A => lambda, Y => lambda_SQ);
	
	reg_a : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => START, A => ap, Y => a);
	reg_x0 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => START, A => x0, Y => xP);
	reg_y0 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => START, A => y0, Y => yP);
	reg_x1 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => START, A => x1, Y => xQ);
	reg_y1 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => START, A => y1, Y => yQ);
	reg_x2 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => START, WE => WE_X, A => x2_IN, Y => x2);
	reg_y2 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => START, WE => WE_Y, A => y2_IN, Y => y2);
	reg_infr : REG generic map (REG_SIZE => 1)
			  port map (CLK => CLK, RST => RST, WE => WE_INFR, A(0) => infR_REG, Y(0) => infR);
	
	cnt : COUNTER port map (CLK => CLK, RST => RST, CE => CE_CNT, LOAD => LOAD_CNT, DATA => DATA_CNT, ZERO => ZERO_CNT, ONE => open);
	
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
	
	process (STATE, RST, START, INV_DONE, MULT_DONE, MULT_LxQR_DONE, ZERO_CNT, INFP, INFQ, EQ_X, EQ_Y, EQ_X_ZERO)
	begin
		NEXT_STATE <= STATE;
		case STATE is
			when INIT =>
				if START = '1' then
					NEXT_STATE <= CHECK;
				end if;
			when CHECK =>
				if infP = '1' then
					if infQ = '1' then 
						NEXT_STATE <= INF_PQ;
					else
						NEXT_STATE <= INF_P;
					end if;
				elsif infQ = '1' then
					NEXT_STATE <= INF_Q;
				else
					if (EQ_X = '1' and EQ_X_ZERO = '1') then
						NEXT_STATE <= INF_R;
					elsif (EQ_X = '1' and EQ_Y = '0') then
						NEXT_STATE <= INF_R;
					else
						NEXT_STATE <= DELAY_X;
					end if;
				end if;
			when INF_P =>
				NEXT_STATE <= FINISHED;
			when INF_Q =>
				NEXT_STATE <= FINISHED;
			when INF_PQ =>
				NEXT_STATE <= FINISHED;
			when INF_R =>
				NEXT_STATE <= FINISHED;
			when DELAY_X =>
				NEXT_STATE <= INVERT;
			when INVERT =>
				if INV_DONE = '1' then
					NEXT_STATE <= MULT;
				end if;
			when MULT =>
				if MULT_DONE = '1' then
					NEXT_STATE <= DELAY_CNT;
				end if;
			when DELAY_CNT =>
				if ZERO_CNT = '1' then
					NEXT_STATE <= MULT_LQR;
				end if;
			when MULT_LQR =>
				if MULT_LxQR_DONE = '1' then
					NEXT_STATE <= DELAY_Y;
				end if;
			when DELAY_Y =>
				NEXT_STATE <= FINISHED;
			when FINISHED =>
				NEXT_STATE <= INIT;
		end case;
	end process;
	
	process (STATE, RST, START, INV_DONE, MULT_DONE, ZERO_CNT)
	begin
		DONE <= '0';
		WE_X <= '0';
		WE_Y <= '0';
		INV_START <= '0';
		MULT_START <= '0';
		MULT_LxQR_START <= '0';
		CE_CNT <= '0';
		LOAD_CNT <= '0';
		infR_REG <= '0';
		WE_INFR <= '0';
		
		case STATE is
			when INIT =>
			when CHECK =>
			when INF_P =>
				WE_X <= '1';
				WE_Y <= '1';
			when INF_Q =>
				WE_X <= '1';
				WE_Y <= '1';
			when INF_PQ =>
				infR_REG <= '1';
				WE_INFR <= '1';
			when INF_R =>
				infR_REG <= '1';
				WE_INFR <= '1';
			when DELAY_X =>
				INV_START <= '1';
			when INVERT =>
				if INV_DONE = '1' then
					MULT_START <= '1';
				end if;
			when MULT =>
				if MULT_DONE = '1' then
					LOAD_CNT <= '1';
				end if;
			when DELAY_CNT =>
				if ZERO_CNT = '1' then
					MULT_LxQR_START <= '1';
				end if;
				CE_CNT <= '1';
			when MULT_LQR =>
			when DELAY_Y =>
				infR_REG <= '0';
				WE_INFR <= '1';
				WE_X <= '1';
				WE_Y <= '1';
			when FINISHED =>
				DONE <= '1';
		end case;
	end process;
	
end Behavioral;

