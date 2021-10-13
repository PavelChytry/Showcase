LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.const.all;
 
ENTITY TB_MAIN IS
END TB_MAIN;
 
ARCHITECTURE behavior OF TB_MAIN IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MAIN
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         RXD : IN  std_logic;
			LED : out std_logic_vector(7 downto 0);
         TXD : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal RXD : std_logic := '0';
	
	signal REF_DATA, LED : std_logic_vector(7 downto 0);
	signal TMP : std_logic_vector(NO_OF_INPUT_BITS - 1 downto 0);
	
 	--Outputs
   signal TXD : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant BIT_period : time := 8680 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MAIN PORT MAP (
          CLK => CLK,
          RST => RST,
          RXD => RXD,
			 LED => LED,
          TXD => TXD
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      RST <= '0';
      wait for CLK_period;
		RST <= '1';
		RXD <= '1';
      wait for CLK_period;
		RST <= '0';
		TMP <= X"00001000010000100001000010000100001000010000100001000010000100001000010000100001";
		
		--TMP <= X"FABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD0ABCD";
		--TMP <= X"0000000000000000000000000000000000000000";
		
		--for J in 0 to 7 loop
		--TMP <= X"00001000000000000000000000000000000000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00000000010000000000000000000000000000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00000000000000100000000000000000000000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00000000000000000001000000000000000000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00001000000000000000000010000000000000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00000000010000000000000000000100000000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00000000000000100000000000000000001000000000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		--TMP <= X"00000000000000000001000000000000000000010000100001000010000100001000010000100001";
      wait for CLK_period;
		for I in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (I * 8) downto NO_OF_INPUT_BITS - 8 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		
		TMP <= X"00001000010000100001000010000100001000010000100001000010000100001000010000100001";
      wait for CLK_period;
		
		for i_k in 0 to 1 loop
		for i_j in 0 to 7 loop
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
			--REF_DATA <= TMP(319 - (I * 8) downto 312 - (I * 8));
			RXD <= '0';
			wait for BIT_period;
			--data
			for I in 0 to 7 loop
				RXD <= REF_DATA(I);
				wait for BIT_period;
			end loop;
			--end bit
			RXD <= '1';
			wait for BIT_period;
		end loop;
		end loop;
		end loop;
		
      wait for BIT_period * 100000;
   end process;

END;
