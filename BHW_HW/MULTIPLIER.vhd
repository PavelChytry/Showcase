library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity MULTIPLIER is
	port (
		CLK, RST, START : in std_logic;
		A, B : in std_logic_vector((WIDTH - 1) downto 0);
		Y : out std_logic_vector((WIDTH - 1) downto 0);
		DONE : out std_logic
	);
end MULTIPLIER;

architecture MULTIPLIER_BODY of MULTIPLIER is

	component LSFR
		port (
			CLK, RST, WE, CE : in  std_logic;
         A : in  std_logic_vector((WIDTH - 1) downto 0);
			Y : out  std_logic_vector((WIDTH - 1) downto 0)
		);
	end component;

	component SREG
		port (
			CLK, RST, WE, CE : in std_logic;
			A : in std_logic_vector((WIDTH - 1) downto 0);
			YO : out std_logic
		);
	end component;
	
	component MULT_CONTROLLER
		port (
			CLK, RST, START : in std_logic;
			DONE, RST_C, WE_B, WE_C, CE_B, CE_C : out std_logic
		);
	end component;

	signal B0, WE_B, CE_B, RST_C, WE_C, CE_C : std_logic;
	signal CIN : std_logic_vector((WIDTH - 1) downto 0);
begin

	and_bit : for i in WIDTH - 1 downto 0 generate
		CIN(i) <= A(i) and B0;
	end generate;
	
	shift_reg : SREG port map(CLK => CLK, RST => RST, WE => WE_B, CE => CE_B, A => B, YO => B0);
	
	lsf_reg : LSFR port map(CLK => CLK, RST => RST_C, WE => WE_C, CE => CE_C, A => CIN, Y => Y);
	
	ctrl : MULT_CONTROLLER port map(CLK => CLK, RST => RST, START => START, DONE => DONE,
			RST_C => RST_C, WE_B => WE_B, WE_C => WE_C, CE_B => CE_B, CE_C => CE_C);
end MULTIPLIER_BODY;

