library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity MAIN is
	port (
		CLK, HW_RST : in std_logic;
		RXD : in std_logic;
		LED : out std_logic_vector(7 downto 0); -- status leds
		TXD : out std_logic
	);	
end MAIN;

architecture MAIN_BODY of MAIN is

    component clk_wiz_0 is
        Port ( 
            clk_out1 : out STD_LOGIC;
            reset : in STD_LOGIC;
            locked : out STD_LOGIC;
            clk_in1 : in STD_LOGIC
        );
    end component;

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
		DATA_IN : in std_logic_vector(NO_OF_OUTPUT_BITS - 1 downto 0);
		TXD_DATA : out std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
		TXD_STROBE, DONE : out std_logic
	);
	end component;
	
	component EXTENDED_COUNTER is
	port (
		CLK : in std_logic;
		RST : in std_logic;
		CE : in std_logic;
		SET : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(ADDR_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
    end component;
	
    component BOOTSTRAPPING_RAM is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        START : in std_logic;
        RAM_WE : in std_logic;
        TLWE_IN : in TLWE;
        RAM_DATA : in UNSIGNED(DATA_WIDTH - 1 DOWNTO 0);
        RAM_WE_ADDR : in UNSIGNED(ADDR_WIDTH - 1 DOWNTO 0);
        TLWE_OUT : out TLWE;
        DONE : out std_logic
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
	
	component ADDR_REG is
    port (
        CLK, RST, CE, DIR, PASS : in std_logic; -- DIR 1: inc, DIR 0: dec
        SET : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        PASSTHROUGH : in UNSIGNED(ADDR_WIDTH - 1 downto 0) := to_unsigned(0, ADDR_WIDTH);
        Y : out UNSIGNED(ADDR_WIDTH - 1 downto 0)
    );
    end component;
    
    signal CLK_NEW, SW_RST, RST : std_logic;
    
	signal RXD_STROBE, TXD_STROBE, TXD_READY, SEND, SENT, RECEIVED, BOOT_START, BOOT_START_DELAY, BOOT_DONE, RAM_WE, CNT_ZERO, PULSE_CNT, RST_CNT, ADDR_REG_RST, ADDR_CE : std_logic;
	
	signal RXD_DATA, TXD_DATA : std_logic_vector(NO_OF_TRANSFERRED_BITS - 1 downto 0);
	
	signal MERGE_OUT : std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
	signal MERGE_OUT_U : UNSIGNED(NO_OF_INPUT_BITS - 1 downto 0);
	
	signal SPLIT_IN : std_logic_vector(NO_OF_OUTPUT_BITS - 1 downto 0);
	signal SPLIT_IN_U : UNSIGNED(NO_OF_OUTPUT_BITS - 1 downto 0);
	
	signal RAM_DATA : UNSIGNED(NO_OF_INPUT_BITS - 1 DOWNTO 0);
	signal RAM_WE_ADDR, RAM_SET_ADDR : UNSIGNED(ADDR_WIDTH - 1 DOWNTO 0);
	signal CNT_R, DATA : UNSIGNED(ADDR_WIDTH - 1 downto 0);
	
	signal WE_R : std_logic_vector(DIM downto 0);

	signal TLWE_IN, TLWE_DELAY, TLWE_OUT : TLWE;
	
	type T_STATE is (STARTUP, INIT, LOAD_TRGSW, LOAD_TRLWE, LOAD_TLWE, CALC, SEND_TLWE, RESET);
	signal STATE : T_STATE := STARTUP;
	signal NEXT_STATE : T_STATE := STARTUP;
	
begin
    --merge RST signals
    RST <= HW_RST or SW_RST;
        
    clkgen : clk_wiz_0 port map (clk_out1 => CLK_NEW, reset => '0', locked => open, clk_in1 => CLK);
    cntr : EXTENDED_COUNTER port map (CLK => CLK_NEW, RST => RST_CNT, CE => PULSE_CNT, SET => DATA, CNT_R => CNT_R, ZERO => CNT_ZERO);
    merge : MERGER port map (CLK => CLK_NEW, RST => RST, RXD_STROBE => RXD_STROBE, RXD_DATA => RXD_DATA, DATA_OUT => MERGE_OUT, DONE => RECEIVED);
    split : SPLITTER port map (CLK => CLK_NEW, RST => RST, SEND => SEND, TXD_READY => TXD_READY, DATA_IN => SPLIT_IN, TXD_DATA => TXD_DATA, TXD_STROBE => TXD_STROBE, DONE => SENT);
    uart : RS232 port map (RXD => RXD, RXD_DATA => RXD_DATA, RXD_STROBE => RXD_STROBE, TXD_DATA => TXD_DATA,
		TXD_STROBE => TXD_STROBE, TXD => TXD, TXD_READY => TXD_READY, CLK => CLK_NEW, RESET => RST);
	a_reg : ADDR_REG port map (CLK => CLK_NEW, RST => ADDR_REG_RST, CE => ADDR_CE, DIR => '1', PASS => '0', SET => RAM_SET_ADDR, PASSTHROUGH => open, Y => RAM_WE_ADDR);
	boots : BOOTSTRAPPING_RAM port map (CLK => CLK_NEW, RST => RST, START => BOOT_START_DELAY, RAM_WE => RAM_WE, TLWE_IN => TLWE_DELAY, RAM_DATA => RAM_DATA, RAM_WE_ADDR => RAM_WE_ADDR, TLWE_OUT => TLWE_OUT, DONE => BOOT_DONE);
	
	--conv to/from unsigned
    MERGE_OUT_U <= unsigned(MERGE_OUT);
    SPLIT_IN <= std_logic_vector(SPLIT_IN_U);
    
    --pass to BRAM
    RAM_DATA <= MERGE_OUT_U;
    --data registers for TLWE
	GEN_R: for I_a in 0 to DIM generate
	   reg_p : REG generic map (REG_SIZE => TAU)
	       port map (CLK => CLK_NEW, RST => RST, 
		      WE => WE_R(I_a),
              A => MERGE_OUT_U(TAU - 1 downto 0),
			  Y => TLWE_IN(I_a)
           );
    end generate;

    --merge to output
    SPLT: for I_a in DIM downto 0 generate
		SPLIT_IN_U((I_a + 1) * NO_OF_INPUT_BITS - 1 downto I_a * NO_OF_INPUT_BITS) 
		<= (NO_OF_INPUT_BITS - TAU - 1 downto 0 => '0') & TLWE_OUT(I_a);
	end generate;
    
    -- start pipeline delay
    process (CLK_NEW)
	begin
		if rising_edge(CLK_NEW) then
		  BOOT_START_DELAY <= BOOT_START;
		  TLWE_DELAY <= TLWE_IN;
		end if;
	end process;
	
    --led debug
	process (STATE, CNT_R)
	begin	   
	   LED <= (others => '0');
	   case STATE is
	       when STARTUP => LED(0) <= '1';
	       when INIT => LED(1) <= '1';
	       when LOAD_TRGSW => LED(0) <= '1'; LED(1) <= '1';
	       when LOAD_TRLWE => LED(2) <= '1';
	       when LOAD_TLWE => LED(0) <= '1'; LED(2) <= '1';
	       when CALC => LED(1) <= '1'; LED(2) <= '1';
	       when SEND_TLWE => LED(0) <= '1'; LED(1) <= '1'; LED(2) <= '1';
	       when RESET => LED(3) <= '1';
	   end case;
	   LED(7 downto 4) <= std_logic_vector(CNT_R(3 downto 0));
	end process;
    
    -- wait till switch is flipped
    process (CLK_NEW)
	begin
		if rising_edge(CLK_NEW) then
			if (HW_RST = '1') then
				STATE <= INIT;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;

    --transition function
	process (STATE, RECEIVED, MERGE_OUT_U, BOOT_DONE, SENT, CNT_ZERO)
	begin
	   NEXT_STATE <= STATE; 
	   
	   case STATE is
	       when STARTUP => NULL; -- blocking initial state
	       when INIT => -- decide on aquired control code
	           if RECEIVED = '1' then
	               case (MERGE_OUT_U) is
	                   when to_unsigned(send_TRGSW, NO_OF_INPUT_BITS) =>
	                       NEXT_STATE <= LOAD_TRGSW;
	                   when to_unsigned(send_INPUT, NO_OF_INPUT_BITS) =>
	                       NEXT_STATE <= LOAD_TRLWE;
	                   when to_unsigned(sw_RESET, NO_OF_INPUT_BITS) =>
	                       NEXT_STATE <= RESET;
	                   when others => NEXT_STATE <= RESET; -- this is just weird and doesn't actually work
	               end case;
	           end if;
	        when LOAD_TRGSW => -- reading TRGSW over UART
	           if RECEIVED = '1' then
	               if MERGE_OUT_U = to_unsigned(sw_RESET, NO_OF_INPUT_BITS) then
	                   NEXT_STATE <= RESET;
	               elsif CNT_ZERO = '1' then
	                   NEXT_STATE <= INIT;
	               end if;
	           end if;
	       when LOAD_TRLWE => -- reading TRLWE over UART
	           if RECEIVED = '1' then
	               if MERGE_OUT_U = to_unsigned(sw_RESET, NO_OF_INPUT_BITS) then
	                   NEXT_STATE <= RESET;
	               elsif CNT_ZERO = '1' then
	                   NEXT_STATE <= LOAD_TLWE;
	               end if;
	           end if;
	       when LOAD_TLWE => -- reading TLWE over UART
	           if RECEIVED = '1' then
	               if MERGE_OUT_U = to_unsigned(sw_RESET, NO_OF_INPUT_BITS) then
	                   NEXT_STATE <= RESET;
	               elsif CNT_ZERO = '1' then
	                   NEXT_STATE <= CALC;
	               end if;
	           end if;
	       when CALC => -- Boostrapping is running
	           if BOOT_DONE = '1' then
	               NEXT_STATE <= SEND_TLWE;
	           end if;
	       when SEND_TLWE =>
	           if SENT = '1' then
	               NEXT_STATE <= INIT;
	           end if;  
	       when RESET => NEXT_STATE <= INIT;
	   end case;
	end process;
	
	--output function
	process (STATE, RECEIVED, MERGE_OUT_U, BOOT_DONE, SENT, CNT_ZERO, CNT_R)
	begin
	   ADDR_CE <= '0';
	   ADDR_REG_RST <= '0';
	   BOOT_START <= '0';
	   DATA <= (others => '0');
	   PULSE_CNT <= '0';
	   RAM_SET_ADDR <= (others => '0');
	   RAM_WE <= '0';
	   RST_CNT <= '0';
	   SEND <= '0';
	   SW_RST <= '0';
	   WE_R <= (others => '0');
	   
	   case STATE is
	       when STARTUP => SW_RST <= '1'; -- blocking initial state
	       when INIT => -- decide on aquired control code
	           if RECEIVED = '1' then
	               case (MERGE_OUT_U) is
	                   when to_unsigned(send_TRGSW, NO_OF_INPUT_BITS) =>
	                       DATA <= to_unsigned(MATRIX_HIGH, ADDR_WIDTH);
                           RST_CNT <= '1';
                           ADDR_REG_RST <= '1';
	                   when to_unsigned(send_INPUT, NO_OF_INPUT_BITS) =>
	                       RAM_SET_ADDR <= to_unsigned(MATRIX_HIGH + 1, ADDR_WIDTH);
	                       DATA <= to_unsigned(POLY_START - MATRIX_HIGH - 1, ADDR_WIDTH);
	                       RST_CNT <= '1';
                           ADDR_REG_RST <= '1';
	                   when to_unsigned(sw_RESET, NO_OF_INPUT_BITS) =>
	                       NULL;
	                   when others => NULL;
	               end case;
	           end if;
	       when LOAD_TRGSW => -- reading TRGSW over UART
	           if RECEIVED = '1' then
	               if MERGE_OUT_U = to_unsigned(sw_RESET, NO_OF_INPUT_BITS) then
	                   NULL;
	               elsif CNT_ZERO = '1' then
	                   RAM_WE <= '1';
	               else
	                   PULSE_CNT <= '1';
                       ADDR_CE <= '1';
                       RAM_WE <= '1';
                   end if;
	           end if;
	       when LOAD_TRLWE => -- reading TRLWE over UART
	           if RECEIVED = '1' then
	               if MERGE_OUT_U = to_unsigned(sw_RESET, NO_OF_INPUT_BITS) then
	                   NULL;
	               elsif CNT_ZERO = '1' then
	                   DATA <= to_unsigned(DIM, ADDR_WIDTH);
	                   RST_CNT <= '1';
	                   RAM_WE <= '1';
	               else
	                   PULSE_CNT <= '1';
                       ADDR_CE <= '1';
                       RAM_WE <= '1';
                   end if;
	           end if;
	       when LOAD_TLWE => -- reading TLWE over UART
	           if RECEIVED = '1' then
	               if MERGE_OUT_U = to_unsigned(sw_RESET, NO_OF_INPUT_BITS) then
	                   NULL;
	               elsif CNT_ZERO = '1' then
	                   BOOT_START <= '1';
	                   WE_R(DIM - to_integer(CNT_R)) <= '1';
	               else
	                   PULSE_CNT <= '1';
	                   WE_R(DIM - to_integer(CNT_R)) <= '1';
	               end if;
	           end if;
	       when CALC => -- Boostrapping is running
	           if BOOT_DONE = '1' then
	               SEND <= '1';
	           end if;
	       when SEND_TLWE => NULL;
	       when RESET => 
	           SW_RST <= '1';
	           RST_CNT <= '1';
	   end case;
	end process;
	
end MAIN_BODY;

