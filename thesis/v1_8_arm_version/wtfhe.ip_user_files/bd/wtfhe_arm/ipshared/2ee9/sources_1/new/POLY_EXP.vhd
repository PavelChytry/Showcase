library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- overwrites one element of TRLWE Sample with DATA * X^(exp) on an index gives by CNT_R value
entity POLY_EXP is
    port (
        CLK, RST, EN : in std_logic;
        CNT_R : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        EXP : in UNSIGNED(NU downto 0);
        P_OUT : out TORUS_POLYS
    );
end POLY_EXP;

architecture POLY_EXP_BODY of POLY_EXP is

	   signal OVERF, FLAG : std_logic;
	   signal IDX : UNSIGNED(CNT_WIDTH downto 0) := to_unsigned(0, CNT_WIDTH + 1);
	   
begin
    -- negacyclic overflow detection
    -- if FLAG = 1, the input data should be multiplied by -1
    OVERF <= EXP(NU);
    FLAG <= OVERF xor IDX(CNT_WIDTH);
    IDX <= "0" & CNT_R(CNT_WIDTH - 1 downto 0) - EXP(CNT_WIDTH - 1 downto 0);
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                P_OUT <= (others => (others => to_unsigned(0, TAU)));
            elsif EN = '1' then
                if FLAG = '1' then
                    P_OUT(to_integer(CNT_R(CNT_WIDTH downto CNT_WIDTH)))(to_integer(IDX(CNT_WIDTH - 1 downto 0))) <= not(DATA) + 1;
                else
                    P_OUT(to_integer(CNT_R(CNT_WIDTH downto CNT_WIDTH)))(to_integer(IDX(CNT_WIDTH - 1 downto 0))) <= DATA;
                end if;
            end if;
        end if;
    end process;
    	
end POLY_EXP_BODY;
