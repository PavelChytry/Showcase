library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- asynchronous Sample Extract
entity SAMPLE_EXTRACT is
    port (
        P_REG_OUT : in TORUS_POLYS;
        TLWE_OUT : out TLWE
    );
end SAMPLE_EXTRACT;

architecture SAMPLE_EXTRACT_BODY of SAMPLE_EXTRACT is

begin
    -- Sample Extract
    -- input: TRLWE Sample (r, s)
    -- TLWE_OUT = r^0, -r^(DIM - 1), ..., r^1, s^0
    TLWE_OUT(0) <= P_REG_OUT(1)(0);
    gen_out:
    for i_i in 1 to DIM generate
        TLWE_OUT(i_i) <= not(P_REG_OUT(0)(i_i)) + 1;
    end generate;

end SAMPLE_EXTRACT_BODY;
