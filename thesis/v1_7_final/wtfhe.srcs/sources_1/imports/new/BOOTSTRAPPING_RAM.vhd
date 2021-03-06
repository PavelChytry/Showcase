library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- Bootstrapping with internal BlockRAM
entity BOOTSTRAPPING_RAM is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        START : in std_logic;
        RAM_WE : in std_logic; -- WE for internal BRAM
        TLWE_IN : in TLWE;
        RAM_DATA : in UNSIGNED(DATA_WIDTH - 1 DOWNTO 0); -- input to BRAM
        RAM_WE_ADDR : in UNSIGNED(ADDR_WIDTH - 1 DOWNTO 0); -- BRAM address
        TLWE_OUT : out TLWE;
        DONE : out std_logic
    );
end entity BOOTSTRAPPING_RAM;

architecture BOOTSTRAPPING_RAM_BODY of BOOTSTRAPPING_RAM is

    component blk_mem_gen_0 IS
    port (
       CLKA : in std_logic;
       ENA : in std_logic;
       WEA : in std_logic_vector(0 DOWNTO 0);
       ADDRA : in std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0);
       DINA : in std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
       DOUTA : out std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
    end component;
    
    component EXTERNAL_PRODUCT is
    port (
        CLK, RST, START : in std_logic;
        T_MATRIX : in TORUS_MATRIX;
        T_POLY_IN : in TORUS_POLYS;
        T_POLY_OUT : out TORUS_POLYS;
        DONE : out std_logic
    );
    end component;
	
	component EXTENDED_COUNTER is
	port (
		CLK : in std_logic;
		RST : in std_logic;
		CE : in std_logic;
		SET : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(ADDR_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
    end component;

    component LATCH is
	port (
		CLK, RST, A : in std_logic;
		Y : out std_logic
	);
    end component;

    component TLWE_ROUNDING is
    port (
        CLK : in std_logic;
        T_IN : in TLWE;
        T_OUT : out TLWE_ROUND
    );
    end component;

    component MATRIX_ACC is
    port (
        CLK, RST, EN, EN_EXP, EN_SUB : in std_logic;
        INDEX : UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        EXP : in UNSIGNED(NU downto 0);
        MAT_OUT : out TORUS_MATRIX
    );
    end component;

    component POLY_ADD is
     port (
		CLK : in std_logic;
		A, B : in TORUS_POLYS;
		Y : out TORUS_POLYS
	);
    end component;

    component POLY_EXP is
    port (
        CLK, RST, EN : in std_logic;
        CNT_R : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        EXP : in UNSIGNED(NU downto 0);
        P_OUT : out TORUS_POLYS
    );
    end component;

    component POLY_MPX is
    port (
		A, B : in TORUS_POLYS;
		SEL : in std_logic;
		Y : out TORUS_POLYS
	);
    end component;

    component POLY_REG is
    port (
		CLK, WE, RST : in std_logic;
		A : in TORUS_POLYS;
		Y : out TORUS_POLYS
	);
    end component;
	
	component ADDR_REG is
    port (
        CLK, RST, CE, DIR, PASS : in std_logic; -- DIR 1: inc, DIR 0: dec
        SET : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        PASSTHROUGH : in UNSIGNED(ADDR_WIDTH - 1 downto 0) := to_unsigned(0, ADDR_WIDTH);
        Y : out UNSIGNED(ADDR_WIDTH - 1 downto 0)
    );
    end component;
    
    component SAMPLE_EXTRACT is
    port (
        P_REG_OUT : in TORUS_POLYS;
        TLWE_OUT : out TLWE
    );
    end component;


    signal CNT_RST_MAIN, CNT_RST_DIM, CNT_RST_MAT, CNT_RST_COEFF, CNT_CE_MAIN, CNT_CE_DIM, CNT_CE_MAT, CNT_CE_COEFF, CNT_ZERO_MAIN, CNT_ZERO_DIM, CNT_ZERO_MAT, CNT_ZERO_COEFF,
    RAM_EN, POLY_LOAD, POLY_WE, POLY_EN, MAT_RST, MAT_EN, MAT_EXP, MAT_SUB, EXT_PROD_START, EXT_PROD_DONE, RAM_ADDR_ZERO, ADDR_REG_RST, ADDR_CE, ADDR_PASS : std_logic;
    
    signal RAM_ADDR, RAM_ADDR_NEW, RAM_ADDR_SET : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    
    signal RAM_DOUT : std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal P_EXP, P_REG_IN, P_REG_OUT, P_EX_PROD_OUT, P_ADD_OUT, P_REG_DELAY : TORUS_POLYS;
    
    signal MAT : TORUS_MATRIX;
    
    signal TLWE_R : TLWE_ROUND;
    
    signal CUR_EXP : UNSIGNED(NU downto 0);
    
    signal CNT_R_MAIN, CNT_R_DIM, CNT_R_MAT, CNT_R_COEFF, CNT_DATA : UNSIGNED(ADDR_WIDTH - 1 downto 0) := to_unsigned(0, ADDR_WIDTH);
    
    type T_STATE is (IDLE, DELAY_1, DELAY_2, S_POLY_EXP, SETUP, DELAY_3, DELAY_4, S_MAT_EXP, DELAY_5, DELAY_6, S_MAT_SUB, S_EXT_PROD, DELAY_7, FINAL,
    DELAY);
	signal STATE, NEXT_STATE : T_STATE;
	
	constant C_DIM : integer := DIM / 2 - 1; -- number of blind rotate loops
	constant C_MAT : integer := 2; -- number of matrices in each loop of blind rotate
	constant C_COEFF : integer := 2 * (K + 1) * L * N - 1; -- number of coefficients in each matrix
begin
    -- sample extract
    extract : SAMPLE_EXTRACT port map (P_REG_OUT => P_REG_OUT, TLWE_OUT => TLWE_OUT);
    
    -- BlockRAM instantiation
    ram: blk_mem_gen_0 port map (CLKA => CLK, ENA => RAM_EN, WEA(0) => RAM_WE, ADDRA => std_logic_vector(RAM_ADDR), DINA => std_logic_vector(RAM_DATA), DOUTA => RAM_DOUT);
    
    -- all counters
    cnt_main : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_MAIN, CE => CNT_CE_MAIN, SET => CNT_DATA, CNT_R => CNT_R_MAIN, ZERO => CNT_ZERO_MAIN);
    cnt_dim : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_DIM, CE => CNT_CE_DIM, SET => to_unsigned(C_DIM, ADDR_WIDTH), CNT_R => CNT_R_DIM, ZERO => CNT_ZERO_DIM);
    cnt_matrix : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_MAT, CE => CNT_CE_MAT, SET => to_unsigned(C_MAT, ADDR_WIDTH), CNT_R => CNT_R_MAT, ZERO => CNT_ZERO_MAT);
    cnt_coeff : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_COEFF, CE => CNT_CE_COEFF, SET => to_unsigned(C_COEFF, ADDR_WIDTH), CNT_R => CNT_R_COEFF, ZERO => CNT_ZERO_COEFF);
    
    -- 
    rounding : TLWE_ROUNDING port map (CLK => CLK, T_IN => TLWE_IN, T_OUT => TLWE_R);
    
    -- TRLWE operations
    poly_exb_b : POLY_EXP port map (CLK => CLK, RST => RST, EN => POLY_EN, CNT_R => CNT_R_MAIN, DATA => unsigned(RAM_DOUT(TAU - 1 downto 0)), EXP => TLWE_R(DIM), P_OUT => P_EXP);
    p_mpx : POLY_MPX port map (A => P_EXP, B => P_ADD_OUT, SEL => POLY_LOAD, Y => P_REG_IN);
    p_reg : POLY_REG port map (CLK => CLK, RST => RST, WE => POLY_WE, A => P_REG_IN, Y => P_REG_OUT);
    p_add : POLY_ADD port map (CLK => CLK, A => P_REG_DELAY--P_REG_OUT
    , B => P_EX_PROD_OUT, Y => P_ADD_OUT);

    ex_prod : EXTERNAL_PRODUCT port map (CLK => CLK, RST => RST, START => EXT_PROD_START, T_MATRIX => MAT, T_POLY_IN => P_REG_DELAY--P_REG_OUT
    , T_POLY_OUT => P_EX_PROD_OUT, DONE => EXT_PROD_DONE);
    
    -- TRGSW storage
    mat_acc : MATRIX_ACC port map (CLK => CLK, RST => MAT_RST, EN => MAT_EN, EN_EXP => MAT_EXP, EN_SUB => MAT_SUB, INDEX => CNT_R_COEFF, DATA => unsigned(RAM_DOUT(TAU - 1 downto 0)), EXP => CUR_EXP, MAT_OUT => MAT);
    
    -- BRAM 
    a_reg : ADDR_REG port map (CLK => CLK, RST => ADDR_REG_RST, CE => ADDR_CE, DIR => '0', PASS => ADDR_PASS, SET => RAM_ADDR_SET, PASSTHROUGH => unsigned(RAM_WE_ADDR), Y => RAM_ADDR);
    
    -- controller
    process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= IDLE;
			else
				STATE <= NEXT_STATE;
			end if;
			P_REG_DELAY <= P_REG_OUT;
		end if;
	end process;
	
	-- zero Address detection to prevent overflow
	process (RAM_ADDR)
	begin
	   if RAM_ADDR = (RAM_ADDR'range => '0') then
            RAM_ADDR_ZERO <= '1';
        else
            RAM_ADDR_ZERO <= '0';
        end if;
    end process;
    
	-- transition function	
	process (STATE, START, EXT_PROD_DONE, CNT_ZERO_MAIN, CNT_ZERO_DIM, CNT_ZERO_MAT, CNT_ZERO_COEFF)
	begin
	   NEXT_STATE <= STATE;
	   
	   case STATE is
	       when IDLE => -- wait for start, init counter to reading TRLWE Sample
	           if START = '1' then
	               NEXT_STATE <= DELAY_1;
	           end if;
	       when DELAY_1 => NEXT_STATE <= DELAY_2; -- two delay cycles for BRAM
	       when DELAY_2 => NEXT_STATE <= S_POLY_EXP;
	       when S_POLY_EXP => -- ACC = X^-b * P_IN
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= SETUP;
	           end if;
	       when SETUP => NEXT_STATE <= DELAY_3; -- init counters to reading 3 TRGSW Samples 
	       when DELAY_3 => NEXT_STATE <= DELAY_4; -- two delay cycles for BRAM
	       when DELAY_4 => NEXT_STATE <= S_MAT_EXP;
	       when S_MAT_EXP => -- MAT = X^(ai + a(i-1)) * BK(i-2) + X^a(i-1) * BK(i-1) + X^ai * BKi
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= DELAY_5;
	           end if;
	       when DELAY_5 => NEXT_STATE <= DELAY_6; -- two delay cycles for BRAM
	       when DELAY_6 => NEXT_STATE <= S_MAT_SUB;
	       when S_MAT_SUB => -- MAT = MAT - BK(i-2) - BK(i-1) - BKi
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= DELAY;
	           end if;
	       when DELAY => NEXT_STATE <= S_EXT_PROD;
	       when S_EXT_PROD => -- calc external product
	           if EXT_PROD_DONE = '1' then
	               if CNT_ZERO_DIM = '1' then -- blind rotate loop done detection
	                   NEXT_STATE <= FINAL;
	               else
	                   NEXT_STATE <= DELAY_7;
	               end if;
	           end if;
	       when DELAY_7 => NEXT_STATE <= SETUP;
	       when FINAL => NEXT_STATE <= IDLE;
	   end case;
	end process;
			
	--output function
	process (STATE, START, EXT_PROD_DONE, RAM_WE, CNT_ZERO_MAIN, CNT_ZERO_DIM, CNT_ZERO_MAT, CNT_ZERO_COEFF, CNT_R_MAT, CNT_R_DIM, RAM_ADDR_ZERO)
	begin
	   
	   ADDR_CE <= '0';
	   ADDR_PASS <= '0';
	   ADDR_REG_RST <= '0';
	   CNT_RST_MAIN <= '0';
	   CNT_RST_DIM <= '0';
	   CNT_RST_MAT <= '0';
	   CNT_RST_COEFF <= '0';
	   CNT_CE_MAIN <= '0';
	   CNT_CE_DIM <= '0';
	   CNT_CE_MAT <= '0';
	   CNT_CE_COEFF <= '0';
	   CNT_DATA <= (others => '0');
	   CUR_EXP <= (others => '0');
	   EXT_PROD_START <= '0';
	   DONE <= '0';
	   POLY_EN <= '0';
	   POLY_LOAD <= '0';
	   POLY_WE <= '0';
	   MAT_EN <= '0';
	   MAT_EXP <= '0';
	   MAT_SUB <= '0';
	   MAT_RST <= '0';
	   RAM_ADDR_SET <= (others => '0');
	   RAM_EN <= '0';
	   
	   case STATE is
	       when IDLE => -- wait for start, init counter to reading TRLWE Sample
               RAM_EN <= RAM_WE;
               ADDR_PASS <= '1';
	           if START = '1' then
					CNT_RST_MAIN <= '1';
					CNT_DATA <= to_unsigned((K + 1) * N - 1, ADDR_WIDTH);
					ADDR_REG_RST <= '1';
			        RAM_ADDR_SET <= to_unsigned(POLY_START, ADDR_WIDTH);
                    ADDR_PASS <= '0';
	           end if;
	       when DELAY_1 => -- two delay cycles for BRAM
	           CNT_RST_DIM <= '1';
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when DELAY_2 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when S_POLY_EXP => -- ACC = X^-b * P_IN
	           if CNT_ZERO_MAIN = '1' then
	               POLY_WE <= '1';
	               POLY_LOAD <= '1';
	           else
	               ADDR_CE <= '1';
	               CNT_CE_MAIN <= '1';
	               RAM_EN <= '1';
	               POLY_EN <= '1';
	           end if;
	       when SETUP => -- init counters to reading 3 TRGSW Samples 
	           MAT_RST <= '1';
	           CNT_RST_MAIN <= '1';
	           CNT_DATA <= to_unsigned(3 * (K + 1) * (K + 1) * L * N - 1, ADDR_WIDTH); -- 3x matrices
	           CNT_RST_MAT <= '1';
	           CNT_RST_COEFF <= '1';
	           ADDR_REG_RST <= '1';
               RAM_ADDR_SET <= to_unsigned(ADDR_ARRAY(to_integer(CNT_R_DIM)), ADDR_WIDTH);
	       when DELAY_3 => -- two delay cycles for BRAM
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when DELAY_4 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when S_MAT_EXP => -- MAT = X^(ai + a(i-1)) * BK(i-2) + X^a(i-1) * BK(i-1) + X^ai * BKi
	           if CNT_ZERO_MAIN = '1' then -- Exponentiation done, go to subtraction
	               RAM_EN <= '1';
	               CNT_RST_MAIN <= '1';
	               CNT_DATA <= to_unsigned(3 * (K + 1) * (K + 1) * L * N - 1, ADDR_WIDTH); -- 3x matrices
	               CNT_RST_MAT <= '1';
	               CNT_RST_COEFF <= '1';
	               ADDR_REG_RST <= '1';
                   RAM_ADDR_SET <= to_unsigned(ADDR_ARRAY(to_integer(CNT_R_DIM)), ADDR_WIDTH);
	           else
	               case CNT_R_MAT(1 downto 0) is -- calc TLWE exponents
	                   when "00" => CUR_EXP <= TLWE_R(2 * (DIM / 2 - 1 - to_integer(CNT_R_DIM))) + TLWE_R(2 * (DIM / 2 - 1 - to_integer(CNT_R_DIM)) + 1);
	                   when "01" => CUR_EXP <= TLWE_R(2 * (DIM / 2 - 1 - to_integer(CNT_R_DIM)));
	                   when "10" => CUR_EXP <= TLWE_R(2 * (DIM / 2 - 1 - to_integer(CNT_R_DIM)) + 1);
	                   when others => CUR_EXP <= (others => '0');
	               end case;
	               if CNT_ZERO_COEFF = '1' then -- one TRGSW Sample done
	                   CNT_CE_MAT <= '1';
	                   CNT_RST_COEFF <= '1';
	               else
	                   if RAM_ADDR_ZERO = '0' then -- address overflow prevention
	                       ADDR_CE <= '1';
	                   end if;
	                   CNT_CE_COEFF <= '1';
	                   CNT_CE_MAIN <= '1';
	                   RAM_EN <= '1';
	                   MAT_EXP <= '1';
	                   MAT_EN <= '1';
	               end if;
	           end if;
	       when DELAY_5 => -- two delay cycles for BRAM
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when DELAY_6 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when S_MAT_SUB => -- MAT = MAT - BK(i-2) - BK(i-1) - BKi
	           if CNT_ZERO_MAIN = '1' then -- subtraction done, go to external product
	               --EXT_PROD_START <= '1';
	           else
	               if CNT_ZERO_COEFF = '1' then -- one TRGSW Sample done
	                   CNT_CE_MAT <= '1';
	                   CNT_RST_COEFF <= '1';
	               else
	                   if RAM_ADDR_ZERO = '0' then -- address overflow prevention
	                       ADDR_CE <= '1';
	                   end if;
	                   CNT_CE_COEFF <= '1';
	                   CNT_CE_MAIN <= '1';
	                   RAM_EN <= '1';
	                   MAT_SUB <= '1';
	                   MAT_EN <= '1';
	               end if;
	           end if;
	       when DELAY => -- delay for pipeline stages
	           EXT_PROD_START <= '1';
	       when S_EXT_PROD => -- calc external product
	           if EXT_PROD_DONE = '1' then
	               POLY_WE <= '1';
	               if CNT_ZERO_DIM = '0' then -- blind rotate loop done detection
	                   CNT_CE_DIM <= '1';
	               end if;
	           end if;
	       when DELAY_7 => NULL; -- delay for pipeline stages
	       when FINAL => 
	           DONE <= '1';
	   end case;	
	end process;
	
end BOOTSTRAPPING_RAM_BODY;
