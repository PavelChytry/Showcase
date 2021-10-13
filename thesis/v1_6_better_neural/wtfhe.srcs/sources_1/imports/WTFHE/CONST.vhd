library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package CONST is
	-- WTFHE parameters
	constant GAMMA							: integer := 3; --3
	constant DIM							: integer := 4; --4
	constant BG								: integer := 2**GAMMA;
	constant K								: integer := 1; --1
	constant L								: integer := 5; --4
	constant N								: integer := 32; --16
	constant CNT_WIDTH					    : integer := 5; -- 2^CNT_WIDTH == N
	constant IOTA							: integer := GAMMA * L; --12 --15 novì
	constant TAU							: integer := 22; --18 -- 20 novì
	constant NU                             : integer := 5; --4
	
	-- pi = 3 : gamma = 3, l = 5, N = 32, TAU = 22, NU = 5
	-- poly_addr = 16#F3F#, mat_high = 16#EFF#, mat_low = 16#77F#
	-- BRAM parameters
	constant DATA_WIDTH                    : integer := 32; -- WIDTH >= TAU
	constant ADDR_WIDTH                    : integer := 12; -- 2^ADDR_WIDTH >= (DIM * 3 / 2) * (K + 1) * ((K + 1) * L) * N
	constant POLY_START                    : integer := 16#F3F#; -- highest RAM address
	constant MATRIX_HIGH                   : integer := 16#EFF#; -- last address of last matrix
	constant MATRIX_LOW                    : integer := 16#77F#; -- last adress of 3rd matrix
	constant ROW_WIDTH                     : integer := 6; -- 2^ROW_WIDTH > (K + 1) * L
	type INT_ARRAY is ARRAY (0 to DIM / 2 - 1) of integer;
	constant ADDR_ARRAY                    : INT_ARRAY := (0 => MATRIX_HIGH, 1 => MATRIX_LOW); --set this to correct addresses when DIM != 4, mby inverse??
	
	-- UART comm codes
	constant send_TRGSW                : integer   := 16#4D4F4F4E#;
	constant send_INPUT                : integer   := 16#594F4C4F#;
	constant sw_RESET                  : integer   := 16#484F4C44#;
	
	-- UART parameters
	constant BAUD_RATE                  : integer := 115200;
    constant NO_OF_TRANSFERRED_BITS     : integer := 8;
	constant NO_OF_INPUT_BITS			: integer := 32; -- INPUT >= TAU
	constant NO_OF_OUTPUT_BITS          : integer := NU * 32; -- TLWE Sample --(N + 1) * 32;
	--constant CNT_UART_WIDTH				: integer := 12; -- 2^CNT_WIDTH >= (DIM * 3 / 2) * (K + 1) * ((K + 1) * L) * N -- is this needed?

   constant CLK_F                   : integer := 50000000; --100000000;                    -- clock frequency of crystal (100 MHz)
   constant BIT_INTERVAL_TIME       : integer := (CLK_F/BAUD_RATE)-1;
   constant FIRST_BIT_INTERVAL_TIME : integer := (3*CLK_F)/(2*BAUD_RATE);
	
   -- polynomials
   type TORUS_POLY     is array(N - 1 downto 0) of UNSIGNED(TAU - 1 downto 0);	-- polynomial over torus
   type INT_POLY       is array(N - 1 downto 0) of UNSIGNED(GAMMA - 1 downto 0);  -- polynomial over integer
   type INT_SPLIT      is array(N - 1 downto 0) of UNSIGNED(GAMMA - 1 downto 0);
   type INT_POLY_SPLIT is array(0 to L - 1) of INT_SPLIT;
   
   type TLWE           is array(NU - 1 downto 0) of UNSIGNED(TAU - 1 downto 0);
   type TLWE_ROUND     is array(NU - 1 downto 0) of UNSIGNED(NU downto 0);
   type TLWE_N         is array(N downto 0) of UNSIGNED(TAU - 1 downto 0);
   type EXPONENTS      is array((DIM * 3 / 2) - 1 downto 0) of UNSIGNED(NU downto 0);
   
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
