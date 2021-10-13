library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.CONST.ALL;
use std.textio.all;

entity TB_BOOTSTRAP is
--  Port ( );
end TB_BOOTSTRAP;

architecture TB_BOOTSTRAP_BODY of TB_BOOTSTRAP is

    component BOOTSTRAPPING_RAM is
    port (
        CLK, RST, START, RAM_WE : in std_logic;
        TLWE_IN : in TLWE;
        RAM_DATA : in UNSIGNED(DATA_WIDTH - 1 DOWNTO 0);
        RAM_WE_ADDR : in UNSIGNED(ADDR_WIDTH - 1 DOWNTO 0);
        TLWE_OUT : out TLWE;
        DONE : out std_logic
    );
    end component;

      --Inputs
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal START : std_logic := '0';
    signal RAM_WE : std_logic := '0';
    signal TLWE_IN : TLWE := (others => to_unsigned(0, TAU));
    signal RAM_DATA : UNSIGNED(DATA_WIDTH - 1 DOWNTO 0) := to_unsigned(0, DATA_WIDTH);
    signal RAM_WE_ADDR : UNSIGNED(ADDR_WIDTH - 1 DOWNTO 0) := to_unsigned(0, ADDR_WIDTH);
    signal TLWE_REF : TLWE := (others => to_unsigned(0, TAU));
       
    signal TLWE_OUT : TLWE;
    signal DONE : std_logic;
   
constant CLK_period : time := 10 ns;
   
begin

    uut: BOOTSTRAPPING_RAM port map (CLK => CLK, RST => RST, START => START, RAM_WE => RAM_WE, TLWE_IN => TLWE_IN, RAM_DATA => RAM_DATA, RAM_WE_ADDR => RAM_WE_ADDR, TLWE_OUT => TLWE_OUT, DONE => DONE);
    
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
 

    -- Stimulus process
    stim_proc: process
        type t_integer_array is array(integer range <>) of integer;
        file matrix_in    		: text;
        file tlwe_res           : text;
        variable row      		: line;
        variable hex            : std_logic_vector(31 downto 0);
    begin		
        RST <= '0';
        wait for CLK_period / 2;
        RST <= '1';
        wait for CLK_period;
        RST <= '0';
        --file_open(matrix_in, "C:\Users\DarkWave\Desktop\WTFHE\wtfhe-fpga\data\matrix_in_22.dat", read_mode);  
        file_open(matrix_in, "./../../../../../data/matrix_in_22.dat", read_mode);
    
        wait for CLK_period;
        -- input matrix
        for i_k in 0 to DIM * 3 / 2 - 1 loop
        for i_a in 0 to (K + 1) * L - 1 loop
            for i_c in 0 to K loop	
                if(not endfile(matrix_in)) then
                    readline(matrix_in, row);
                end if;		
                for i_b in 0 to N - 1 loop
                    hread(row, hex);
                    RAM_WE <= '1';
                    
                    if i_k < 10 then -- testing
                        RAM_DATA <= unsigned(hex);
                    else
                        RAM_DATA <= X"00000000";
                    end if;
                    wait for CLK_period;
                    RAM_WE_ADDR <= RAM_WE_ADDR + 1;
                end loop;
            end loop;
        end loop; 
        end loop;
        
        -- input polynoms
        for i_a in 0 to K loop	
            if(not endfile(matrix_in)) then
                readline(matrix_in, row);
            end if;		
            for i_b in 0 to N - 1 loop
                hread(row, hex);
                RAM_WE <= '1';
                RAM_DATA <= unsigned(hex);
                --RAM_DATA <= X"00000001";
                wait for CLK_period;
                RAM_WE_ADDR <= RAM_WE_ADDR + 1;
            end loop;
        end loop;
        
        -- input TLWE
        if(not endfile(matrix_in)) then
            readline(matrix_in, row);
        end if;
        for i_a in 0 to DIM loop
            hread(row, hex);
            TLWE_IN(i_a) <= unsigned(hex(TAU - 1 downto 0));
            --TLWE_IN(i_a) <= to_unsigned(0, TAU);
        end loop;
        --TLWE_IN(DIM) <= "11" & X"E9A6E";
        
        wait for CLK_period;
        RAM_WE <= '0';
        
        file_close(matrix_in);
        --file_open(tlwe_res, "C:\Users\DarkWave\Desktop\WTFHE\wtfhe-fpga\data\tlwe_out_22.dat", read_mode);     
        file_open(tlwe_res, "./../../../../../data/tlwe_out_22.dat", read_mode);  
        
        -- output TLWE
        if(not endfile(tlwe_res)) then
            readline(tlwe_res, row);
        end if;
        for i_a in 0 to DIM loop
            hread(row, hex);
            TLWE_REF(DIM - i_a) <= unsigned(hex(TAU - 1 downto 0));
        end loop;
        
        file_close(tlwe_res);
        wait for CLK_period;
              
        START <= '1';
        wait for CLK_period;
        START <= '0';
        RAM_WE_ADDR <= to_unsigned(0,ADDR_WIDTH);
        
        wait until DONE = '1';
        
        -- check result
        for i_a in 0 to NU - 1 loop
            assert TLWE_REF(i_a) = TLWE_OUT(i_a)
                report "fail tlwe"
                    severity error;
        end loop;
        
        wait for CLK_period * 100;
        wait for CLK_period / 2;
    
    end process;
    
end TB_BOOTSTRAP_BODY;
