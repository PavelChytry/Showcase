library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity BOOTSTRAPPING is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        START : in std_logic;
        P_IN : in TORUS_POLYS;
        TLWE_IN : in TLWE;
        BK : in BOOTSTRAPPING_KEYS;
        TLWE_OUT : out TLWE_N;
        DONE : out std_logic
    );
end entity BOOTSTRAPPING;

architecture BOOTSTRAPPING_BODY of BOOTSTRAPPING is

    component EXTERNAL_PRODUCT is
    port (
        CLK, RST, START : in std_logic;
        T_MATRIX : in TORUS_MATRIX;
        T_POLY_IN : in TORUS_POLYS;
        T_POLY_OUT : out TORUS_POLYS;
        DONE : out std_logic
    );
    end component;
    
    component EXTCOUNTER2 is
	port (
		CLK, RST, CE : in std_logic;
		DATA : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
    end component;

    component LATCH is
	port (
		CLK, RST, A : in std_logic;
		Y : out std_logic
	);
    end component;

    component TLWE_ROUNDING is
    port (
        T_IN : in TLWE;
        T_OUT : out TLWE_ROUND
    );
    end component;

    component MAT_ADD is
    port (
        CLK : in std_logic;
        A, B : in TORUS_MATRIX;
        Y : out TORUS_MATRIX
    );
    end component;

    component MAT_EXP is
    port (
        CLK, RST, DIR, START : in std_logic; -- DIR 0 := normal direction, 1 := reverse
        EXP : in UNSIGNED(NU + 1 downto 0);
        MAT_IN : in TORUS_MATRIX;
        MAT_OUT : out TORUS_MATRIX;
        DONE : out std_logic
    );
    end component;

    component MAT_SUB is
    port (
        CLK : in std_logic;
        A, B : in TORUS_MATRIX;
        Y : out TORUS_MATRIX
    );
    end component;

    component POLY_ADD is
     port (
		CLK : in std_logic;
		A, B : in TORUS_POLYS;
		Y : out TORUS_POLYS
	);
    end component;

    component POLY_EXP is
    port (
        CLK, RST, DIR, START : in std_logic; -- DIR 0 := normal direction, 1 := reverse
        EXP : in UNSIGNED(NU downto 0);
        P_IN : in TORUS_POLYS;
        P_OUT : out TORUS_POLYS;
        DONE : out std_logic
    );
    end component;

    component POLY_MPX is
    port (
		A, B : in TORUS_POLYS;
		SEL : in std_logic;
		Y : out TORUS_POLYS
	);
    end component;

    component POLY_REG is
    port (
		CLK, WE, RST : in std_logic;
		A : in TORUS_POLYS;
		Y : out TORUS_POLYS
	);
    end component;

    signal P_EXP, P_REG_IN, P_REG_OUT, P_EX_PROD_OUT, P_ADD_OUT : TORUS_POLYS;
    
    signal M_EXP_0, M_EXP_1, M_EXP_2, M_SUB_0, M_SUB_1, M_SUB_2, M_ADD_0, M_ADD_1, M_EXP_0_IN, M_EXP_1_IN, M_EXP_2_IN : TORUS_MATRIX;
    
    signal TLWE_R : TLWE_ROUND;
    
    signal CNT_R, CNT_DATA : UNSIGNED(CNT_UART_WIDTH - 1 downto 0) := to_unsigned(0, CNT_UART_WIDTH);
    
    signal EXP_0, EXP_1, EXP_2 : UNSIGNED(NU + 1 downto 0) := to_unsigned(0, NU + 2);
    signal P_EXP_START, P_EXP_DONE, P_LOAD, P_WE, EX_PROD_START, EX_PROD_DONE, M_EXP_START, M_EXP_DONE,
     M_EXP_DONE_0, M_EXP_DONE_1, M_EXP_DONE_2, CNT_LOAD, CNT_CE, CNT_ZERO, LATCH_0, LATCH_1, LATCH_2 : std_logic;
    
    signal IDX_0, IDX_1, IDX_2 : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
    
    type T_STATE is (IDLE, ROUND, SETUP, S_MAT_EXP, S_MAT_SUB, S_MAT_ADD_0, S_MAT_ADD_1, S_EXT_PROD, FINAL, DELAY, DELAY_DONE);
	signal STATE, NEXT_STATE : T_STATE;
	
begin

    TLWE_OUT(0) <= P_REG_OUT(0)(0);
    TLWE_OUT(N) <= P_REG_OUT(1)(0);
    gen_out:
    for i_i in 1 to N - 1 generate
        TLWE_OUT(i_i) <= not(P_REG_OUT(0)(N - i_i)) + 1;
    end generate;
    
    cnt : EXTCOUNTER2 port map (CLK => CLK, RST => CNT_LOAD, CE => CNT_CE, DATA => CNT_DATA, CNT_R => CNT_R, ZERO => CNT_ZERO);

    rounding : TLWE_ROUNDING port map (T_IN => TLWE_IN, T_OUT => TLWE_R);
    
    poly_exp_b : POLY_EXP port map (CLK => CLK, RST => RST, DIR => '1', START => P_EXP_START, EXP => TLWE_R(DIM), P_IN => P_IN, P_OUT => P_EXP, DONE => P_EXP_DONE);
    p_mpx : POLY_MPX port map (A => P_EXP, B => P_ADD_OUT, SEL => P_LOAD, Y => P_REG_IN);
    p_reg : POLY_REG port map (CLK => CLK, RST => RST, WE => P_WE, A => P_REG_IN, Y => P_REG_OUT);
    p_add : POLY_ADD port map (CLK => CLK, A => P_REG_OUT, B => P_EX_PROD_OUT, Y => P_ADD_OUT);

    ex_prod : EXTERNAL_PRODUCT port map (CLK => CLK, RST => RST, START => EX_PROD_START, T_MATRIX => M_ADD_1, T_POLY_IN => P_REG_OUT, T_POLY_OUT => P_EX_PROD_OUT, DONE => EX_PROD_DONE);

    IDX_2 <= resize((to_unsigned(DIM, CNT_UART_WIDTH) / 2 - CNT_R) * 3 - 3, CNT_UART_WIDTH);
    M_EXP_2_IN <= BK(to_integer(IDX_2));
    EXP_2 <= EXP_1 + EXP_0;
    mat_exp_2 : MAT_EXP port map (CLK => CLK, RST => RST, DIR => '0', START => M_EXP_START, EXP => EXP_2, MAT_IN => M_EXP_2_IN, MAT_OUT => M_EXP_2, DONE => M_EXP_DONE_2);

    IDX_1 <= resize((to_unsigned(DIM, CNT_UART_WIDTH) / 2 - CNT_R) * 3 - 2, CNT_UART_WIDTH);
    M_EXP_1_IN <= BK(to_integer(IDX_1));
    EXP_1 <= '0' & TLWE_R(to_integer((to_unsigned(DIM, CNT_UART_WIDTH) / 2 - CNT_R) * 2 - 2));
    mat_exp_1 : MAT_EXP port map (CLK => CLK, RST => RST, DIR => '0', START => M_EXP_START, EXP => EXP_1, MAT_IN => M_EXP_1_IN, MAT_OUT => M_EXP_1, DONE => M_EXP_DONE_1);
    
    IDX_0 <= resize((to_unsigned(DIM, CNT_UART_WIDTH) / 2 - CNT_R) * 3 - 1, CNT_UART_WIDTH);
    M_EXP_0_IN <= BK(to_integer(IDX_0));
    EXP_0 <= '0' & TLWE_R(to_integer((to_unsigned(DIM, CNT_UART_WIDTH) / 2 - CNT_R) * 2 - 1));
    mat_exp_0 : MAT_EXP port map (CLK => CLK, RST => RST, DIR => '0', START => M_EXP_START, EXP => EXP_0, MAT_IN => M_EXP_0_IN, MAT_OUT => M_EXP_0, DONE => M_EXP_DONE_0);
    
    l_2 : LATCH port map (CLK => CLK, RST => M_EXP_START, A => M_EXP_DONE_2, Y => LATCH_2);
	l_1 : LATCH port map (CLK => CLK, RST => M_EXP_START, A => M_EXP_DONE_1, Y => LATCH_1);
	l_0 : LATCH port map (CLK => CLK, RST => M_EXP_START, A => M_EXP_DONE_0, Y => LATCH_0);
	
	M_EXP_DONE <= LATCH_0 and LATCH_1 and LATCH_2;
	
    mat_sub_2 : MAT_SUB port map (CLK => CLK, A => M_EXP_2, B => M_EXP_2_IN, Y => M_SUB_2);
    mat_sub_1 : MAT_SUB port map (CLK => CLK, A => M_EXP_1, B => M_EXP_1_IN, Y => M_SUB_1);
    mat_sub_0 : MAT_SUB port map (CLK => CLK, A => M_EXP_0, B => M_EXP_0_IN, Y => M_SUB_0);
    
    mat_add_0 : MAT_ADD port map (CLK => CLK, A => M_SUB_0, B => M_SUB_1, Y => M_ADD_0);
    mat_add_1 : MAT_ADD port map (CLK => CLK, A => M_SUB_2, B => M_ADD_0, Y => M_ADD_1);
    
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
	
	process (STATE, RST, START, P_EXP_DONE, M_EXP_DONE, EX_PROD_DONE, CNT_ZERO) -- TODO
	begin
		NEXT_STATE <= STATE;
		CNT_CE <= '0';
		CNT_LOAD <= '0';
	    DONE <= '0';
	    EX_PROD_START <= '0';
	    M_EXP_START <= '0';
	    P_LOAD <= '0';
	    P_EXP_START <= '0';
	    P_WE <= '0';
	    CNT_DATA <= (others => '0');
	    
		case STATE is
			when IDLE =>
				if START = '1' then
					NEXT_STATE <= ROUND;
					P_EXP_START <= '1';
					CNT_LOAD <= '1';
					CNT_DATA <= to_unsigned(DIM / 2 - 1, CNT_UART_WIDTH);
				end if;
			when ROUND =>
			    if P_EXP_DONE = '1' then
			        NEXT_STATE <= SETUP;
			    end if;
			when SETUP =>
	            P_LOAD <= '1';
	            P_WE <= '1';
	            M_EXP_START <= '1';
			    --load, we, mat exp start
			    NEXT_STATE <= S_MAT_EXP;
			when S_MAT_EXP =>
			    if M_EXP_DONE = '1' then
			        NEXT_STATE <= S_MAT_SUB;
			    end if;
			when S_MAT_SUB =>
			    NEXT_STATE <= S_MAT_ADD_0;
			when S_MAT_ADD_0 =>
			    NEXT_STATE <= S_MAT_ADD_1;
			when S_MAT_ADD_1 =>
			    NEXT_STATE <= S_EXT_PROD;
			    EX_PROD_START <= '1';
			when S_EXT_PROD =>
			    if EX_PROD_DONE = '1' then
			         NEXT_STATE <= FINAL;
			    end if;
			when FINAL =>
			    if CNT_ZERO = '1' then
	                 P_WE <= '1';
			         NEXT_STATE <= DELAY_DONE;
			    else
			         NEXT_STATE <= DELAY;
			         CNT_CE <= '1';
			    end if;
			when DELAY =>
			    NEXT_STATE <= S_MAT_EXP;
	            P_WE <= '1';
	            M_EXP_START <= '1';
	        when DELAY_DONE =>
	            DONE <= '1';
			    NEXT_STATE <= IDLE;
		end case;
	end process;
    
end BOOTSTRAPPING_BODY;
