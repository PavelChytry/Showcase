library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
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
	
	component MERGER is
	port (
		CLK, RST, RXD_STROBE : in std_logic;
		RXD_DATA : in std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		DATA_OUT : out std_logic_vector(NO_OF_EC_BITS - 1 downto 0);
		DONE : out std_logic
	);
	end component;
	
	component SPLITTER is
	port (
		CLK, RST, SEND, TXD_READY : in std_logic;
		DATA_IN : in std_logic_vector(NO_OF_EC_BITS - 1 downto 0);
		TXD_DATA : out std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		TXD_STROBE, DONE : out std_logic
	);
	end component;
	
	component EC_ADDER is
		port (
			CLK, RST, START : in std_logic;
			infP, infQ : in std_logic;
			ap, x0, y0, x1, y1 : in std_logic_vector((WIDTH - 1) downto 0);
			x2, y2 : out std_logic_vector((WIDTH - 1) downto 0);
			infR : out std_logic;
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

	signal MERGE_OUT, SPLIT_IN, SPLIT_REG, A_MPX, B_MPX : std_logic_vector(NO_OF_EC_BITS - 1 downto 0);
	signal RXD_DATA, TXD_DATA : std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
	signal ap, x0, y0, x1, y1, x2, y2 : std_logic_vector((WIDTH - 1) downto 0);
	
	signal infP, infQ, infR, RXD_STROBE, TXD_STROBE, TXD_READY : std_logic;
	signal EC_START, EC_DONE, RECEIVED, SEND, SENT : std_logic;
	signal WE_AP, WE_X0, WE_Y0, WE_X1, WE_Y1, WE_INFP, WE_INFQ, SPLIT_SEL : std_logic;

	type T_STATE is (STARTUP, INIT, LOAD_X0, LOAD_Y0, LOAD_X1, LOAD_Y1, DELAY, ADD, RET_X2, RET_Y2);
	signal STATE, NEXT_STATE : T_STATE;
	
begin
	
	merge : MERGER port map (CLK => CLK, RST => RST, RXD_STROBE => RXD_STROBE, RXD_DATA => RXD_DATA, DATA_OUT => MERGE_OUT, DONE => RECEIVED);
	
	split : SPLITTER port map (CLK => CLK, RST => RST, SEND => SEND, TXD_READY => TXD_READY, DATA_IN => SPLIT_IN, TXD_DATA => TXD_DATA, TXD_STROBE => TXD_STROBE, DONE => SENT);
	
	adder : EC_ADDER port map (CLK => CLK, RST => RST, START => EC_START,
		infP => infP, infQ => infQ, ap => ap, x0 => x0, y0 => y0, x1 => x1, y1 => y1, x2 => x2, y2 => y2, infR => infR, DONE => EC_DONE);
	
	uart : RS232 port map (RXD => RXD, RXD_DATA => RXD_DATA, RXD_STROBE => RXD_STROBE, TXD_DATA => TXD_DATA,
		TXD_STROBE => TXD_STROBE, TXD => TXD, TXD_READY => TXD_READY, CLK => CLK, RESET => RST);
	
	reg_ap : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_AP, A => MERGE_OUT(WIDTH - 1 downto 0), Y => ap);
	reg_x0 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_X0, A => MERGE_OUT(WIDTH - 1 downto 0), Y => x0);
	reg_x1 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_Y0, A => MERGE_OUT(WIDTH - 1 downto 0), Y => y0);
	reg_y0 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_X1, A => MERGE_OUT(WIDTH - 1 downto 0), Y => x1);
	reg_y1 : REG generic map (REG_SIZE => WIDTH)
			  port map (CLK => CLK, RST => RST, WE => WE_Y1, A => MERGE_OUT(WIDTH - 1 downto 0), Y => y1);
	
	reg_infP : REG generic map (REG_SIZE => 1)
			  port map (CLK => CLK, RST => RST, WE => WE_INFP, A(0) => MERGE_OUT(WIDTH), Y(0) => infP);
	reg_infQ : REG generic map (REG_SIZE => 1)
			  port map (CLK => CLK, RST => RST, WE => WE_INFQ, A(0) => MERGE_OUT(WIDTH), Y(0) => infQ);
	
	A_MPX <= infR & x2;
	B_MPX <= '0' & y2;
	split_mpx : MULTIPLEX generic map (SIZE => NO_OF_EC_BITS)
			  port map (A => A_MPX, B => B_MPX, SEL => SPLIT_SEL, Y => SPLIT_IN);
	
	LED(5) <= infR;
	LED(6) <= infQ;
	LED(7) <= infR;
	
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
	
	process (STATE, RST, EC_DONE, RECEIVED, SENT)
	begin
		NEXT_STATE <= STATE;
		
		EC_START <= '0';
		SEND <= '0';
		WE_AP <= '0';
		WE_X0 <= '0';
		WE_Y0 <= '0';
		WE_X1 <= '0'; 
		WE_Y1 <= '0';
		WE_INFP <= '0';
		WE_INFQ <= '0';
		SPLIT_SEL <= '1';
		
		LED(0) <= '0';
		LED(1) <= '0';
		LED(2) <= '0';
		LED(3) <= '0';
		LED(4) <= '0';
		
		case STATE is
			when STARTUP =>
				LED(0) <= '1';
				LED(1) <= '1';
				LED(2) <= '1';
				LED(3) <= '1';
				LED(4) <= '1';
			when INIT =>
				LED(0) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= LOAD_X0;
					WE_AP <= '1';
				end if;
			when LOAD_X0 =>
				LED(1) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= LOAD_Y0;
					WE_X0 <= '1';
					WE_INFP <= '1';
				end if;
			when LOAD_Y0 =>
				LED(0) <= '1';
				LED(1) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= LOAD_X1;
					WE_Y0 <= '1';
				end if;
			when LOAD_X1 =>
				LED(2) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= LOAD_Y1;
					WE_X1 <= '1'; 
					WE_INFQ <= '1';
				end if;
			when LOAD_Y1 =>
				LED(0) <= '1';
				LED(2) <= '1';
				if RECEIVED = '1' then
					NEXT_STATE <= DELAY;
					WE_Y1 <= '1';
				end if;
			when DELAY =>
				LED(1) <= '1';
				LED(2) <= '1';
				EC_START <= '1';
				NEXT_STATE <= ADD;
			when ADD =>
				LED(0) <= '1';
				LED(1) <= '1';
				LED(2) <= '1';
				if EC_DONE = '1' then
					NEXT_STATE <= RET_X2;
					SEND <= '1';
				end if;
			when RET_X2 =>
				LED(3) <= '1';
				if SENT = '1' then
					NEXT_STATE <= RET_Y2;
					SEND <= '1';
					SPLIT_SEL <= '0';
				end if;
			when RET_Y2 =>
				LED(1) <= '1';
				LED(3) <= '1';
				SPLIT_SEL <= '0';
				if SENT = '1' then
					NEXT_STATE <= INIT;
				end if;
		end case;
	end process;

end MAIN_BODY;

