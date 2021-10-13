library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity SREG is
	port (
		CLK, RST, WE, CE : in std_logic;
		A : in std_logic_vector((WIDTH - 1) downto 0);
		YO : out std_logic
	);
end SREG;

architecture SREG_BODY of SREG is
	
	component SHIFTER is
		generic (
			SIZE : INTEGER
		);
		port (
			AO : in std_logic;
			A : in std_logic_vector((SIZE - 1) downto 0);
			Y : out std_logic_vector((SIZE - 1) downto 0);
			YO : out std_logic
		);
	end component;
	
	signal ROUT, SOUT : std_logic_vector((WIDTH - 1) downto 0);
begin

	lshift : SHIFTER generic map (SIZE => WIDTH)
				port map(AO => '0', A => ROUT, Y => SOUT, YO => YO);
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				ROUT <= (others => '0');
			elsif WE = '1' then
				ROUT <= A;
			elsif CE = '1' then
				ROUT <= SOUT;
			end if;	
		end if;
	end process;
	
end SREG_BODY;

