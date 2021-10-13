library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.const.all;

-- multiplication of integer and torus polynomial
entity POLY_MULT is
	port (
		CLK, RST, START : in std_logic;
		I : in INT_POLY; -- integer poly
		T : in TORUS_POLY; -- torus poly
		Y : out TORUS_POLY; -- torus poly
		DONE : out std_logic
	);
end POLY_MULT;

architecture POLY_MULT_BODY of POLY_MULT is
    
--    component TORUSMULT is
--	port (
--		CLK : in std_logic; -- synchronous?
--		I : in UNSIGNED(GAMMA - 1 downto 0); -- integer
--		T : in UNSIGNED(TAU - 1 downto 0); -- torus
--		Y : out UNSIGNED(TAU - 1 downto 0)
--	);
--    end component;
    component xbip_dsp48_macro_0 is -- change this back to 0
    port (
        CLK : IN STD_LOGIC;
        SCLR : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(TAU DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(GAMMA DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
    );
    end component;
    
	component ACCUMULATOR is
	port (
		CLK, RST, PULSE : in std_logic;
		A : in TORUS_POLY;
		Y : out TORUS_POLY
	);
	end component;
	
	component COUNTER is
	port (
		CLK, RST, CE : in std_logic;
		ZERO : out std_logic
	);
	end component;

	component LSM is
	port (
		CLK, RST, LOAD, PULSE : in std_logic;
		A : in INT_POLY;
		Y : out UNSIGNED(GAMMA - 1 downto 0)
	);
	end component;

	component NEGACYCLICMEM is
	port (
		CLK, RST, LOAD, PULSE : in std_logic;
		DIR : in std_logic := '0';
		A : in TORUS_POLY;
		Y : out TORUS_POLY
	);
	end component;

	signal T_IN, T_OUT : TORUS_POLY;
	signal I_IN : UNSIGNED(GAMMA - 1 downto 0);
	
	type arr is array (N - 1 downto 0) of std_logic_vector(47 downto 0);
	signal Y_std : arr;
	
	signal CE_CNT, LOAD, PULSE, RST_C, ZERO : std_logic;
	
	type T_STATE is (IDLE, CALC, FINISHED);
	signal STATE, NEXT_STATE : T_STATE;
	
begin
    -- instantiation of DSP blocks
	GEN_MULT:
	for J in N - 1 downto 0 generate
        multX : xbip_dsp48_macro_0 port map (CLK => CLK, SCLR => RST_C,
            A => '0' & std_logic_vector(T_IN(J)), B => '0' & std_logic_vector(I_IN), P => Y_std(J));
        Y(J) <= unsigned(Y_std(J)(TAU - 1 downto 0));
	end generate;
--    GEN_MULT:
--	for J in N - 1 downto 0 generate
--		multX : TORUSMULT port map (CLK => CLK, I => I_IN, T => T_IN(J), Y => T_OUT(J));
--	end generate;
	
    -- Torus polynomial storage
	A : NEGACYCLICMEM port map (CLK => CLK, RST => RST, LOAD => LOAD, PULSE => PULSE, A => T, Y => T_IN);
	
	-- integer polynomial storage
	B : LSM port map (CLK => CLK, RST => RST, LOAD => LOAD, PULSE => PULSE, A => I, Y => I_IN);
	
--	C : ACCUMULATOR port map (CLK => CLK, RST => RST_C, PULSE => PULSE, A => T_OUT, Y => Y);
	
	cnt : COUNTER port map (CLK => CLK, RST => START, CE => CE_CNT, ZERO => ZERO);
	
	-- controller
	process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= IDLE;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	process (STATE, RST, ZERO, START)
	begin
		CE_CNT <= '0';
		DONE <= '0';
		LOAD <= '0';
		PULSE <= '0';
		RST_C <= RST;
		NEXT_STATE <= STATE;
		
		case STATE is 
			when IDLE => -- wait for start
				if START = '1' then
					LOAD <= '1';
					RST_C <= '1';
					NEXT_STATE <= CALC;
				end if;
			when CALC => -- calc running
				CE_CNT <= '1';
				PULSE <= '1';
				if ZERO = '1' then
					NEXT_STATE <= FINISHED;
				end if;
			when FINISHED => -- calc done, back to idle
				DONE <= '1';
				NEXT_STATE <= IDLE;
		end case;
	end process;
	
end POLY_MULT_BODY;

