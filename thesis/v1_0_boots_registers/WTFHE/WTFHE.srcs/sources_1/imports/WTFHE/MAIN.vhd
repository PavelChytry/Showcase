library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity MAIN is
	port (
		CLK, RST : in std_logic;
		RXD : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		TXD : out std_logic
	);	
end MAIN;

architecture MAIN_BODY of MAIN is

	---- TODO fix all the stuffs
	component RS232 is
		port (
			RXD        : in  STD_LOGIC;                                             -- RxD serial in
			RXD_DATA   : out STD_LOGIC_VECTOR (NO_OF_TRANSFERRED_BITS-1 downto 0);  -- received data - parallel out
			RXD_STROBE : out STD_LOGIC;                                             -- high for 1 clock cycle upon data arrival

			TXD_DATA   : in  STD_LOGIC_VECTOR (NO_OF_TRANSFERRED_BITS-1 downto 0);  -- transmitted data - parallel in
			TXD_STROBE : in  STD_LOGIC;                                             -- start of transmission
			TXD        : out STD_LOGIC;                                             -- TxD serial out
			TXD_READY  : out STD_LOGIC;                                             -- high when ready for transmission

			CLK        : in  STD_LOGIC;
			RESET      : in  STD_LOGIC
		);
	end component;
	
	-- merge bytes from uart to some bigger vector
	component MERGER is
	port (
		CLK, RST, RXD_STROBE : in std_logic;
		RXD_DATA : in std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		DATA_OUT : out std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
		DONE : out std_logic
	);
	end component;
	
	-- splits bigger vector into byte chunks for uart
	component SPLITTER is
	port (
		CLK, RST, SEND, TXD_READY : in std_logic;
		DATA_IN : in std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
		TXD_DATA : out std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		TXD_STROBE, DONE : out std_logic
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
	
	component BOOTSTRAPPING is
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
    end component BOOTSTRAPPING;

	component REG is
		generic (
			REG_SIZE : INTEGER
		);
		port (
			CLK, WE, RST : in std_logic;
			A : in UNSIGNED((REG_SIZE - 1) downto 0);
			Y : out UNSIGNED((REG_SIZE - 1) downto 0)
		);
	end component;
	
	signal RXD_STROBE, TXD_STROBE, TXD_READY, SEND, SENT, RECEIVED, CNT_ZERO, CNT_ZERO2, PULSE_CNT, PULSE_CNT2, RST_CNT, RST_CNT2, BOOT_START, BOOT_DONE : std_logic;
	
	signal RXD_DATA, TXD_DATA : std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
	
	signal MERGE_OUT, SPLIT_IN : std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
	signal MERGE_OUT_U, SPLIT_IN_U : UNSIGNED(NO_OF_INPUT_BITS - 1 downto 0);
	
	signal CNT_R, CNT_R2, DATA : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
	
	signal WE_T : std_logic;
	signal WE_P : std_logic_vector(K downto 0);
	type WE_ARRAY is array(0 to DIM * 3 / 2 - 1) of std_logic_vector((K + 1) * L - 1 downto 0);
	signal WE_M1, WE_M2 : WE_ARRAY;

	signal P_IN : TORUS_POLYS;
	signal TLWE_IN : TLWE;
    signal BK : BOOTSTRAPPING_KEYS;
    signal TLWE_OUT : TLWE_N;
	
	type T_STATE is (STARTUP, INIT, LOAD_TLWE, DELAY_TLWE, LOAD_POLY, DELAY_POLY, LOAD_M1, DELAY_M1, LOAD_M2, DELAY_M2, CALC, SEND_TLWE);
	signal STATE, NEXT_STATE : T_STATE := STARTUP;
	
begin

	cntr : EXTCOUNTER2 port map (CLK => CLK, RST => RST_CNT, CE => PULSE_CNT, DATA => DATA, CNT_R => CNT_R, ZERO => CNT_ZERO);
    cntr2 : EXTCOUNTER2 port map (CLK => CLK, RST => RST_CNT2, CE => PULSE_CNT2, DATA => DATA, CNT_R => CNT_R2, ZERO => CNT_ZERO2);
    
	merge : MERGER port map (CLK => CLK, RST => RST, RXD_STROBE => RXD_STROBE, RXD_DATA => RXD_DATA, DATA_OUT => MERGE_OUT, DONE => RECEIVED);
	
	split : SPLITTER port map (CLK => CLK, RST => RST, SEND => SEND, TXD_READY => TXD_READY, DATA_IN => SPLIT_IN, TXD_DATA => TXD_DATA, TXD_STROBE => TXD_STROBE, DONE => SENT);
	
	uart : RS232 port map (RXD => RXD, RXD_DATA => RXD_DATA, RXD_STROBE => RXD_STROBE, TXD_DATA => TXD_DATA,
		TXD_STROBE => TXD_STROBE, TXD => TXD, TXD_READY => TXD_READY, CLK => CLK, RESET => RST);

	boots : BOOTSTRAPPING port map (CLK => CLK, RST => RST, START => BOOT_START, P_IN => P_IN, TLWE_IN => TLWE_IN, BK => BK, TLWE_OUT => TLWE_OUT, DONE => BOOT_DONE);
	
	MERGE_OUT_U <= unsigned(MERGE_OUT);
	SPLIT_IN <= std_logic_vector(SPLIT_IN_U);
	
	SPLT: for I_a in N downto 0 generate
		SPLIT_IN_U((I_a + 1) * 18 - 1 downto I_a * 18) <= TLWE_OUT(I_a);
	end generate;
	
	OUTER_P: for I_a in 0 to K generate
		INNER_P: for I_b in 0 to N - 1 generate
			reg_p : REG generic map (REG_SIZE => TAU)
					  port map (CLK => CLK, RST => RST, 
						WE => WE_P(I_a),
						A => MERGE_OUT_U((I_b + 1) * 20 - 3 downto I_b * 20),
						Y => P_IN(I_a)(I_b)
						);
		end generate;
	end generate;
    
    INNER_P: for I_a in 0 to DIM generate
        reg_p : REG generic map (REG_SIZE => TAU)
		  port map (CLK => CLK, RST => RST, 
			WE => WE_T,
			A => MERGE_OUT_U((I_a + 1) * 20 - 3 downto I_a * 20),
			Y => TLWE_IN(I_a)
		);
    end generate;
    
    OUTOUT_M: for I_k in 0 to DIM * 3 / 2 - 1 generate
	OUTER_M: for I_a in 0 to (K + 1) * L - 1 generate
		INNER_M: for I_b in 0 to N - 1 generate
			reg_m1 : REG generic map (REG_SIZE => TAU)
					  port map (CLK => CLK, RST => RST, 
						WE => WE_M1(I_k)(I_a),
						A => MERGE_OUT_U((I_b + 1) * 20 - 3 downto I_b * 20),
						Y => BK(I_k)(0)(I_a)(I_b)
						);
			reg_m2 : REG generic map (REG_SIZE => TAU)
					  port map (CLK => CLK, RST => RST, 
						WE => WE_M2(I_k)(I_a),
						A => MERGE_OUT_U((I_b + 1) * 20 - 3 downto I_b * 20),
						Y => BK(I_k)(1)(I_a)(I_b)
						);
		end generate;
	end generate;
	end generate;
			  
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= STARTUP;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	process (STATE, RST, CNT_ZERO, CNT_ZERO2, RECEIVED, SENT, BOOT_DONE, CNT_R, CNT_R2)
	begin
		NEXT_STATE <= STATE;
		
		BOOT_START <= '0';
		RST_CNT <= '0';
		RST_CNT2 <= '0';
		PULSE_CNT <= '0';
		PULSE_CNT2 <= '0';
		SEND <= '0';
		LED <= X"00";
		WE_T <= '0';
		WE_P <= "00";
		WE_M1 <= (others => (others => '0'));
		WE_M2 <= (others => (others => '0'));
		DATA <= (others => '0');
		
		case STATE is
			when STARTUP =>
				LED(0) <= '1';
				NEXT_STATE <= INIT;
			when INIT =>
				LED(1) <= '1';
				DATA <= to_unsigned(1, CNT_UART_WIDTH);
				RST_CNT <= '1';
				NEXT_STATE <= LOAD_TLWE;
			when LOAD_TLWE =>
				LED(0) <= '1';
				LED(1) <= '1';
				if RECEIVED = '1' then
					WE_T <= '1';
					NEXT_STATE <= DELAY_TLWE;
				end if;
			when DELAY_TLWE =>
				LED(2) <= '1';
				DATA <= to_unsigned(K, CNT_UART_WIDTH);
				RST_CNT <= '1';
				NEXT_STATE <= LOAD_POLY;
			when LOAD_POLY =>
				LED(0) <= '1';
				LED(2) <= '1';
				if RECEIVED = '1' then
					WE_P(to_integer(CNT_R)) <= '1';
					if CNT_ZERO = '1' then
						NEXT_STATE <= DELAY_POLY;
						DATA <= to_unsigned(DIM * 3 / 2 - 1, CNT_UART_WIDTH);
						RST_CNT2 <= '1';
					else
						PULSE_CNT <= '1';
					end if;
				end if;
			when DELAY_POLY =>
				LED(1) <= '1';
				LED(2) <= '1';
				DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
				RST_CNT <= '1';
				NEXT_STATE <= LOAD_M1;
			when LOAD_M1 =>
			    LED(7 downto 5) <= std_logic_vector(CNT_R2(2 downto 0));
				LED(0) <= '1';
				LED(1) <= '1';
				LED(2) <= '1';
				if RECEIVED = '1' then
					WE_M2(to_integer(CNT_R2))(to_integer(CNT_R)) <= '1';
					if CNT_ZERO = '1' then
						NEXT_STATE <= DELAY_M1;
					else
						PULSE_CNT <= '1';
					end if;
				end if;
			when DELAY_M1 =>
			    LED(7 downto 5) <= std_logic_vector(CNT_R2(2 downto 0));
				LED(3) <= '1';
			    DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
				RST_CNT <= '1';
				NEXT_STATE <= LOAD_M2;
			when LOAD_M2 =>
			    LED(7 downto 5) <= std_logic_vector(CNT_R2(2 downto 0));
				LED(0) <= '1';
				LED(3) <= '1';
				if RECEIVED = '1' then
					WE_M2(to_integer(CNT_R2))(to_integer(CNT_R)) <= '1';
					if CNT_ZERO = '1' then
						NEXT_STATE <= DELAY_M2;
					else
						PULSE_CNT <= '1';
					end if;
				end if;
			when DELAY_M2 =>
			    LED(7 downto 5) <= std_logic_vector(CNT_R2(2 downto 0));
				LED(1) <= '1';
				LED(3) <= '1';
				if CNT_ZERO2 = '1' then
				    NEXT_STATE <= CALC;
				    BOOT_START <= '1';
				else
				    DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
				    RST_CNT <= '1';
				    PULSE_CNT2 <= '1';
				    NEXT_STATE <= LOAD_M1;
				end if;
			when CALC =>
				LED(0) <= '1';
				LED(1) <= '1';
				LED(3) <= '1';
				if BOOT_DONE = '1' then
				    NEXT_STATE <= SEND_TLWE;
					SEND <= '1';
				end if;
			when SEND_TLWE =>
				LED(2) <= '1';
				LED(3) <= '1';
			    if SENT = '1' then
					if CNT_ZERO = '1' then
						NEXT_STATE <= INIT;
				    else
				        PULSE_CNT <= '1';
				        SEND <= '1';
					end if;
				end if;
		end case;
	end process;
	
end MAIN_BODY;

-- OLD MAIN --
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.all;
--use work.CONST.ALL;

--entity MAIN is
--	port (
--		CLK, RST : in std_logic;
--		RXD : in std_logic;
--		LED : out std_logic_vector(7 downto 0);
--		TXD : out std_logic
--	);	
--end MAIN;

--architecture MAIN_BODY of MAIN is

--	---- TODO fix all the stuffs
--	component RS232 is
--		port (
--			RXD        : in  STD_LOGIC;                                             -- RxD serial in
--			RXD_DATA   : out STD_LOGIC_VECTOR (NO_OF_TRANSFERRED_BITS-1 downto 0);  -- received data - parallel out
--			RXD_STROBE : out STD_LOGIC;                                             -- high for 1 clock cycle upon data arrival

--			TXD_DATA   : in  STD_LOGIC_VECTOR (NO_OF_TRANSFERRED_BITS-1 downto 0);  -- transmitted data - parallel in
--			TXD_STROBE : in  STD_LOGIC;                                             -- start of transmission
--			TXD        : out STD_LOGIC;                                             -- TxD serial out
--			TXD_READY  : out STD_LOGIC;                                             -- high when ready for transmission

--			CLK        : in  STD_LOGIC;
--			RESET      : in  STD_LOGIC
--		);
--	end component;
	
--	-- merge bytes from uart to some bigger vector
--	component MERGER is
--	port (
--		CLK, RST, RXD_STROBE : in std_logic;
--		RXD_DATA : in std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
--		DATA_OUT : out std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
--		DONE : out std_logic
--	);
--	end component;
	
--	-- splits bigger vector into byte chunks for uart
--	component SPLITTER is
--	port (
--		CLK, RST, SEND, TXD_READY : in std_logic;
--		DATA_IN : in std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
--		TXD_DATA : out std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
--		TXD_STROBE, DONE : out std_logic
--	);
--	end component;
	
--	component EXTCOUNTER2 is
--	port (
--		CLK, RST, CE : in std_logic;
--		DATA : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
--		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
--		ZERO : out std_logic
--	);
--	end component;

--	component MATRIXMULT is
--	port (
--		CLK, RST, START : in std_logic;
--		I : in INT_VECTOR;
--		T : in TORUS_MATRIX;
--		Y : out TORUS_POLYS;
--		DONE : out std_logic
--	);
--	end component;
	
--	component REG is
--		generic (
--			REG_SIZE : INTEGER
--		);
--		port (
--			CLK, WE, RST : in std_logic;
--			A : in UNSIGNED((REG_SIZE - 1) downto 0);
--			Y : out UNSIGNED((REG_SIZE - 1) downto 0)
--		);
--	end component;
	
--	signal RXD_STROBE, TXD_STROBE, TXD_READY, SEND, SENT, RECEIVED, WE_B, WE_C, CNT_ZERO, PULSE_CNT, RST_CNT, MULT_START, MULT_DONE : std_logic;
--	signal SEL : UNSIGNED(0 downto 0);
	
--	signal RXD_DATA, TXD_DATA : std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
	
--	signal MERGE_OUT, SPLIT_IN : std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
--	signal MERGE_OUT_U, SPLIT_IN_U : UNSIGNED(NO_OF_INPUT_BITS - 1 downto 0);
	
--	signal CNT_R, DATA : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
	
--	signal WE_A, WE_B1, WE_B2 : std_logic_vector((K + 1) * L - 1 downto 0);
	
--	signal A_OUT : INT_VECTOR;
--	signal B_OUT : TORUS_MATRIX;
--	signal C_IN : TORUS_POLYS;
	
--	type T_STATE is (STARTUP, INIT, LOAD_I, DELAY_A, LOAD_T_A, DELAY_B, LOAD_T_B, MULT, SEND_T);
--	signal STATE, NEXT_STATE : T_STATE := STARTUP;
	
--begin

--	cntr : EXTCOUNTER2 port map (CLK => CLK, RST => RST_CNT, CE => PULSE_CNT, DATA => DATA, CNT_R => CNT_R, ZERO => CNT_ZERO);

--	merge : MERGER port map (CLK => CLK, RST => RST, RXD_STROBE => RXD_STROBE, RXD_DATA => RXD_DATA, DATA_OUT => MERGE_OUT, DONE => RECEIVED);
	
--	split : SPLITTER port map (CLK => CLK, RST => RST, SEND => SEND, TXD_READY => TXD_READY, DATA_IN => SPLIT_IN, TXD_DATA => TXD_DATA, TXD_STROBE => TXD_STROBE, DONE => SENT);
	
--	uart : RS232 port map (RXD => RXD, RXD_DATA => RXD_DATA, RXD_STROBE => RXD_STROBE, TXD_DATA => TXD_DATA,
--		TXD_STROBE => TXD_STROBE, TXD => TXD, TXD_READY => TXD_READY, CLK => CLK, RESET => RST);

--	matmult : MATRIXMULT port map (CLK => CLK, RST => RST, START => MULT_START, I => A_OUT, T => B_OUT, Y => C_IN, DONE => MULT_DONE);
	
--	MERGE_OUT_U <= unsigned(MERGE_OUT);
--	SPLIT_IN <= std_logic_vector(SPLIT_IN_U);
	
--	SPLT: for I_a in N - 1 downto 0 generate
--		SPLIT_IN_U((I_a + 1) * 20 - 1 downto I_a * 20) <= "00" & C_IN(to_integer(SEL))(I_a);
--	end generate;
	
--	OUTER_A: for I_a in 0 to (K + 1) * L - 1 generate
--		INNER_A: for I_b in 0 to N - 1 generate
--			reg_i : REG generic map (REG_SIZE => IOTA)
--					  port map (CLK => CLK, RST => RST, 
--						WE => WE_A(I_a),
--						A => MERGE_OUT_U((I_b + 1) * 20 - 9 downto I_b * 20),
--						Y => A_OUT(I_a)(I_b)
--						);
--		end generate;
--	end generate;

--	OUTER_B: for I_a in 0 to (K + 1) * L - 1 generate
--		INNER_B: for I_b in 0 to N - 1 generate
--			reg_t1 : REG generic map (REG_SIZE => TAU)
--					  port map (CLK => CLK, RST => RST, 
--						WE => WE_B1(I_a),
--						A => MERGE_OUT_U((I_b + 1) * 20 - 3 downto I_b * 20),
--						Y => B_OUT(0)(I_a)(I_b)
--						);
--			reg_t2 : REG generic map (REG_SIZE => TAU)
--					  port map (CLK => CLK, RST => RST, 
--						WE => WE_B2(I_a),
--						A => MERGE_OUT_U((I_b + 1) * 20 - 3 downto I_b * 20),
--						Y => B_OUT(1)(I_a)(I_b)
--						);
--		end generate;
--	end generate;
			  
--	process (CLK)
--	begin
--		if rising_edge(CLK) then
--			if (RST = '1') then
--				STATE <= INIT;
--			else
--				STATE <= NEXT_STATE;
--			end if;
--		end if;
--	end process;
	
--	process (STATE, RST, CNT_ZERO, RECEIVED, SENT, MULT_DONE, CNT_R)
--	begin
--		NEXT_STATE <= STATE;
		
--		MULT_START <= '0';
--		RST_CNT <= '0';
--		PULSE_CNT <= '0';
--		SEL <= "0";
--		SEND <= '0';
--		LED <= X"00";
--		WE_A <= X"00";
--		WE_B1 <= X"00";
--		WE_B2 <= X"00";
		
--		case STATE is
--			when STARTUP =>
--				LED(0) <= '1';
--				DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
--				RST_CNT <= '1';
--			when INIT =>
--				LED(1) <= '1';
--				if RECEIVED = '1' then
--					PULSE_CNT <= '1';
--					NEXT_STATE <= LOAD_I;
--					WE_A(to_integer(CNT_R)) <= '1';
--				end if;
--			when LOAD_I =>
--				LED(0) <= '1';
--				LED(1) <= '1';
--				if RECEIVED = '1' then
--					WE_A(to_integer(CNT_R)) <= '1';
--					if CNT_ZERO = '1' then
--						DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
--						RST_CNT <= '1';
--						NEXT_STATE <= DELAY_A;
--					else
--						PULSE_CNT <= '1';
--					end if;
--				end if;
--			when DELAY_A =>
--				LED(2) <= '1';
--				NEXT_STATE <= LOAD_T_A;
--			when LOAD_T_A =>
--				LED(0) <= '1';
--				LED(2) <= '1';
--				if RECEIVED = '1' then
--					WE_B1(to_integer(CNT_R)) <= '1';
--					if CNT_ZERO = '1' then
--						DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
--						RST_CNT <= '1';
--						NEXT_STATE <= DELAY_B;
--					else
--						PULSE_CNT <= '1';
--					end if;
--				end if;
--			when DELAY_B =>
--				LED(1) <= '1';
--				LED(2) <= '1';
--				NEXT_STATE <= LOAD_T_B;
--			when LOAD_T_B =>
--				LED(0) <= '1';
--				LED(1) <= '1';
--				LED(2) <= '1';
--				if RECEIVED = '1' then
--					WE_B2(to_integer(CNT_R)) <= '1';
--					if CNT_ZERO = '1' then
--						DATA <= to_unsigned(K, CNT_UART_WIDTH);
--						RST_CNT <= '1';
--						NEXT_STATE <= MULT;
--						MULT_START <= '1';
--					else
--						PULSE_CNT <= '1';
--					end if;
--				end if;
--			when MULT => 
--				LED(3) <= '1';
--				if MULT_DONE = '1' then
--					NEXT_STATE <= SEND_T;
--					SEND <= '1';
--					PULSE_CNT <= '1';
--				end if;
--			when SEND_T =>
--				LED(0) <= '1';
--				LED(3) <= '1';
--				if SENT = '1' then
--					SEND <= '1';
--					SEL <= "1";
--					if CNT_ZERO = '1' then
--						DATA <= to_unsigned((K + 1) * L - 1, CNT_UART_WIDTH);
--						RST_CNT <= '1';
--						NEXT_STATE <= INIT;
--					end if;
--				end if;
--		end case;
--	end process;
	
--end MAIN_BODY;

