library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;

entity BOOTSTRAPPING_RAM is
    port (
        CLK : in std_logic;
        RST : in std_logic;
        START : in std_logic;
        RAM_WE : in std_logic;
        TLWE_IN : in TLWE;
        RAM_DATA : in UNSIGNED(31 DOWNTO 0);
        RAM_WE_ADDR : in UNSIGNED(10 DOWNTO 0);
        TLWE_OUT : out TLWE_N;
        DONE : out std_logic
    );
end entity BOOTSTRAPPING_RAM;

architecture BOOTSTRAPPING_RAM_BODY of BOOTSTRAPPING_RAM is

    component blk_mem_gen_0 IS
    port (
       CLKA : in std_logic;
       ENA : in std_logic;
       WEA : in std_logic_vector(0 DOWNTO 0);
       ADDRA : in std_logic_vector(10 DOWNTO 0);
       DINA : in std_logic_vector(31 DOWNTO 0);
       DOUTA : out std_logic_vector(31 DOWNTO 0)
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
		SET : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		ZERO : out std_logic
	);
    end component;
    
    component EXTCOUNTER2 is
	port (
		CLK, RST, CE : in std_logic;
		DATA : in UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
		CNT_R : out UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
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
        T_IN : in TLWE;
        T_OUT : out TLWE_ROUND
    );
    end component;

    component MATRIX_ACC is
    port (
        CLK, RST, EN, EN_EXP, EN_SUB : in std_logic;
        CNT_R : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
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
        CNT_R : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
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
        SET : in UNSIGNED(10 downto 0);
        PASSTHROUGH : in UNSIGNED(10 downto 0) := to_unsigned(0, 11);
        Y : out UNSIGNED(10 downto 0)
    );
    end component;

    signal CNT_LOAD, CNT_CE, CNT_ZERO, CNT_LOAD2, CNT_CE2, CNT_ZERO2, RAM_EN, POLY_LOAD, POLY_WE, POLY_EN, MAT_RST, MAT_EN, MAT_EXP, MAT_SUB, EXT_PROD_START, EXT_PROD_DONE, ADDR_REG_RST, ADDR_CE, ADDR_PASS : std_logic;
    
    signal RAM_ADDR, RAM_ADDR_NEW, RAM_ADDR_SET : UNSIGNED(10 downto 0); -- this is wrong, address is not scaleable
    
    signal RAM_DOUT : std_logic_vector(31 downto 0); -- this is wrong, address is not scaleable
    
    signal P_EXP, P_REG_IN, P_REG_OUT, P_EX_PROD_OUT, P_ADD_OUT : TORUS_POLYS;
    
    signal MAT : TORUS_MATRIX;
    
    signal TLWE_R : TLWE_ROUND;
    
    signal CUR_EXP : UNSIGNED(NU downto 0);
    
    signal CNT_R, CNT_R2, CNT_DATA : UNSIGNED(CNT_UART_WIDTH - 1 downto 0) := to_unsigned(0, CNT_UART_WIDTH);
    signal CNT_RE, CNT_RE2 : UNSIGNED(CNT_UART_WIDTH - 1 downto 0);
    
    type T_STATE is (IDLE, DELAY_1, DELAY_2, S_POLY_EXP, SETUP, DELAY_3, DELAY_4, S_MAT_EXP, DELAY_5, DELAY_6, S_MAT_SUB, S_EXT_PROD, DELAY_7, FINAL);
	signal STATE, NEXT_STATE : T_STATE;
	
begin

    TLWE_OUT(0) <= P_REG_OUT(0)(0);
    TLWE_OUT(N) <= P_REG_OUT(1)(0);
    gen_out:
    for i_i in 1 to N - 1 generate
        TLWE_OUT(i_i) <= not(P_REG_OUT(0)(N - i_i)) + 1;
    end generate;
    
    ram: blk_mem_gen_0 port map (CLKA => CLK, ENA => RAM_EN, WEA(0) => RAM_WE, ADDRA => std_logic_vector(RAM_ADDR), DINA => std_logic_vector(RAM_DATA), DOUTA => RAM_DOUT);
    
    cnt : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_LOAD, CE => CNT_CE, SET => CNT_DATA, CNT_R => CNT_R, ZERO => CNT_ZERO);
    cntr2 : EXTENDED_COUNTER port map (CLK => CLK, RST => CNT_LOAD2, CE => CNT_CE2, SET => CNT_DATA, CNT_R => CNT_R2, ZERO => CNT_ZERO2);
    --cnt_ree : EXTCOUNTER2 port map (CLK => CLK, RST => CNT_LOAD, CE => CNT_CE, DATA => CNT_DATA, CNT_R => CNT_R, ZERO => CNT_ZERO);
    --cntr2_ree : EXTCOUNTER2 port map (CLK => CLK, RST => CNT_LOAD2, CE => CNT_CE2, DATA => CNT_DATA, CNT_R => CNT_R2, ZERO => CNT_ZERO2);

    rounding : TLWE_ROUNDING port map (T_IN => TLWE_IN, T_OUT => TLWE_R);
    
    poly_exb_b : POLY_EXP port map (CLK => CLK, RST => RST, EN => POLY_EN, CNT_R => CNT_R, DATA => unsigned(RAM_DOUT(TAU - 1 downto 0)), EXP => TLWE_R(DIM), P_OUT => P_EXP);
    p_mpx : POLY_MPX port map (A => P_EXP, B => P_ADD_OUT, SEL => POLY_LOAD, Y => P_REG_IN);
    p_reg : POLY_REG port map (CLK => CLK, RST => RST, WE => POLY_WE, A => P_REG_IN, Y => P_REG_OUT);
    p_add : POLY_ADD port map (CLK => CLK, A => P_REG_OUT, B => P_EX_PROD_OUT, Y => P_ADD_OUT);

    ex_prod : EXTERNAL_PRODUCT port map (CLK => CLK, RST => RST, START => EXT_PROD_START, T_MATRIX => MAT, T_POLY_IN => P_REG_OUT, T_POLY_OUT => P_EX_PROD_OUT, DONE => EXT_PROD_DONE);

    mat_acc : MATRIX_ACC port map (CLK => CLK, RST => MAT_RST, EN => MAT_EN, EN_EXP => MAT_EXP, EN_SUB => MAT_SUB, CNT_R => CNT_R, DATA => unsigned(RAM_DOUT(TAU - 1 downto 0)), EXP => CUR_EXP, MAT_OUT => MAT);
    
    a_reg : ADDR_REG port map (CLK => CLK, RST => ADDR_REG_RST, CE => ADDR_CE, DIR => '0', PASS => ADDR_PASS, SET => RAM_ADDR_SET, PASSTHROUGH => unsigned(RAM_WE_ADDR), Y => RAM_ADDR);
    
    process (CLK)
	begin
		if rising_edge(CLK) then
			if (RST = '1') then
				STATE <= IDLE;
			else
				STATE <= NEXT_STATE;
			end if;
		end if;
	end process;
		
	-- transition function	
	process (STATE, START, CNT_ZERO, EXT_PROD_DONE, CNT_ZERO2)
	begin
	   NEXT_STATE <= STATE;
	   
	   case STATE is
	       when IDLE =>
	           if START = '1' then
	               NEXT_STATE <= DELAY_1;
	           end if;
	       when DELAY_1 => NEXT_STATE <= DELAY_2;
	       when DELAY_2 => NEXT_STATE <= S_POLY_EXP;
	       when S_POLY_EXP =>
	           if CNT_ZERO = '1' then
	               NEXT_STATE <= SETUP;
	           end if;
	       when SETUP => NEXT_STATE <= DELAY_3;
	       when DELAY_3 => NEXT_STATE <= DELAY_4;
	       when DELAY_4 => NEXT_STATE <= S_MAT_EXP;
	       when S_MAT_EXP =>
	           if CNT_ZERO = '1' then
	               NEXT_STATE <= DELAY_5;
	           end if;
	       when DELAY_5 => NEXT_STATE <= DELAY_6;
	       when DELAY_6 => NEXT_STATE <= S_MAT_SUB;
	       when S_MAT_SUB =>
	           if CNT_ZERO = '1' then
	               NEXT_STATE <= S_EXT_PROD;
	           end if;
	       when S_EXT_PROD =>
	           if EXT_PROD_DONE = '1' then
	               if CNT_ZERO2 = '1' then
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
	process (STATE, START, CNT_ZERO, EXT_PROD_DONE, CNT_ZERO2, CNT_R, RAM_WE)
	begin
	   
	   ADDR_CE <= '0';
	   ADDR_PASS <= '0';
	   ADDR_REG_RST <= '0';
	   CNT_CE <= '0';
	   CNT_CE2 <= '0';
	   CNT_DATA <= (others => '0');
	   CNT_LOAD <= '0';
	   CNT_LOAD2 <= '0';
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
	       when IDLE => 
               RAM_EN <= RAM_WE;
               ADDR_PASS <= '1';
	           if START = '1' then
					CNT_LOAD <= '1';
					CNT_DATA <= to_unsigned(2 * N - 1, CNT_UART_WIDTH);
					ADDR_REG_RST <= '1'; -- TODO
			        RAM_ADDR_SET <= "110" & X"1F";
                    ADDR_PASS <= '0';
	           end if;
	       when DELAY_1 => 
	           CNT_LOAD2 <= '1';
	           CNT_DATA <= to_unsigned(1, CNT_UART_WIDTH);
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when DELAY_2 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when S_POLY_EXP =>
	           if CNT_ZERO = '1' then
	               POLY_WE <= '1';
	               POLY_LOAD <= '1';
	           else
	               ADDR_CE <= '1';
	               CNT_CE <= '1';
	               RAM_EN <= '1';
	               POLY_EN <= '1';
	           end if;
	       when SETUP => 
	           MAT_RST <= '1';
	           RAM_EN <= '1';
	           CNT_LOAD <= '1';
	           CNT_DATA <= to_unsigned(3 * 2 * (K + 1) * L * N - 1, CNT_UART_WIDTH);
	           ADDR_REG_RST <= '1';
	           if CNT_ZERO2 = '1' then --not scaleable with DIM
	               RAM_ADDR_SET <= "101" & X"FF";
	           else
	               RAM_ADDR_SET <= "010" & X"FF";
	           end if;
	       when DELAY_3 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when DELAY_4 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when S_MAT_EXP =>
	           if CNT_ZERO = '1' then
	               RAM_EN <= '1';
	               CNT_LOAD <= '1';
	               CNT_DATA <= to_unsigned(3 * 2 * (K + 1) * L * N - 1, CNT_UART_WIDTH);
	               ADDR_REG_RST <= '1';
	               if CNT_ZERO2 = '1' then --not scaleable with DIM
	                   RAM_ADDR_SET <= "101" & X"FF";
	               else
	                   RAM_ADDR_SET <= "010" & X"FF";
	               end if;
	           else
	               ADDR_CE <= '1';
	               if CNT_ZERO2 = '1' then --not scaleable with DIM
	                   case CNT_R(10 downto 8) is -- not scaleable
	                       when "000" => CUR_EXP <= TLWE_R(2) + TLWE_R(3);
	                       when "001" => CUR_EXP <= TLWE_R(2);
	                       when "010" => CUR_EXP <= TLWE_R(3);
	                       when others => CUR_EXP <= (others => '0');
	                   end case;
	               else
	                   case CNT_R(10 downto 8) is -- not scaleable
	                       when "000" => CUR_EXP <= TLWE_R(0) + TLWE_R(1);
	                       when "001" => CUR_EXP <= TLWE_R(0);
	                       when "010" => CUR_EXP <= TLWE_R(1);
	                       when others => CUR_EXP <= (others => '0');
	                   end case;
	               end if;
	               CNT_CE <= '1';
	               RAM_EN <= '1';
	               MAT_EXP <= '1';
	               MAT_EN <= '1';
	           end if;
	       when DELAY_5 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when DELAY_6 => 
               RAM_EN <= '1';
	           ADDR_CE <= '1';
	       when S_MAT_SUB =>
	           if CNT_ZERO = '1' then
	               EXT_PROD_START <= '1';
	           else
	               ADDR_CE <= '1';
	               CNT_CE <= '1';
	               RAM_EN <= '1';
	               MAT_SUB <= '1';
	               MAT_EN <= '1';
	           end if;
	       when S_EXT_PROD =>
	           if EXT_PROD_DONE = '1' then
	               POLY_WE <= '1';
	               if CNT_ZERO2 = '0' then
	                   CNT_CE2 <= '1';
	               end if;
	           end if;
	       when DELAY_7 => NULL;
	       when FINAL => 
	           DONE <= '1';
	   end case;	
	end process;
	
end BOOTSTRAPPING_RAM_BODY;
