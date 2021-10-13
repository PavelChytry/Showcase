library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

-- Bootstrapping with internal BlockRAM
-- vector widths are constant bcs vivado is dumb
entity BOOTSTRAPPING_ARM is
    port (
        CLK : in std_logic;
        HW_RST : in std_logic;
        --START : in std_logic;
        CONTROL : in std_logic_vector(1 downto 0);
        DOUTB : in std_logic_vector(31 DOWNTO 0); -- input from BRAM -- DATA_WIDTH
        ENB : out std_logic;
        WEB : out std_logic_vector(3 DOWNTO 0);
        ADDRB : out std_logic_vector(31 DOWNTO 0) := (others => '0'); -- BRAM adress -- ADDR_WIDTH
        DINB : out std_logic_vector(31 DOWNTO 0) := (others => '0'); -- output to BRAM -- DATA_WIDTH
        LED : out std_logic_vector(7 downto 0);
        DONE : out std_logic_vector(0 downto 0)
    );
end entity BOOTSTRAPPING_ARM;

architecture BOOTSTRAPPING_ARM_BODY of BOOTSTRAPPING_ARM is
    
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
        CLK, RST, CE, DIR : in std_logic; -- DIR 1: inc, DIR 0: dec
        SET : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        --PASSTHROUGH : in UNSIGNED(ADDR_WIDTH - 1 downto 0) := to_unsigned(0, ADDR_WIDTH);
        Y : out UNSIGNED(ADDR_WIDTH - 1 downto 0)
    );
    end component;
    
    component SAMPLE_EXTRACT is
    port (
        P_REG_OUT : in TORUS_POLYS;
        TLWE_OUT : out TLWE
    );
    end component;

    component TLWE_REG is
    port (
        CLK, RST, WE : in std_logic;
        INDEX : in UNSIGNED(ADDR_WIDTH - 1 downto 0);
        DATA : in UNSIGNED(TAU - 1 downto 0);
        TLWE_OUT : out TLWE
    );
    end component;

    --signal CNT_RST_MAIN, CNT_RST_DIM, CNT_RST_MAT, CNT_RST_COEFF, CNT_CE_MAIN, CNT_CE_DIM, CNT_CE_MAT, CNT_CE_COEFF, CNT_ZERO_MAIN, CNT_ZERO_DIM, CNT_ZERO_MAT, CNT_ZERO_COEFF,
    --RAM_EN, POLY_LOAD, POLY_WE, POLY_EN, MAT_RST, MAT_EN, MAT_EXP, MAT_SUB, EXT_PROD_START, EXT_PROD_DONE, RAM_ADDR_ZERO, ADDR_REG_RST, ADDR_CE, ADDR_PASS : std_logic;
    
    signal CNT_RST_MAIN, CNT_RST_DIM, CNT_RST_MAT, CNT_RST_COEFF, CNT_CE_MAIN, CNT_CE_DIM, CNT_CE_MAT, CNT_CE_COEFF, CNT_ZERO_MAIN, CNT_ZERO_DIM, CNT_ZERO_MAT, CNT_ZERO_COEFF,
    POLY_LOAD, POLY_WE, POLY_EN, MAT_RST, MAT_EN, MAT_EXP, MAT_SUB, EXT_PROD_START, EXT_PROD_DONE, RAM_ADDR_ZERO, ADDR_REG_RST, ADDR_CE, TLWE_WE, START, RST : std_logic;
    
    --signal RAM_ADDR, RAM_ADDR_NEW, RAM_ADDR_SET : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    signal RAM_ADDR : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    signal RAM_ADDR_SET : UNSIGNED(ADDR_WIDTH - 1 downto 0);
    
    --signal RAM_DOUT : std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal P_EXP, P_REG_IN, P_REG_OUT, P_EX_PROD_OUT, P_ADD_OUT, P_REG_DELAY : TORUS_POLYS;
    
    signal MAT : TORUS_MATRIX;
    
    signal TLWE_IN, TLWE_OUT : TLWE := (others => to_unsigned(0, TAU)); -- delet this
    
    signal TLWE_R : TLWE_ROUND;
    
    signal CUR_EXP : UNSIGNED(NU downto 0);
    
    signal CNT_R_MAIN, CNT_R_DIM, CNT_R_MAT, CNT_R_COEFF, CNT_DATA : UNSIGNED(ADDR_WIDTH - 1 downto 0) := to_unsigned(0, ADDR_WIDTH);
    
    --type T_STATE is (IDLE, DELAY_1, DELAY_2, S_POLY_EXP, SETUP, DELAY_3, DELAY_4, S_MAT_EXP, DELAY_5, DELAY_6, S_MAT_SUB, S_EXT_PROD, DELAY_7, FINAL, DELAY);
	type T_STATE is (IDLE, TLWE_LOAD_DELAY_1, TLWE_LOAD_DELAY_2, S_TLWE_LOAD, POLY_EXP_DELAY_1, POLY_EXP_DELAY_2, S_POLY_EXP, MAIN_LOOP, MAT_EXP_DELAY_1, MAT_EXP_DELAY_2, S_MAT_EXP, MAT_SUB_DELAY_1, MAT_SUB_DELAY_2, S_MAT_SUB, EXT_PROD_PRE_DELAY, S_EXT_PROD, EXT_PROD_POST_DELAY, TLWE_SAVE_DELAY, S_TLWE_SAVE, FINAL);
	signal STATE, NEXT_STATE : T_STATE;
	
	constant C_DIM : integer := DIM / 2 - 1; -- number of blind rotate loops
	constant C_MAT : integer := 2; -- number of matrices in each loop of blind rotate
	constant C_COEFF : integer := 2 * (K + 1) * L * N - 1; -- number of coefficients in each matrix
	
begin

    START <= CONTROL(1);
    RST <= CONTROL(0) or HW_RST;

    -- sample extract
    extract : SAMPLE_EXTRACT port map (P_REG_OUT => P_REG_OUT, TLWE_OUT => TLWE_OUT);
    
    -- all counters
    cnt_main : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_MAIN, CE => CNT_CE_MAIN, SET => CNT_DATA, CNT_R => CNT_R_MAIN, ZERO => CNT_ZERO_MAIN);
    cnt_dim : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_DIM, CE => CNT_CE_DIM, SET => to_unsigned(C_DIM, ADDR_WIDTH), CNT_R => CNT_R_DIM, ZERO => CNT_ZERO_DIM);
    cnt_matrix : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_MAT, CE => CNT_CE_MAT, SET => to_unsigned(C_MAT, ADDR_WIDTH), CNT_R => CNT_R_MAT, ZERO => CNT_ZERO_MAT);
    cnt_coeff : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_RST_COEFF, CE => CNT_CE_COEFF, SET => to_unsigned(C_COEFF, ADDR_WIDTH), CNT_R => CNT_R_COEFF, ZERO => CNT_ZERO_COEFF);
    
    -- 
    rounding : TLWE_ROUNDING port map (CLK => CLK, T_IN => TLWE_IN, T_OUT => TLWE_R);
    
    -- TLWE operations
    t_reg : TLWE_REG port map (CLK => CLK, RST => RST, WE => TLWE_WE, INDEX => CNT_R_MAIN, DATA => unsigned(DOUTB(TAU - 1 downto 0)), TLWE_OUT => TLWE_IN);
    
    -- TRLWE operations
    poly_exb_b : POLY_EXP port map (CLK => CLK, RST => RST, EN => POLY_EN, CNT_R => CNT_R_MAIN, DATA => unsigned(DOUTB(TAU - 1 downto 0)), EXP => TLWE_R(DIM), P_OUT => P_EXP);
    p_mpx : POLY_MPX port map (A => P_EXP, B => P_ADD_OUT, SEL => POLY_LOAD, Y => P_REG_IN);
    p_reg : POLY_REG port map (CLK => CLK, RST => RST, WE => POLY_WE, A => P_REG_IN, Y => P_REG_OUT);
    p_add : POLY_ADD port map (CLK => CLK, A => P_REG_DELAY--P_REG_OUT
    , B => P_EX_PROD_OUT, Y => P_ADD_OUT);

    ex_prod : EXTERNAL_PRODUCT port map (CLK => CLK, RST => RST, START => EXT_PROD_START, T_MATRIX => MAT, T_POLY_IN => P_REG_DELAY--P_REG_OUT
    , T_POLY_OUT => P_EX_PROD_OUT, DONE => EXT_PROD_DONE);
    --EXT_PROD_DONE <= '1';
    
    -- TRGSW storage
    mat_acc : MATRIX_ACC port map (CLK => CLK, RST => MAT_RST, EN => MAT_EN, EN_EXP => MAT_EXP, EN_SUB => MAT_SUB, INDEX => CNT_R_COEFF, DATA => unsigned(DOUTB(TAU - 1 downto 0)), EXP => CUR_EXP, MAT_OUT => MAT);
    
    -- BRAM
    a_reg : ADDR_REG port map (CLK => CLK, RST => ADDR_REG_RST, CE => ADDR_CE, DIR => '0', SET => RAM_ADDR_SET, Y => RAM_ADDR);
    ADDRB <= (31 downto ADDR_WIDTH + 2 => '0') & std_logic_vector(RAM_ADDR) & '0' & '0'; -- Address shift for arm
    --ADDRB <= (31 downto ADDR_WIDTH => '0') & std_logic_vector(RAM_ADDR); -- do not shift address for testbenches
    
    --testing
    --TLWE_OUT <= TLWE_IN;
    
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
	process (ADDRB)
	begin
	   if ADDRB = (ADDRB'range => '0') then
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
	               NEXT_STATE <= TLWE_LOAD_DELAY_1;
	           end if;
	       when TLWE_LOAD_DELAY_1 => NEXT_STATE <= TLWE_LOAD_DELAY_2; -- two delay cycles for BRAM
	       when TLWE_LOAD_DELAY_2 => NEXT_STATE <= S_TLWE_LOAD;
	       when S_TLWE_LOAD => -- load TLWE from BRAM
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= POLY_EXP_DELAY_1;
	           end if;
	       when POLY_EXP_DELAY_1 => NEXT_STATE <= POLY_EXP_DELAY_2; -- two delay cycles for BRAM
	       when POLY_EXP_DELAY_2 => NEXT_STATE <= S_POLY_EXP;
	       when S_POLY_EXP => -- ACC = X^-b * P_IN
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= MAIN_LOOP;
	           end if;
	       when MAIN_LOOP => NEXT_STATE <= MAT_EXP_DELAY_1; -- init counters to reading 3 TRGSW Samples 
	       when MAT_EXP_DELAY_1 => NEXT_STATE <= MAT_EXP_DELAY_2; -- two delay cycles for BRAM
	       when MAT_EXP_DELAY_2 => NEXT_STATE <= S_MAT_EXP;
	       when S_MAT_EXP => -- MAT = X^(ai + a(i-1)) * BK(i-2) + X^a(i-1) * BK(i-1) + X^ai * BKi
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= MAT_SUB_DELAY_1;
	           end if;
	       when MAT_SUB_DELAY_1 => NEXT_STATE <= MAT_SUB_DELAY_2; -- two delay cycles for BRAM
	       when MAT_SUB_DELAY_2 => NEXT_STATE <= S_MAT_SUB;
	       when S_MAT_SUB => -- MAT = MAT - BK(i-2) - BK(i-1) - BKi
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= EXT_PROD_PRE_DELAY;
	           end if;
	       when EXT_PROD_PRE_DELAY => NEXT_STATE <= S_EXT_PROD;
	       when S_EXT_PROD => -- calc external product
	           if EXT_PROD_DONE = '1' then
	               if CNT_ZERO_DIM = '1' then -- blind rotate loop done detection
	                   NEXT_STATE <= TLWE_SAVE_DELAY;
	               else
	                   NEXT_STATE <= EXT_PROD_POST_DELAY;
	               end if;
	           end if;
	       when EXT_PROD_POST_DELAY => NEXT_STATE <= MAIN_LOOP;
	       when TLWE_SAVE_DELAY => NEXT_STATE <= S_TLWE_SAVE;
	       when S_TLWE_SAVE =>
	           if CNT_ZERO_MAIN = '1' then
	               NEXT_STATE <= FINAL;
	           end if;
	       when FINAL => 
	           if START = '0' then
	               NEXT_STATE <= IDLE;
	           end if;
	   end case;
	end process;
			
	--output function
	process (STATE, START, RST, EXT_PROD_DONE, CNT_ZERO_MAIN, CNT_ZERO_DIM, CNT_ZERO_MAT, CNT_ZERO_COEFF, CNT_R_MAIN, CNT_R_MAT, CNT_R_DIM, RAM_ADDR_ZERO)
	begin
	   
	   ADDR_CE <= '0';
	   ADDR_REG_RST <= RST; --'0';
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
	   DINB <= (others => '0');
	   ENB <= '0';
	   EXT_PROD_START <= '0';
	   DONE(0) <= '0';
	   POLY_EN <= '0';
	   POLY_LOAD <= '0';
	   POLY_WE <= '0';
	   MAT_EN <= '0';
	   MAT_EXP <= '0';
	   MAT_SUB <= '0';
	   MAT_RST <= '0';
	   TLWE_WE <= '0';
	   RAM_ADDR_SET <= (others => '0');
	   WEB <= (others => '0');
	   LED <= (others => '0');
    
	   case STATE is
	       when IDLE =>
	           LED(0) <= '1';
	           if START = '1' then -- wait for start, init counter to reading TLWE Sample
					CNT_RST_MAIN <= '1';
					CNT_DATA <= to_unsigned(DIM, ADDR_WIDTH);
					ADDR_REG_RST <= '1';
			        RAM_ADDR_SET <= to_unsigned(TLWE_START, ADDR_WIDTH);
	           end if;
	       when TLWE_LOAD_DELAY_1 => -- two delay cycles for BRAM
               ENB <= '1';
	           ADDR_CE <= '1';
	       when TLWE_LOAD_DELAY_2 =>
               ENB <= '1';
	           ADDR_CE <= '1';
	       when S_TLWE_LOAD => -- read TRLWE Sample
	           LED(1) <= '1';
	           if CNT_ZERO_MAIN = '1' then
	               CNT_RST_MAIN <= '1';
	               CNT_DATA <= to_unsigned((K + 1) * N - 1, ADDR_WIDTH);
	               ADDR_REG_RST <= '1';
	               RAM_ADDR_SET <= to_unsigned(POLY_START, ADDR_WIDTH);
	           else
	               ADDR_CE <= '1';
	               CNT_CE_MAIN <= '1';
	               ENB <= '1';
	               TLWE_WE <= '1';
	           end if;
	       when POLY_EXP_DELAY_1 => -- two delay cycles for BRAM
	           CNT_RST_DIM <= '1';
               ENB <= '1';
	           ADDR_CE <= '1';
	       when POLY_EXP_DELAY_2 => 
               ENB <= '1';
	           ADDR_CE <= '1';
	       when S_POLY_EXP => -- ACC = X^-b * P_IN
	           LED(0) <= '1';
	           LED(1) <= '1';
	           if CNT_ZERO_MAIN = '1' then
	               POLY_WE <= '1';
	               POLY_LOAD <= '1';
	           else
	               ADDR_CE <= '1';
	               CNT_CE_MAIN <= '1';
	               ENB <= '1';
	               POLY_EN <= '1';
	           end if;
	       when MAIN_LOOP => -- init counters to reading 3 TRGSW Samples 
	           MAT_RST <= '1';
	           CNT_RST_MAIN <= '1';
	           CNT_DATA <= to_unsigned(3 * (K + 1) * (K + 1) * L * N - 1, ADDR_WIDTH); -- 3x matrices
	           CNT_RST_MAT <= '1';
	           CNT_RST_COEFF <= '1';
	           ADDR_REG_RST <= '1';
               RAM_ADDR_SET <= to_unsigned(ADDR_ARRAY(to_integer(CNT_R_DIM)), ADDR_WIDTH);
	       when MAT_EXP_DELAY_1 => -- two delay cycles for BRAM
               ENB <= '1';
	           ADDR_CE <= '1';
	       when MAT_EXP_DELAY_2 => 
               ENB <= '1';
	           ADDR_CE <= '1';
	       when S_MAT_EXP => -- MAT = X^(ai + a(i-1)) * BK(i-2) + X^a(i-1) * BK(i-1) + X^ai * BKi
	           LED(2) <= '1';
	           if CNT_ZERO_MAIN = '1' then -- Exponentiation done, go to subtraction
	               ENB <= '1';
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
	                   ENB <= '1';
	                   MAT_EXP <= '1';
	                   MAT_EN <= '1';
	               end if;
	           end if;
	       when MAT_SUB_DELAY_1 => -- two delay cycles for BRAM
               ENB <= '1';
	           ADDR_CE <= '1';
	       when MAT_SUB_DELAY_2 => 
               ENB <= '1';
	           ADDR_CE <= '1';
	       when S_MAT_SUB => -- MAT = MAT - BK(i-2) - BK(i-1) - BKi
	           LED(0) <= '1';
	           LED(2) <= '1';
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
	                   ENB <= '1';
	                   MAT_SUB <= '1';
	                   MAT_EN <= '1';
	               end if;
	           end if;
	       when EXT_PROD_PRE_DELAY => -- delay for pipeline stages
	           EXT_PROD_START <= '1';
	       when S_EXT_PROD => -- calc external product
	           LED(1) <= '1';
	           LED(2) <= '1';
	           if EXT_PROD_DONE = '1' then
	               POLY_WE <= '1';
	               if CNT_ZERO_DIM = '0' then -- blind rotate loop done detection
	                   CNT_CE_DIM <= '1';
	               else
	                   CNT_RST_MAIN <= '1';
	                   CNT_DATA <= to_unsigned(DIM, ADDR_WIDTH);
	               end if;
	           end if;
	       when EXT_PROD_POST_DELAY => NULL; -- delay for pipeline stages
	       when TLWE_SAVE_DELAY => -- init to TLWE write
	           ADDR_REG_RST <= '1';
	           RAM_ADDR_SET <= to_unsigned(TLWE_START, ADDR_WIDTH);
	       when S_TLWE_SAVE => -- write TLWE to BRAM
	           LED(0) <= '1';
	           LED(1) <= '1';
	           LED(2) <= '1';
	           if CNT_ZERO_MAIN = '1' then
	               NULL;
	           else
	               ENB <= '1';
	               WEB <= (others => '1');
	               ADDR_CE <= '1';
	               CNT_CE_MAIN <= '1';
	               DINB <= (DATA_WIDTH - 1 downto TAU => '0') & std_logic_vector(TLWE_OUT(to_integer(CNT_R_MAIN(CNT_WIDTH downto 0))));
	           end if;
	       when FINAL => 
	           DONE(0) <= '1';
	   end case;	
	end process;
	
end BOOTSTRAPPING_ARM_BODY;
