library IEEE;
use IEEE.STD_LOGIC_1164.all;

package CONST is

	-- EC parameters
	constant WIDTH : integer := 79; --15; --4; --79;
	constant MSB_WIDTH : integer := 6; --3; --1; --6; -- highest set bit in binary representation of (WIDHT - 1), indexed from 0
	constant CNT_WIDTH : integer := 7; --4; --3; --7; -- 2^7 = 128 > 79
	constant Fx : std_logic_vector(WIDTH downto 0) := X"80000000000000000201"; -- a^79 + a^9 + 1
	
	--"10011"; --a^4 + a + 1
	--"11000001"; --a^7 + a^6 + 1
	--"1000000000000011" --a^15 + a + 1
	--X"80000000000000000201"; -- a^79 + a^9 + 1
	
	-- UART parameters
	constant BAUD_RATE               : integer := 115200;
   constant NO_OF_TRANSFERRED_BITS  : integer := 8;
	constant NO_OF_EC_BITS				: integer := 80; -- 79b + infinity bit

   constant CLK_F                   : integer := 100000000;                    -- clock frequency of crystal (100 MHz)
   constant BIT_INTERVAL_TIME       : integer := (CLK_F/BAUD_RATE)-1;
   constant FIRST_BIT_INTERVAL_TIME : integer := (3*CLK_F)/(2*BAUD_RATE);
end CONST;
