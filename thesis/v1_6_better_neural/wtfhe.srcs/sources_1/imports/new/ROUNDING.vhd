library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;


entity ROUNDING is
    port (
        T_R : in TORUS_POLY;
        I_R : out INT_POLY_SPLIT
    );
end ROUNDING;

architecture ROUNDING_BODY of ROUNDING is

    type INTERMEDIATE is array(N - 1 downto 0) of UNSIGNED(IOTA - 1 downto 0);
    
    signal TEMP : INTERMEDIATE;
    
begin

    GEN:
	for i_j in N - 1 downto 0 generate
	   TEMP(i_j) <= T_R(i_j)(TAU - 1 downto TAU - IOTA) + unsigned(T_R(i_j)(TAU - IOTA - 1 downto TAU - IOTA - 1));
	   GEN2:
	   for i_i in L - 1 downto 0 generate
	       I_R(i_i)(i_j) <= TEMP(i_j)((i_i + 1) * GAMMA - 1 downto i_i * GAMMA);
	   end generate;
	end generate;

end ROUNDING_BODY;
