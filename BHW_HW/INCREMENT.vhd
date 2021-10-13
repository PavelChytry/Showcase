library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.CONST.ALL;
use ieee.numeric_std.all;

entity INCREMENT is
	port (
		A : in std_logic_vector((CNT_WIDTH - 1) downto 0);
		Y : out std_logic_vector((CNT_WIDTH - 1) downto 0)
	);
end INCREMENT;

architecture INCREMENT_BODY of INCREMENT is

begin

	Y <= std_logic_vector(unsigned(A) + 1);

end INCREMENT_BODY;

