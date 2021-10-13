library IEEE;
use work.CONST.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RS232 is
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
end RS232;



architecture RS232_BODY of RS232 is

   -----------------------------------------------------
   -- RXD ----------------------------------------------
   -----------------------------------------------------
   type   TYPE_RX_STATE is (START, INIT, SEND, ACK);

   signal RX_BIT_INTERVAL      : std_logic_vector(15 downto 0);
   signal RX_LOAD_BIT_INTERVAL : std_logic;
   signal RX_LOAD_FIRST_BIT_INTERVAL : std_logic;
   signal RX_EN_BIT_INTERVAL   : std_logic;
   signal RX_BIT_INTERVAL_END  : std_logic;

   signal RX_BIT_COUNTER       : std_logic_vector(3 downto 0);
   signal RX_LOAD_BIT_COUNTER  : std_logic;
   signal RX_EN_BIT_COUNTER    : std_logic;
   signal RX_BIT_COUNTER_END   : std_logic;

   signal RXD_DATA_REG         : std_logic_vector (NO_OF_TRANSFERRED_BITS-1 downto 0);
   signal RX_EN_DATA_OUT       : std_logic;

   signal RX_STATE, RX_NEXT_STATE : TYPE_RX_STATE;

   -- input synchronizer signals
   signal RXD_Q : std_logic;
   signal RXD_QQ : std_logic;

   -----------------------------------------------------
   -- TXD ----------------------------------------------
   -----------------------------------------------------
   type   TYPE_TX_STATE is (START, INIT, SEND);

   signal TX_BIT_INTERVAL      : std_logic_vector(15 downto 0);
   signal TX_LOAD_BIT_INTERVAL : std_logic;
   signal TX_EN_BIT_INTERVAL   : std_logic;
   signal TX_BIT_INTERVAL_END  : std_logic;

   signal TX_BIT_COUNTER       : std_logic_vector(3 downto 0);
   signal TX_LOAD_BIT_COUNTER  : std_logic;
   signal TX_EN_BIT_COUNTER    : std_logic;
   signal TX_BIT_COUNTER_END   : std_logic;

   signal TXD_DATA_REG         : std_logic_vector (NO_OF_TRANSFERRED_BITS+2 downto 0);

   signal TX_STATE, TX_NEXT_STATE : TYPE_TX_STATE;



begin
   -----------------------------------------------------
   -----------------------------------------------------
   -- RXD ----------------------------------------------
   -----------------------------------------------------
   -----------------------------------------------------

   ---------------------------------------------
   -- INPUT SYNCHRONIZATION    -----------------
   ---------------------------------------------
   RXD_SYNCHRONIZER : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         RXD_Q  <= RXD;
         RXD_QQ <= RXD_Q;
      end if;
   end process;
   

   ---------------------------------------------
   -- BIT INTERVAL MEASUREMENT -----------------
   -- measures time of one bit transfer in a BIT_RATE
   ---------------------------------------------
   RX_BIT_INTERVAL_MEASUREMENT : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if RX_LOAD_BIT_INTERVAL = '1' then
            RX_BIT_INTERVAL <= conv_std_logic_vector(BIT_INTERVAL_TIME,16);
         elsif RX_LOAD_FIRST_BIT_INTERVAL = '1' then
            RX_BIT_INTERVAL <= conv_std_logic_vector(FIRST_BIT_INTERVAL_TIME,16);
         elsif RX_EN_BIT_INTERVAL = '1' then
            RX_BIT_INTERVAL <= RX_BIT_INTERVAL - 1;
         end if;
      end if;
   end process;
   
   RX_BIT_INTERVAL_END <= '1' when (RX_BIT_INTERVAL = conv_std_logic_vector(0,16)) else
                          '0';


   ---------------------------------------------
   -- BIT COUNTING -----------------------------
   -- counts bits to be send
   ---------------------------------------------
   RX_BIT_COUNTING : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if RX_LOAD_BIT_COUNTER = '1' then
            RX_BIT_COUNTER <= conv_std_logic_vector(NO_OF_TRANSFERRED_BITS,4);
         elsif RX_EN_BIT_COUNTER = '1' then
            RX_BIT_COUNTER <= RX_BIT_COUNTER - 1;
         end if;
      end if;
   end process;
   
   RX_BIT_COUNTER_END <= '1' when (RX_BIT_COUNTER = conv_std_logic_vector(0,4)) else
                         '0';

   
   ---------------------------------------------
   -- FSM --------------------------------------
   -- controls RxD -----------------------------
   ---------------------------------------------
   RX_FSM_TRANSITION_AND_OUTPUT : process (RX_STATE, RXD_QQ, RX_BIT_INTERVAL_END, RX_BIT_COUNTER_END)
   begin
      RX_LOAD_BIT_COUNTER  <= '0';
      RX_EN_BIT_COUNTER    <= '0';
      RX_LOAD_BIT_INTERVAL <= '0';
      RX_LOAD_FIRST_BIT_INTERVAL <= '0';
      RX_EN_BIT_INTERVAL   <= '0';
      RXD_STROBE           <= '0';
      RX_EN_DATA_OUT       <= '0';
      
   
      case RX_STATE is
         when START => if RXD_QQ = '0' then
                          RX_NEXT_STATE <= INIT;
                          ---------------------
                          RX_LOAD_BIT_COUNTER <= '1';
                       else
                          RX_NEXT_STATE <= START;
                       end if;

         when INIT  =>    RX_NEXT_STATE <= SEND;
                          ------------------------
                          RX_LOAD_FIRST_BIT_INTERVAL <= '1';

         when SEND  => if RX_BIT_INTERVAL_END = '0' then
                          RX_NEXT_STATE <= SEND;
                          ---------------------
                          RX_EN_BIT_INTERVAL <= '1';
                       elsif RX_BIT_COUNTER_END = '0' then
                            RX_NEXT_STATE <= SEND;
                          ---------------------
                          RX_LOAD_BIT_INTERVAL <= '1';
                          RX_EN_BIT_COUNTER <= '1';
                       else         
                          RX_NEXT_STATE  <= ACK;
                          RX_EN_DATA_OUT <= '1';
                       end if;
         when ACK   =>    RX_NEXT_STATE <= START;
                          RXD_STROBE <= '1';
      end case;
   end process;

   RX_FSM_REG : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if RESET = '1' then
            RX_STATE <= START;
         else
            RX_STATE <= RX_NEXT_STATE;
         end if;
      end if;
   end process;



   ---------------------------------------------
   -- RXD shift register -----------------------
   ---------------------------------------------
   RXD_SHIFT_REG : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if RESET = '1' then
            RXD_DATA_REG <= (others => '0');
         else
            if RX_EN_BIT_COUNTER = '1' then
               RXD_DATA_REG <= RXD_QQ & RXD_DATA_REG(NO_OF_TRANSFERRED_BITS-1 downto 1);
            end if;
         end if;
      end if;
   end process;
   
   
   ---------------------------------------------
   -- RXD capture register ---------------------
   ---------------------------------------------
   RXD_CAPTURE_REG : process(CLK)
   begin
      if CLK = '1' and CLK'event then
         if RESET = '1' then
            RXD_DATA <= (others => '0');
         elsif RX_EN_DATA_OUT = '1' then
            RXD_DATA <= RXD_DATA_REG;
         end if;
      end if;
   end process;




   -----------------------------------------------------
   -----------------------------------------------------
   -- TXD ----------------------------------------------
   -----------------------------------------------------
   -----------------------------------------------------




   ---------------------------------------------
   -- BIT INTERVAL MEASUREMENT -----------------
   -- measures time of one bit transfer in a BIT_RATE
   ---------------------------------------------
   TX_BIT_INTERVAL_MEASUREMENT : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if TX_LOAD_BIT_INTERVAL = '1' then
            TX_BIT_INTERVAL <= conv_std_logic_vector(BIT_INTERVAL_TIME,16);
         elsif TX_EN_BIT_INTERVAL = '1' then
            TX_BIT_INTERVAL <= TX_BIT_INTERVAL - 1;
         end if;
      end if;
   end process;
   
   TX_BIT_INTERVAL_END <= '1' when (TX_BIT_INTERVAL = conv_std_logic_vector(0,16)) else
                          '0';


   ---------------------------------------------
   -- BIT COUNTING -----------------------------
   -- counts bits to be send
   ---------------------------------------------
   TX_BIT_COUNTING : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if TX_LOAD_BIT_COUNTER = '1' then
            TX_BIT_COUNTER <= conv_std_logic_vector(NO_OF_TRANSFERRED_BITS+2,4);
         elsif TX_EN_BIT_COUNTER = '1' then
            TX_BIT_COUNTER <= TX_BIT_COUNTER - 1;
         end if;
      end if;
   end process;
   
   TX_BIT_COUNTER_END <= '1' when (TX_BIT_COUNTER = conv_std_logic_vector(0,4)) else
                         '0';

   
   ---------------------------------------------
   -- FSM --------------------------------------
   -- controls TxD -----------------------------
   ---------------------------------------------
   TX_FSM_TRANSITION_AND_OUTPUT : process (TX_STATE, TXD_STROBE, TX_BIT_INTERVAL_END, TX_BIT_COUNTER_END)
   begin
      TX_LOAD_BIT_COUNTER  <= '0';
      TX_EN_BIT_COUNTER    <= '0';
      TX_LOAD_BIT_INTERVAL <= '0';
      TX_EN_BIT_INTERVAL   <= '0';
      TXD_READY            <= '0';
      
   
      case TX_STATE is
         when START => if TXD_STROBE = '1' then
                          TX_NEXT_STATE <= INIT;
                          ---------------------
                          TXD_READY <= '1';
                          TX_LOAD_BIT_COUNTER <= '1';
                       else
                          TX_NEXT_STATE <= START;
                          ---------------------
                          TXD_READY <= '1';
                       end if;

         when INIT  =>    TX_NEXT_STATE <= SEND;
                          ------------------------
                          TX_LOAD_BIT_INTERVAL <= '1';
                          TX_EN_BIT_COUNTER <= '1';

         when SEND  => if TX_BIT_INTERVAL_END = '0' then
                          TX_NEXT_STATE <= SEND;
                          ---------------------
                          TX_EN_BIT_INTERVAL <= '1';
                       elsif TX_BIT_COUNTER_END = '0' then
                          TX_NEXT_STATE <= SEND;
                          ---------------------
                          TX_LOAD_BIT_INTERVAL <= '1';
                          TX_EN_BIT_COUNTER <= '1';
                       else         
                          TX_NEXT_STATE <= START;
                       end if;
      end case;
   end process;

   TX_FSM_REG : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if RESET = '1' then
            TX_STATE <= START;
         else
            TX_STATE <= TX_NEXT_STATE;
         end if;
      end if;
   end process;



   ---------------------------------------------
   -- TXD SHIFT REGISTER -----------------------
   ---------------------------------------------
   TX_SHIFT_REG : process (CLK)
   begin
      if CLK = '1' and CLK'event then
         if RESET = '1' then
            TXD_DATA_REG <= (others => '1');
         else
            if TX_LOAD_BIT_COUNTER = '1' then
               TXD_DATA_REG(0)  <= '1';               -- pre-start bit
               TXD_DATA_REG(1)  <= '0';               -- start bit
               TXD_DATA_REG(NO_OF_TRANSFERRED_BITS+1 downto 2) <= TXD_DATA;  -- data bits
               TXD_DATA_REG(NO_OF_TRANSFERRED_BITS+2) <= '1';               -- stop bit
            elsif TX_EN_BIT_COUNTER = '1' then
					TXD_DATA_REG <= '1' & TXD_DATA_REG(NO_OF_TRANSFERRED_BITS+2 downto 1);
            end if;
         end if;
      end if;
   end process;
   
   
   TXD <= TXD_DATA_REG(0);


end RS232_BODY;