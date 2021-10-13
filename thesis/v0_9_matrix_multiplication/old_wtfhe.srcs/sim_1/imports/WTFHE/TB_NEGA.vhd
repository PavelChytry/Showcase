LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.const.all; 
 
ENTITY TB_NEGA IS
END TB_NEGA;
 
ARCHITECTURE behavior OF TB_NEGA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
--    COMPONENT NEGACYCLICMEM
--    PORT(
--         CLK : IN  std_logic;
--         RST : IN  std_logic;
--         LOAD : IN  std_logic;
--         PULSE : IN  std_logic;
--			A : in TORUS_ARRAY(N - 1 downto 0);
--			Y : out TORUS_ARRAY(N - 1 downto 0)
--        );
--    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal LOAD : std_logic := '0';
   signal PULSE : std_logic := '0';
   --signal A : TORUS_ARRAY(N - 1 downto 0) := (others => (others => '0'));

 	--Outputs
   --signal Y : TORUS_ARRAY(N - 1 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
--   uut: NEGACYCLICMEM PORT MAP (
--          CLK => CLK,
--          RST => RST,
--          LOAD => LOAD,
--          PULSE => PULSE,
--          A => A,
--          Y => Y
--        );

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
	
      wait for CLK_period / 2;
		--A(15) <= "1001";
		RST <= '0';
      wait for CLK_period;
		RST <= '1';
      wait for CLK_period;
		RST <= '0';
      wait for CLK_period;
		LOAD <= '1';
      wait for CLK_period;
		LOAD <= '0';
		PULSE <= '1';
      wait for CLK_period;
		PULSE <= '0';
		
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
