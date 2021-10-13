library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONST.ALL;

entity BIT_SEL is
	port (
		A : in std_logic_vector((CNT_WIDTH - 1) downto 0);
		K : in std_logic_vector((MSB_WIDTH - 1) downto 0);
		uI : out std_logic
	);
end BIT_SEL;

architecture BIT_SEL_BODY of BIT_SEL is

begin

	uI <= A(to_integer(unsigned(K)));
	
end BIT_SEL_BODY;

