LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.const.all;
use ieee.numeric_std.all;
use std.textio.all;
 
ENTITY TB_POLY IS
END TB_POLY;
 
ARCHITECTURE behavior OF TB_POLY IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
   component POLYMULT is
		port (
		CLK, RST, START : in std_logic;
		I : in INT_POLY; -- integer poly
		T : in TORUS_POLY; -- torus poly
		Y : out TORUS_POLY; -- torus poly
		DONE : out std_logic
	);
	end component;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal START : std_logic := '0';
   --signal I : INT_ARRAY(N - 1 downto 0) := (others => (others => '0'));
   --signal T : TORUS_ARRAY(N - 1 downto 0) := (others => (others => '0'));
	signal I : INT_POLY := (others => to_unsigned(0, IOTA));
	signal T : TORUS_POLY := (others => to_unsigned(0, TAU));
	
 	--Outputs
   --signal Y : TORUS_ARRAY(N - 1 downto 0);
	signal Y : TORUS_POLY;
   signal DONE : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: POLYMULT PORT MAP (
          CLK => CLK,
          RST => RST,
          START => START,
          I => I,
          T => T,
          Y => Y,
          DONE => DONE
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		type t_integer_array is array(integer range <>) of integer;
		file poly_int			: text open read_mode is "poly_int.dat";
		file poly_torus		: text open read_mode is "poly_torus.dat";
		file poly_res			: text open read_mode is "poly_res.dat";
		variable row_int		: line;
		variable row_torus	: line;
		variable row_res		: line;
		variable data_int		: t_integer_array(0 to 2 * N - 1);
		variable data_torus	: t_integer_array(0 to 2 * N - 1);
		variable data_res		: t_integer_array(0 to 2 * N - 1);
   begin
	
		wait for CLK_period / 2;
		RST <= '1';
		wait for CLK_period;
		RST <= '0';
		wait for CLK_period;
		
		-- file format:
		-- I(0) I(1) ... I(N - 1) 
		-- T(0) T(1) ... T(N - 1)
		-- i.e.
		-- a0 + x * a1 + ... + x^(n-1) * a(n-1)
		-- b0 + x * b1 + ... + x^(n-1) * b(n-1), a coeff from int, b coeff from torus
		
-- 1404 2838 2938 498 3287 3878 4056 1072 1305 600 2755 1875 1160 934 3942 2405		
		if(not endfile(poly_int)) then
			readline(poly_int, row_int);
		end if;
		if(not endfile(poly_torus)) then
			readline(poly_torus, row_torus);
		end if;
		if(not endfile(poly_res)) then
			readline(poly_res, row_res);
		end if;
		
		for i in 0 to N - 1 loop
        read(row_int, data_int(i));
        read(row_torus, data_torus(i));
        read(row_res, data_res(i));
      end loop;
		
		for k in 0 to N - 1 loop
			I(k) <= to_unsigned(0, IOTA);
			T(k) <= to_unsigned(1, TAU);
			--I(k) <= to_unsigned(data_int(k), IOTA);
			--T(k) <= to_unsigned(data_torus(k), TAU);
		end loop;
		I(0) <= to_unsigned(1, IOTA);
		
		START <= '1';
		wait for CLK_period;
		START <= '0';
		
		wait until DONE = '1';
		for i in 0 to N - 1 loop
			assert Y(i) = to_unsigned(data_res(i), TAU)
				report "rip";
		end loop;
		
		wait for CLK_period * 10000;
   end process;

END;
