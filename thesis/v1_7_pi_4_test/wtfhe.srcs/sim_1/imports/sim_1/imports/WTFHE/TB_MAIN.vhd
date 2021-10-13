LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;
 
ENTITY TB_MAIN IS
END TB_MAIN;
 
ARCHITECTURE behavior OF TB_MAIN IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MAIN
    PORT(
         CLK : IN  std_logic;
         HW_RST : IN  std_logic;
         RXD : IN  std_logic;
			LED : out std_logic_vector(7 downto 0);
         TXD : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal HW_RST : std_logic := '0';
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
          HW_RST => HW_RST,
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
    REF_DATA <= X"00";
      HW_RST <= '0';
      wait for CLK_period;
		HW_RST <= '1';
		RXD <= '1';
      wait for CLK_period;
		HW_RST <= '0';
    wait for 1000 ns;
		
		--TMP <= X"00000000000000000000000000000000000000000000000000000000000000000000000000000080";
		--TMP <= X"02000040000800010000200000000000000000000000000000000000000000000000000000000000";
		--11111111111111111111111111111111111111111111111111111111111111111111111111111111
		--00001000010000100001000010000100001000010000100001000010000100001000010000100001
		--TMP <= X"0000100001000010000100001000010000100001";
		--TMP <= X"00001000010000100001";
		--TMP <= X"12345678901234567890";
		
		
--		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
--			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
--			RXD <= '0';
--			wait for BIT_period;
--			--data
--			for I in 0 to 7 loop
--				RXD <= REF_DATA(I);
--				wait for BIT_period;
--			end loop;
--			--end bit
--			RXD <= '1';
--			wait for BIT_period;
--		end loop;
		
--		TMP <= X"0000100002000030000400005000060000700008000090000A0000B0000C0000D0000E0000F00010";
--		wait for CLK_period;
		        
--		for i_k in 0 to K loop
--		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
--			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
--			RXD <= '0';
--			wait for BIT_period;
--			--data
--			for I in 0 to 7 loop
--				RXD <= REF_DATA(I);
--				wait for BIT_period;
--			end loop;
--			--end bit
--			RXD <= '1';
--			wait for BIT_period;
--		end loop;
--		end loop;
		
		-- send BOOTSTRAPPING KEYS
		--TMP <= X"000100002000030000400005000060000700008000090000A0000B0000C0000D0000E0000F000100";
		
		TMP <= X"4D4F4F4E";
		wait for CLK_period;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
		
		TMP <= X"484F4C44";
		wait for CLK_period;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
		
		TMP <= X"594F4C4F";
		wait for CLK_period;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
		
		
		
		TMP <= X"00000001";
		wait for CLK_period;
		        
		for i_l in 0 to DIM * 3 / 2 - 1 loop
		for i_n in 0 to K loop    
		for i_k in 0 to (K + 1) * L - 1 loop
		for i_m in 0 to N - 1 loop
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
		end loop;
		end loop;
		
		
		TMP <= X"00006000";
		wait for CLK_period;
		
		--for i_m in 0 to DIM loop
		    --TMP <= TMP + 1;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
	    
	    TMP <= X"0000C000";
		wait for CLK_period;
		
		--for i_m in 0 to DIM loop
		    --TMP <= TMP + 1;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
	    TMP <= X"0000A000";
		wait for CLK_period;
		
		--for i_m in 0 to DIM loop
		    --TMP <= TMP + 1;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
	    TMP <= X"00010000";
		wait for CLK_period;
		
		--for i_m in 0 to DIM loop
		    --TMP <= TMP + 1;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
	    TMP <= X"00000000";
		wait for CLK_period;
		
		--for i_m in 0 to DIM loop
		    --TMP <= TMP + 1;
		for i_i in 0 to (NO_OF_INPUT_BITS / 8) - 1 loop
			REF_DATA <= TMP(NO_OF_INPUT_BITS - 1 - (i_i * 8) downto NO_OF_INPUT_BITS - 8 - (i_i * 8));
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
	    --end loop;
	    
      wait for BIT_period * 100000;
   end process;

END;
