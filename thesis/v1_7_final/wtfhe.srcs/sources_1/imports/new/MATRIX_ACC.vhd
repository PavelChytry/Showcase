library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- summs one element of TRGSW Sample with DATA * X^(exp) on an index gives by CNT_R value
entity MATRIX_ACC is
    port (
        CLK, RST, EN, EN_EXP, EN_SUB : in std_logic;
        INDEX : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        EXP : in UNSIGNED(NU downto 0);
        MAT_OUT : out TORUS_MATRIX
    );
end MATRIX_ACC;

architecture MATRIX_ACC_BODY of MATRIX_ACC is

	signal OVERF, FLAG : std_logic;
	signal IDX : UNSIGNED(CNT_WIDTH downto 0) := to_unsigned(0, CNT_WIDTH + 1);
    signal MAT_TMP : TORUS_MATRIX;
    
    -- pipeline stages
    signal DATA_DELAY : UNSIGNED(TAU - 1 downto 0);
    signal EN_DELAY, EN_EXP_DELAY, FLAG_DELAY, EN_SUB_DELAY : std_logic;
    signal IDX_DELAY : UNSIGNED(CNT_WIDTH downto 0);
    signal INDEX_DELAY : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    
begin
    
    -- negacyclic overflow detection
    -- if FLAG = 1, the input data should be multiplied by -1
    OVERF <= EXP(NU);
    FLAG <= OVERF xor IDX(CNT_WIDTH);
    IDX <= "0" & INDEX(CNT_WIDTH - 1 downto 0) + EXP(CNT_WIDTH - 1 downto 0);
    MAT_OUT <= MAT_TMP;    
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            DATA_DELAY <= DATA;
            EN_DELAY <= EN;
            EN_EXP_DELAY <= EN_EXP;
            FLAG_DELAY <= FLAG;
            EN_SUB_DELAY <= EN_SUB;
            IDX_DELAY <= IDX;
            INDEX_DELAY <= INDEX;
        end if;
    end process;
    
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                MAT_TMP <= (others => (others => (others => to_unsigned(0, TAU))));
            elsif EN_DELAY = '1' then
                if EN_EXP_DELAY = '1' then
                    -- 12 - 10: matice (6)
                    -- 5: sloupce (2)
                    -- 9 - 6: radek (10)
                    -- 4 - 0: koeficienty (32)
                    if FLAG_DELAY = '1' then
                        MAT_TMP
                        (to_integer(INDEX_DELAY(CNT_WIDTH downto CNT_WIDTH)))
                        (to_integer(INDEX_DELAY(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))
                        (to_integer(IDX_DELAY(CNT_WIDTH - 1 downto 0))) 
                        <= not(DATA_DELAY) + 1 + MAT_TMP
                        (to_integer(INDEX_DELAY(CNT_WIDTH downto CNT_WIDTH)))
                        (to_integer(INDEX_DELAY(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))
                        (to_integer(IDX_DELAY(CNT_WIDTH - 1 downto 0)));
                    else
                        MAT_TMP
                        (to_integer(INDEX_DELAY(CNT_WIDTH downto CNT_WIDTH)))
                        (to_integer(INDEX_DELAY(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))
                        (to_integer(IDX_DELAY(CNT_WIDTH - 1 downto 0))) 
                        <= DATA_DELAY + MAT_TMP
                        (to_integer(INDEX_DELAY(CNT_WIDTH downto CNT_WIDTH)))
                        (to_integer(INDEX_DELAY(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))
                        (to_integer(IDX_DELAY(CNT_WIDTH - 1 downto 0)));
                    end if;                    
                elsif EN_SUB_DELAY = '1' then
                    MAT_TMP
                    (to_integer(INDEX_DELAY(CNT_WIDTH downto CNT_WIDTH)))
                    (to_integer(INDEX_DELAY(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))
                    (to_integer(INDEX_DELAY(CNT_WIDTH - 1 downto 0))) 
                    <= MAT_TMP
                    (to_integer(INDEX_DELAY(CNT_WIDTH downto CNT_WIDTH)))
                    (to_integer(INDEX_DELAY(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))
                    (to_integer(INDEX_DELAY(CNT_WIDTH - 1 downto 0))) - DATA_DELAY;
                end if;
            end if;
        end if;
    end process;

end MATRIX_ACC_BODY;
