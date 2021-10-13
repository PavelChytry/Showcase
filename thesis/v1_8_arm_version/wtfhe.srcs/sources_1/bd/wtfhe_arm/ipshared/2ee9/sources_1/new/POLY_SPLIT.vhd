library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- splits a TRLWE Sample into a vector of integer polynomials
-- TRLWE Sample is first rouded down to IOTA bits
-- then L parts, each with GAMMA bits, are extracted and reordered into a vector of polynomials.
entity POLY_SPLIT is
    port (
        CLK : in std_logic;
        T_R : in TORUS_POLY;
        I_R : out INT_POLY_SPLIT
    );
end POLY_SPLIT;

architecture POLY_SPLIT_BODY of POLY_SPLIT is

    type INTERMEDIATE is array(N - 1 downto 0) of UNSIGNED(IOTA - 1 downto 0);
    
    signal TEMP : INTERMEDIATE;
    
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            for i_j in N - 1 downto 0 loop
            TEMP(i_j) <= T_R(i_j)(TAU - 1 downto TAU - IOTA) + unsigned(T_R(i_j)(TAU - IOTA - 1 downto TAU - IOTA - 1));
                for i_i in L - 1 downto 0 loop
                    I_R(i_i)(i_j) <= TEMP(i_j)((i_i + 1) * GAMMA - 1 downto i_i * GAMMA);
                end loop;
            end loop;
        end if;
    end process;

end POLY_SPLIT_BODY;
