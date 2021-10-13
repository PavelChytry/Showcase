library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity MAIN2 is
	port (
		CLK, RST : in std_logic;
		RXD : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		TXD : out std_logic
	);	
end MAIN2;

architecture MAIN_BODY2 of MAIN2 is

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
	
	component TORUSMULT is
	port (
		CLK : in std_logic; -- synchronous?
		I : in UNSIGNED(IOTA - 1 downto 0); -- integer
		T : in UNSIGNED(TAU - 1 downto 0); -- torus
		Y : out UNSIGNED(TAU - 1 downto 0)
	);
	end component;
	
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
	
	signal RXD_STROBE, TXD_STROBE, TXD_READY, SEND, SENT, RECEIVED, WE_A, WE_B, WE_C : std_logic;
	
	signal RXD_DATA, TXD_DATA : std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
	
	signal MERGE_OUT, SPLIT_IN : std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
	
	signal A_OUT : UNSIGNED(IOTA - 1 downto 0);
	signal B_OUT, C_IN, C_OUT : UNSIGNED(TAU - 1 downto 0);
	signal C_TMP : std_logic_vector(TAU - 1 downto 0);
	
	type T_STATE is (STARTUP, INIT, LOAD, DELAY, TMP, TMP2, RET);
	signal STATE, NEXT_STATE : T_STATE;
	
	constant PAD : std_logic_vector(NO_OF_INPUT_BITS - TAU - 1 downto 0) := (others => '0');
begin
	C_TMP <= std_logic_vector(C_OUT);

	merge : MERGER port map (CLK => CLK, RST => RST, RXD_STROBE => RXD_STROBE, RXD_DATA => RXD_DATA, DATA_OUT => MERGE_OUT, DONE => RECEIVED);
	
	split : SPLITTER port map (CLK => CLK, RST => RST, SEND => SEND, TXD_READY => TXD_READY, DATA_IN => PAD & C_TMP, TXD_DATA => TXD_DATA, TXD_STROBE => TXD_STROBE, DONE => SENT);
	
	uart : RS232 port map (RXD => RXD, RXD_DATA => RXD_DATA, RXD_STROBE => RXD_STROBE, TXD_DATA => TXD_DATA,
		TXD_STROBE => TXD_STROBE, TXD => TXD, TXD_READY => TXD_READY, CLK => CLK, RESET => RST);

	mult : TORUSMULT port map (CLK => CLK, I => A_OUT, T => B_OUT, Y => C_IN);
	
	reg_a : REG generic map (REG_SIZE => IOTA)
			  port map (CLK => CLK, RST => RST, WE => WE_A, A => unsigned(MERGE_OUT(IOTA - 1 downto 0)), Y => A_OUT);
	reg_b : REG generic map (REG_SIZE => TAU)
			  port map (CLK => CLK, RST => RST, WE => WE_B, A => unsigned(MERGE_OUT(TAU - 1 downto 0)), Y => B_OUT);
	reg_c : REG generic map (REG_SIZE => TAU)
			  port map (CLK => CLK, RST => RST, WE => WE_C, A => C_IN, Y => C_OUT);
			  
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
	
	process (STATE, RST, RECEIVED, SENT)
	begin
		NEXT_STATE <= STATE;
		
		WE_A <= '0';
		WE_B <= '0';
		WE_C <= '0';
		SEND <= '0';
		LED <= X"00";
		
		case STATE is
			when STARTUP =>
				LED(0) <= '1';
			when INIT =>
				LED(1) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= LOAD;
					WE_A <= '1';
				end if;
			when LOAD =>
				LED(0) <= '1';
				LED(1) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= DELAY;
					WE_B <= '1';
				end if;
			when DELAY =>
				LED(2) <= '1';
				NEXT_STATE <= TMP;
			when TMP =>
				LED(0) <= '1';
				LED(2) <= '1';
				NEXT_STATE <= TMP2;
				WE_C <= '1';
			when TMP2 => 
				LED(1) <= '1';
				LED(2) <= '1';
				NEXT_STATE <= RET;
				SEND <= '1';
			when RET =>
				LED(0) <= '1';
				LED(1) <= '1';
				LED(2) <= '1';
				if SENT = '1' then
					NEXT_STATE <= INIT;
				end if;
		end case;
	end process;
	
end MAIN_BODY2;
