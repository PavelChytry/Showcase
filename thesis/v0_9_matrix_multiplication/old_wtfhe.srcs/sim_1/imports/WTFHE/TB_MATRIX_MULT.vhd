LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.const.all;
use std.textio.all;
 
ENTITY TB_MATRIX_MULT IS
END TB_MATRIX_MULT;
 
ARCHITECTURE behavior OF TB_MATRIX_MULT IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MATRIXMULT
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         START : IN  std_logic;
			I : in INT_VECTOR; -- vector of integer polynoms
			T : in TORUS_MATRIX; -- matrix of torus polynoms
			Y : out TORUS_POLYS; -- K + 1 torus polynoms
         DONE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal START : std_logic := '0';
   signal I : INT_VECTOR := (others => (others => to_unsigned(0, IOTA)));
   signal T : TORUS_MATRIX := (others => (others => (others => to_unsigned(0, TAU))));

 	--Outputs
   signal Y : TORUS_POLYS;
   signal DONE : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MATRIXMULT PORT MAP (
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
 
	-- file format:
		-- I(0) I(1) ... I(N - 1) 
		-- T(0) T(1) ... T(N - 1)
		-- i.e.
		-- a0 + x * a1 + ... + x^(n-1) * a(n-1)
		-- b0 + x * b1 + ... + x^(n-1) * b(n-1), a coeff from int, b coeff from torus
		
		-- koeficienty u polynomu jsou v souboru obracene, nez pri posilani pres uart
		
   -- Stimulus process
   stim_proc: process
		type t_integer_array is array(integer range <>) of integer;
		file vect_int			: text open read_mode is "int_vector.dat";
		file vect_torus_0		: text open read_mode is "torus_vector_0.dat";
		file vect_torus_1		: text open read_mode is "torus_vector_1.dat";
		file vect_torus_res	: text open read_mode is "torus_vector_res.dat";
		variable row_int		: line;
		variable row_torus_0	: line;
		variable row_torus_1	: line;
		variable row_res		: line;
		variable data_int		: t_integer_array(0 to 2 * N - 1);
		variable data_torus_0: t_integer_array(0 to 2 * N - 1);
		variable data_torus_1: t_integer_array(0 to 2 * N - 1);
		variable data_res		: t_integer_array(0 to 2 * N - 1);
   begin
	
		-- read vector of int polynoms
		for i_a in 0 to (K + 1) * L - 1 loop
			if(not endfile(vect_int)) then
				readline(vect_int, row_int);
			end if;
			
			for i_b in 0 to N - 1 loop
				read(row_int, data_int(i_b));
				I(i_a)(i_b) <= to_unsigned(data_int(i_b), IOTA);
				--I(i_a)(i_b) <= to_unsigned(0, IOTA);
			end loop;
			--I(i_a)(0) <= to_unsigned(1, IOTA);
		end loop;
		
		--read matrix of torus polynoms
		for i_a in 0 to (K + 1) * L - 1 loop
			if(not endfile(vect_torus_0)) then
				readline(vect_torus_0, row_torus_0);
			end if;
			if(not endfile(vect_torus_1)) then
				readline(vect_torus_1, row_torus_1);
			end if;
			
			for i_b in 0 to N - 1 loop
				read(row_torus_0, data_torus_0(i_b));
				read(row_torus_1, data_torus_1(i_b));
				--T(0)(i_a)(i_b) <= to_unsigned(1, TAU);
				--T(1)(i_a)(i_b) <= to_unsigned(1, TAU);
				T(0)(i_a)(i_b) <= to_unsigned(data_torus_0(i_b), TAU);
				T(1)(i_a)(i_b) <= to_unsigned(data_torus_1(i_b), TAU);
			end loop;
		end loop;
		
      wait for CLK_period / 2;
		RST <= '1';
		wait for CLK_period;
		RST <= '0';
		wait for CLK_period;

		START <= '1';
		wait for CLK_period;
		START <= '0';
		
		wait until DONE = '1';
		for i_a in 0 to K loop
			if(not endfile(vect_torus_res)) then
				readline(vect_torus_res, row_res);
			end if;
			
			for i_b in 0 to N - 1 loop
				read(row_res, data_res(i_b));
				assert Y(i_a)(i_b) = to_unsigned(data_res(i_b), TAU)
					report "rip";
			end loop;
		end loop;
		
      wait;
   end process;

END;
