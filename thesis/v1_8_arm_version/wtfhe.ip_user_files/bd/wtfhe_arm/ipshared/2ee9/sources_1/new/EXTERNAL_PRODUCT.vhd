library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- External Product entity
entity EXTERNAL_PRODUCT is
    port (
        CLK, RST, START : in std_logic;
        T_MATRIX : in TORUS_MATRIX;
        T_POLY_IN : in TORUS_POLYS;
        T_POLY_OUT : out TORUS_POLYS;
        DONE : out std_logic
    );
end EXTERNAL_PRODUCT;

architecture EXTERNAL_PRODUCT_BODY of EXTERNAL_PRODUCT is

    component POLY_SPLIT is
    port (
        CLK : in std_logic;
        T_R : in TORUS_POLY;
        I_R : out INT_POLY_SPLIT
    );
    end component;
    
    component MATRIX_MULT is
	port (
		CLK, RST, START : in std_logic;
		I : in INT_VECTOR;
		T : in TORUS_MATRIX;
		Y : out TORUS_POLYS;
		DONE : out std_logic
	);
    end component;

    signal I_SPLIT_0, I_SPLIT_1 : INT_POLY_SPLIT;
    
    signal I_MULT : INT_VECTOR;
    
    signal MULT_START, MULT_DONE : std_logic;
    
    type T_STATE is (IDLE, ROUND, MULT, FINISHED);
	signal STATE, NEXT_STATE : T_STATE;
    
begin
    
    -- merge both vectors into a one bigger vector
    GEN_J:
	for i_j in 0 to L - 1 generate
	   GEN_K:
	   for i_k in 0 to N - 1 generate	       
	       I_MULT((K + 1) * L - 1 - i_j)(i_k) <= I_SPLIT_1(i_j)(i_k);
	       I_MULT((K + 1) * L - 1 - i_j - L)(i_k) <= I_SPLIT_0(i_j)(i_k);
	   end generate;
	end generate;

    -- split each polynomial of TRLWE Sample into a vector of integer polynomials
    round0 : POLY_SPLIT port map (CLK => CLK, T_R => T_POLY_IN(0), I_R => I_SPLIT_0);
    round1 : POLY_SPLIT port map (CLK => CLK, T_R => T_POLY_IN(1), I_R => I_SPLIT_1);
    
    matmult : MATRIX_MULT port map (CLK => CLK, RST => RST, START => MULT_START, I => I_MULT, T => T_MATRIX, Y => T_POLY_OUT, DONE => MULT_DONE);

    -- controller
    process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= IDLE;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
	
	process (STATE, RST, START, MULT_DONE)
	begin
		NEXT_STATE <= STATE;
	    MULT_START <= '0';
	    DONE <= '0';
	    
		case STATE is
			when IDLE => -- wait for start
				if START = '1' then
	                MULT_START <= '1';
					NEXT_STATE <= ROUND;
				end if;
		    when ROUND => -- delay for TLWE splitting and rounding
	            MULT_START <= '1';
				NEXT_STATE <= MULT;
			when MULT => -- calc vector-matrix multiplication
			    if MULT_DONE = '1' then
				    NEXT_STATE <= FINISHED;
				end if;
			when FINISHED => -- done, return to idle
			    DONE <= '1';
				NEXT_STATE <= IDLE;
		end case;
	end process;
	
end EXTERNAL_PRODUCT_BODY;