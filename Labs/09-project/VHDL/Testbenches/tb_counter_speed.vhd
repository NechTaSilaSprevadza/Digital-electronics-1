----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2021 13:45:11
-- Design Name: 
-- Module Name: tb_counter_speed - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_counter_speed is

end tb_counter_speed;
------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture Behavioral of tb_counter_speed is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 10;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    
    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_reset      : std_logic;
    signal s_en         : std_logic;
    signal s_hall       : std_logic;
    signal s_spd        : std_logic_vector(c_CNT_WIDTH - 1 downto 0):= "0000000000";
    signal s_cnt    : std_logic_vector(c_CNT_WIDTH - 1 downto 0):= "0000000000";
begin
    -- Connecting testbench signals with counter_speed entity
    uut_cnt : entity work.counter_speed
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            reset    => s_reset,
            en_i     => s_en,
            hall_i   => s_hall,
            spd_o    => s_spd,
            cnt_o    => s_cnt
        );
        
    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process 
    begin
        while now < 750 ns loop         
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD *4 ;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD *4;
        end loop;
        wait;
    end process p_clk_gen;
    
    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 12 ns;
        
        s_reset <= '1';
        wait for 73 ns;
        
        s_reset <= '0';
        wait for 70 ns;
        
        s_reset <= '1';
        wait for 73 ns;

        s_reset <= '0';
        wait;
    end process p_reset_gen;
    
    --------------------------------------------------------------------
    -- Hall effect sensor generation process
    --------------------------------------------------------------------
    p_hall_gen : process
    begin
        while now < 750 ns loop         
            s_hall <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_hall <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_hall_gen;  
    
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------    
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- Enable counting
        s_en   <= '1';
   
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus; 
end Behavioral;
