library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_driver_7seg_4digits is

end entity tb_driver_7seg_4digits;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_driver_7seg_4digits is
   
    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal reset     : std_logic;
    signal s_data_i_0 : std_logic_vector(4 - 1 downto 0);
    signal s_data_i_1 : std_logic_vector(4 - 1 downto 0);
    signal s_data_i_2 : std_logic_vector(4 - 1 downto 0);
    signal s_data_i_3 : std_logic_vector(4 - 1 downto 0);
    signal s_dp_i    : std_logic_vector(4 - 1 downto 0);
    signal s_dp_o    : std_logic;
    signal s_seg_o   : std_logic_vector(7 - 1 downto 0);
    signal s_dig_o   : std_logic_vector(4 - 1 downto 0);
    signal s_dig_c   : std_logic;
            
begin
    -- Connecting testbench signals with driver_7seg_4digits entity
   uut_driver_7seg : entity work.driver_7seg_4digits
       port map(
       
       clk       => s_clk_100MHz,
       reset     => reset, 
       data_i_0   => s_data_i_0,
       data_i_1   => s_data_i_1,
       data_i_2   => s_data_i_2,
       data_i_3   => s_data_i_3,
       dp_i   => s_dp_i,
       
       dp_o   => s_dp_o,
       seg_o   => s_seg_o,
       dig_o   => s_dig_o,
       dig_c   => s_dig_c
       
       );
       
    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 750 ns loop         -- 75 periods of 100MHz clock    
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        reset <= '0';
        wait for 12 ns;
        
        reset <= '1';
        wait for 53 ns;
        
        reset <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
       report "Stimulus process started" severity note;
       
       s_data_i_3 <= "0011";
       s_data_i_2 <= "0001";
       s_data_i_1 <= "0100";
       s_data_i_0 <= "0010";
       s_dp_i    <= "0111";
       
       wait for 600ns;
       
       s_data_i_3 <= "0000";
       s_data_i_2 <= "0001";
       s_data_i_1 <= "0000";
       s_data_i_0 <= "0001";
       
       report "Stimulus process finished" severity note;
       wait;
    end process p_stimulus;   
end architecture testbench;
