library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity MAT_SUB is
    port (
        CLK : in std_logic;
        A, B : in TORUS_MATRIX;
        Y : out TORUS_MATRIX
    );
end MAT_SUB;

architecture MAT_SUB_BODY of MAT_SUB is

begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            for i_j in 0 to K loop
                for i_i in 0 to (K + 1) * L - 1 loop
                    for i_k in 0 to N - 1 loop
                        Y(i_j)(i_i)(i_k) <= A(i_j)(i_i)(i_k) - B(i_j)(i_i)(i_k);
                    end loop;
                end loop;
            end loop;
        end if;
    end process;
    
end MAT_SUB_BODY;