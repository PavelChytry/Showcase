library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;

entity LSFR is
	port (
		CLK, RST, WE, CE : in std_logic;
		A : in std_logic_vector((WIDTH - 1) downto 0);
		Y : out std_logic_vector((WIDTH - 1) downto 0)
	);
end LSFR;

architecture LSFR_BODY of LSFR is

	signal O : std_logic_vector((WIDTH - 1) downto 0);
	signal MASK : std_logic_vector((WIDTH - 1) downto 0);
	
begin

	Y <= O;
	
	gen_mask : for i in WIDTH - 1 downto 0 generate
		MASK(i) <= Fx(i) and O(WIDTH - 1);
	end generate gen_mask;
	
	process (CLK)
	begin 
		if rising_edge(CLK) then
			if (RST = '1') then
				O <= (others => '0');
			elsif (WE = '1' and CE = '0') then
				O <= A;
			elsif (WE = '0' and CE = '1') then
				O <= O((WIDTH-2) downto 0) & '0' xor MASK;
			elsif (WE = '1' and CE = '1') then
				O <= O((WIDTH-2) downto 0) & '0' xor MASK xor A;
			end if;
		end if;
	end process; 

end LSFR_BODY;
