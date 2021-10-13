LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.CONST.ALL;
 
ENTITY TB IS
END TB;
 
ARCHITECTURE behavior OF TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component TORUSMULT is
		port (
			CLK : in std_logic; -- synchronous?
			I : in std_logic_vector(IOTA - 1 downto 0); -- integer
			T : in std_logic_vector(TAU - 1 downto 0); -- torus
			Y : out std_logic_vector(TAU - 1 downto 0)
		);
	end component;
    

   --Inputs
   signal I : std_logic_vector(IOTA - 1 downto 0) := (others => '0');
   signal T : std_logic_vector(TAU - 1 downto 0) := (others => '0');

 	--Outputs
   signal Y : std_logic_vector(TAU - 1 downto 0);
 
	signal CLK : std_logic;
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TORUSMULT PORT MAP (
          CLK => CLK,
          I => I,
			 T => T,
          Y => Y
        );

   -- Clock process definitions
   CLK_process : process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		--I <= X"00A"; -- 10
		--T <= "10" & X"83F4"; -- 164 852
		-- Y == X"12788" expected

		--I <= X"6BECC03D68A7";
		--T <= X"38A8F66D7F4C385F";

		I <= X"00000000000A";
		T <= X"00000000000283F4"; -- 192788

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
