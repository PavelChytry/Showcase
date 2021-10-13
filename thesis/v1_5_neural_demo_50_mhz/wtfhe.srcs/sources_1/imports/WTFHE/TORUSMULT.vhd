library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

-- multiply torus number by an integer
entity TORUSMULT is
	port (
		CLK : in std_logic; -- synchronous?
		I : in UNSIGNED(GAMMA - 1 downto 0); -- integer
		T : in UNSIGNED(TAU - 1 downto 0); -- torus
		Y : out UNSIGNED(TAU - 1 downto 0)
	);
end entity TORUSMULT;

architecture TORUSMULT_BODY of TORUSMULT is

	--signal R : UNSIGNED(TAU + GAMMA - 1 downto 0);
	
	signal Y_std : std_logic_vector(TAU - 1 downto 0);
	
	--
	-- 19 = TAU - 1
	-- 2 = GAMMA - 1
	component mult_gen_0 IS
        PORT (
            CLK : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(TAU - 1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(GAMMA - 1 DOWNTO 0);
            P : OUT STD_LOGIC_VECTOR(TAU - 1 DOWNTO 0)
        );
    end component mult_gen_0;

begin
	
	-- forcing DSP48
	dsp : mult_gen_0 port map (CLK => CLK, A => std_logic_vector(T), B => std_logic_vector(I), P => Y_std);
	
	Y <= unsigned(Y_std);
	
	-- OLD code without forced DSP48s
--	process (CLK)
--	begin
--		if rising_edge(CLK) then
--			R <= I * T;
--		end if;
--	end process;

--	Y <= R(TAU - 1 downto 0);
	
end TORUSMULT_BODY;

