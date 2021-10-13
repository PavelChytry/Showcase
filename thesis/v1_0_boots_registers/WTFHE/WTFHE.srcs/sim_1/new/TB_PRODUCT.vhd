library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;
use std.textio.all;

entity TB_PRODUCT is
--  Port ( );
end TB_PRODUCT;

architecture TB_PRODUCT_BODY of TB_PRODUCT is

    component EXTERNAL_PRODUCT is
    port (
        CLK, RST, START : in std_logic;
        T_MATRIX : in TORUS_MATRIX;
        T_POLY_IN : in TORUS_POLYS;
        T_POLY_OUT : out TORUS_POLYS;
        DONE : out std_logic
    );
    end component;

    --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal START : std_logic := '0';   
   
   signal T_MATRIX : TORUS_MATRIX := (others => (others => (others => to_unsigned(0, TAU))));
   signal T_POLY_IN : TORUS_POLYS := (others => (others => to_unsigned(0, TAU)));
   
   signal T_POLY_OUT : TORUS_POLYS;
   signal DONE : std_logic;
   
   constant CLK_period : time := 10 ns;
   
begin

    uut : EXTERNAL_PRODUCT port map (CLK => CLK, RST => RST, START => START,
        T_MATRIX => T_MATRIX, T_POLY_IN => T_POLY_IN, T_POLY_OUT => T_POLY_OUT, DONE => DONE);
        
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
		file poly_in			: text open read_mode is "C:\Users\DarkWave\Desktop\WTFHE\wtfhe-vivado\WTFHE\poly_in.dat";
		file matrix_in    		: text open read_mode is "C:\Users\DarkWave\Desktop\WTFHE\wtfhe-vivado\WTFHE\matrix_in.dat";
		file poly_out         	: text open read_mode is "C:\Users\DarkWave\Desktop\WTFHE\wtfhe-vivado\WTFHE\poly_out.dat";
		variable row      		: line;
		variable data_poly_in	: t_integer_array(0 to 2 * N - 1);
		variable data_matrix_in : t_integer_array(0 to 2 * N - 1);
		variable data_poly_out	: t_integer_array(0 to 2 * N - 1);
   begin		
      RST <= '0';
      wait for CLK_period;
	  RST <= '1';
      wait for CLK_period;
	  RST <= '0';
	  	  
	  -- input polynoms
      for i_a in 0 to K loop
        if(not endfile(poly_in)) then
			readline(poly_in, row);
		end if;		
		for i_b in 0 to N - 1 loop
		    read(row, data_poly_in(i_b));
			T_POLY_IN(i_a)(i_b) <= to_unsigned(data_poly_in(i_b), TAU);
        end loop;
	  end loop;
	  
	  -- input matrix
	  for i_a in 0 to (K + 1) * L - 1 loop
	  for i_c in 0 to K loop
	    if(not endfile(matrix_in)) then
			readline(matrix_in, row);
		end if;		
		for i_b in 0 to N - 1 loop
		    read(row, data_matrix_in(i_b));
			T_MATRIX(i_c)(i_a)(i_b) <= to_unsigned(data_matrix_in(i_b), TAU);
		end loop;
	  end loop;
	  end loop;
	  
	  file_close(poly_in);
	  file_close(matrix_in);
	  
	  START <= '1';
      wait for CLK_period;
	  START <= '0';
	  
	  wait until DONE = '1';
	  
	  for i_a in 0 to K loop
			if(not endfile(poly_out)) then
				readline(poly_out, row);
			end if;
			
			for i_b in 0 to N - 1 loop
				read(row, data_poly_out(i_b));
				assert T_POLY_OUT(i_a)(i_b) = to_unsigned(data_poly_out(i_b), TAU)
					report "rip";
			end loop;
	  end loop;
	  
	  file_close(poly_out);
	  
	  wait;
	end process;
	
end TB_PRODUCT_BODY;
