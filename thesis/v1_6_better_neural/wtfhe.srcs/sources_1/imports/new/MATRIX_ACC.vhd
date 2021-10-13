library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity MATRIX_ACC is
    port (
        CLK, RST, EN, EN_EXP, EN_SUB : in std_logic;
        INDEX : UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        EXP : in UNSIGNED(NU downto 0);
        MAT_OUT : out TORUS_MATRIX
    );
end MATRIX_ACC;

architecture MATRIX_ACC_BODY of MATRIX_ACC is

	signal OVERF, FLAG : std_logic;
	signal IDX : UNSIGNED(CNT_WIDTH downto 0) := to_unsigned(0, CNT_WIDTH + 1);
    signal MAT_TMP : TORUS_MATRIX;
    
begin

    OVERF <= EXP(NU);
    FLAG <= OVERF xor IDX(CNT_WIDTH);
    IDX <= "0" & INDEX(CNT_WIDTH - 1 downto 0) + EXP(CNT_WIDTH - 1 downto 0);
    MAT_OUT <= MAT_TMP;
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                MAT_TMP <= (others => (others => (others => to_unsigned(0, TAU))));
            elsif EN = '1' then
                if EN_EXP = '1' then
                    -- OLD
                    -- 10 - 8: matice (6)
                    -- 4: sloupce (2)
                    -- 7 - 5: radek (8)
                    -- 3 - 0: koeficienty (16)
                    -- NEW
                    -- 12 - 10: matice (6)
                    -- 5: sloupce (2)
                    -- 9 - 6: radek (10)
                    -- 4 - 0: koeficienty (32)
                    if FLAG = '1' then
                        MAT_TMP(to_integer(INDEX(CNT_WIDTH downto CNT_WIDTH)))(to_integer(INDEX(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))(to_integer(IDX(CNT_WIDTH - 1 downto 0))) 
                        <= not(DATA) + 1 + MAT_TMP(to_integer(INDEX(CNT_WIDTH downto CNT_WIDTH)))(to_integer(INDEX(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))(to_integer(IDX(CNT_WIDTH - 1 downto 0)));
                        -- OLD
                        --MAT_TMP(to_integer(CNT_R(4 downto 4)))(to_integer(CNT_R(7 downto 5)))(to_integer(IDX(3 downto 0))) 
                        --<= not(DATA) + 1 + MAT_TMP(to_integer(CNT_R(4 downto 4)))(to_integer(CNT_R(7 downto 5)))(to_integer(IDX(3 downto 0)));
                    else
                        MAT_TMP(to_integer(INDEX(CNT_WIDTH downto CNT_WIDTH)))(to_integer(INDEX(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))(to_integer(IDX(CNT_WIDTH - 1 downto 0))) 
                        <= DATA + MAT_TMP(to_integer(INDEX(CNT_WIDTH downto CNT_WIDTH)))(to_integer(INDEX(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))(to_integer(IDX(CNT_WIDTH - 1 downto 0)));
                        -- OLD
                        --MAT_TMP(to_integer(CNT_R(4 downto 4)))(to_integer(CNT_R(7 downto 5)))(to_integer(IDX(3 downto 0))) 
                        --<= DATA + MAT_TMP(to_integer(CNT_R(4 downto 4)))(to_integer(CNT_R(7 downto 5)))(to_integer(IDX(3 downto 0)));
                    end if;                    
                elsif EN_SUB = '1' then
                    MAT_TMP(to_integer(INDEX(CNT_WIDTH downto CNT_WIDTH)))(to_integer(INDEX(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))(to_integer(IDX(CNT_WIDTH - 1 downto 0))) 
                    <= MAT_TMP(to_integer(INDEX(CNT_WIDTH downto CNT_WIDTH)))(to_integer(INDEX(CNT_WIDTH + ROW_WIDTH downto CNT_WIDTH + 1)))(to_integer(IDX(CNT_WIDTH - 1 downto 0))) - DATA;
                    -- OLD
                    --MAT_TMP(to_integer(CNT_R(4 downto 4)))(to_integer(CNT_R(7 downto 5)))(to_integer(CNT_R(3 downto 0)))
                    --<= MAT_TMP(to_integer(CNT_R(4 downto 4)))(to_integer(CNT_R(7 downto 5)))(to_integer(CNT_R(3 downto 0))) - DATA;
                end if;
            end if;
        end if;
    end process;

end MATRIX_ACC_BODY;
