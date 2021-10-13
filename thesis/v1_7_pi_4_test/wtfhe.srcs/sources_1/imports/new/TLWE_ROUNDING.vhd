library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity TLWE_ROUNDING is
    port (
        CLK : in std_logic;
        T_IN : in TLWE;
        T_OUT : out TLWE_ROUND
    );
end TLWE_ROUNDING;

architecture TLWE_ROUNDING_BODY of TLWE_ROUNDING is

begin

    process (CLK)
    begin
        if rising_edge(CLK) then
	       for i_i in DIM downto 0 loop
	           T_OUT(i_i) <= T_IN(i_i)(TAU - 1 downto TAU - NU - 1) + unsigned(T_IN(i_i)(TAU - NU - 2 downto TAU - NU - 2));
	       end loop;
        end if;
    end process;

--    GEN2:
--	for i_i in DIM downto 0 generate
--	   T_OUT(i_i) <= T_IN(i_i)(TAU - 1 downto TAU - NU - 1) + unsigned(T_IN(i_i)(TAU - NU - 2 downto TAU - NU - 2));
--	end generate;
	
end TLWE_ROUNDING_BODY;
