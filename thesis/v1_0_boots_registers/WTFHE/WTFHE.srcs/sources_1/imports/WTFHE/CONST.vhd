library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package CONST is
	-- WTFHE parameters
	constant GAMMA							: integer := 3; --3
	constant DIM							: integer := 4; --4
	constant BG								: integer := 2**GAMMA;
	constant K								: integer := 1; --1
	constant L								: integer := 4; --4
	constant N								: integer := 16; --16
	constant CNT_WIDTH					    : integer := 4; -- 2^CNT_WIDTH > N - 1
	constant IOTA							: integer := GAMMA * L; --12
	constant TAU							: integer := 18; --18
	constant NU                             : integer := 4;
		
	-- UART parameters
	constant BAUD_RATE                  : integer := 115200;
    constant NO_OF_TRANSFERRED_BITS     : integer := 8;
	constant NO_OF_INPUT_BITS			: integer := N * 20; --320 -- N * 20
	constant CNT_UART_WIDTH				: integer := 9;

   constant CLK_F                   : integer := 100000000; --100000000;                    -- clock frequency of crystal (100 MHz)
   constant BIT_INTERVAL_TIME       : integer := (CLK_F/BAUD_RATE)-1;
   constant FIRST_BIT_INTERVAL_TIME : integer := (3*CLK_F)/(2*BAUD_RATE);
	
   -- fundamental data types -- doesnt work??
 	--type T_TORUS        is UNSIGNED(TAU - 1 downto 0);                        -- torus
 	--type T_INT          is UNSIGNED(IOTA - 1 downto 0);                       -- integer
   -- polynomials
   type TORUS_POLY     is array(N - 1 downto 0) of UNSIGNED(TAU - 1 downto 0);	-- polynomial over torus
   type INT_POLY       is array(N - 1 downto 0) of UNSIGNED(GAMMA - 1 downto 0);  -- polynomial over integer
   type INT_SPLIT      is array(N - 1 downto 0) of UNSIGNED(GAMMA - 1 downto 0);
   type INT_POLY_SPLIT is array(0 to L - 1) of INT_SPLIT;
   
   type TLWE           is array(DIM downto 0) of UNSIGNED(TAU - 1 downto 0);
   type TLWE_ROUND     is array(DIM downto 0) of UNSIGNED(NU downto 0);
   type TLWE_N         is array(N downto 0) of UNSIGNED(TAU - 1 downto 0);
   -- vectors and matrix
   type TORUS_POLYS	   is array(0 to K) of TORUS_POLY;									-- 2 polynomials over torus
   type INT_VECTOR     is array(0 to (K + 1) * L - 1) of INT_POLY;           		-- vector of polynomials over integer
   type TORUS_VECTOR   is array(0 to (K + 1) * L - 1) of TORUS_POLY;         		-- vector of polynomials over torus
   type TORUS_MATRIX   is array(0 to K) of TORUS_VECTOR;                     		-- matrix of polynomials over torus (1st index = column, 2nd index = row!)

   type BOOTSTRAPPING_KEYS is array(0 to (DIM * 3 / 2) - 1) of TORUS_MATRIX;
-- -- Dej si pozor na indexy u TORUS_MATRIX! Prvni index je sloupec, druhy je radek. U klasicke matice je to presne obracene!
	
end CONST;

package body CONST is
end package body CONST;
