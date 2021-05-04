----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2021 20:37:47
-- Design Name: 
-- Module Name: tb_signal_detect - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_signal_detect is
--  Port ( );
end tb_signal_detect;

architecture Behavioral of tb_signal_detect is
    signal s_input      : std_logic;
    signal s_clear      : std_logic;
    signal s_reset      : std_logic;
    signal s_clk      : std_logic;
    signal s_short_signal    : std_logic;
    signal s_long_signal     : std_logic;
    constant c_CNT_WIDTH    : natural := 10; 
    signal s_time_short     : unsigned(c_CNT_WIDTH - 1 downto 0);
    signal s_time_long      : unsigned(c_CNT_WIDTH - 1 downto 0);
begin
    uut_pd  : entity work.signal_detect
    generic map(
        g_CNT_WIDTH => c_CNT_WIDTH
        )
    port map(
        input => s_input,
        clear_i => s_clear,
        clk => s_clk,
        reset_i => s_reset,
        short_signal_o => s_short_signal,
        long_signal_o => s_long_signal,
        time_short_i => s_time_short,
        time_long_i => s_time_long
    );
    
    l_clock : process
    begin
        while now < 2000 ns loop
            s_clk <= '0';
            wait for 5 ns;
            s_clk <= '1';
            wait for 5 ns;
        end loop;
        wait; 
    end process;
    
    gen_signals : process
    begin
        s_input <= '0';
        s_clear <= '0';
        s_reset <= '0';
        s_time_short <= TO_UNSIGNED(3, c_CNT_WIDTH);
        s_time_long <= TO_UNSIGNED(6, c_CNT_WIDTH);
        
        wait for 2 ns;
        s_reset <= '1';
        wait for 8 ns;
        -- 10 ns
        
        -- do not count this as a signal
        s_reset <= '0';
        s_input <= '1';
        wait for 10 ns;
        s_input <= '0';
        wait for 10 ns;
        
        -- do clear - nothing should happen
        s_clear <= '1';
        wait for 10 ns;
        s_clear <= '0';
        wait for 10 ns;
        
        -- Show short signal and reset
        -- trigger short signal
        s_input <= '1';
        wait for 30 ns;
        s_input <= '0';
        wait for 30 ns;
        
        -- do clear
        s_clear <= '1';
        wait for 10 ns;
        s_clear <= '0';
        wait for 30 ns;
        
        -- Show long signal and reset
        -- trigger long signal
        s_input <= '1';
        wait for 60 ns;
        s_input <= '0';
        wait for 40 ns;
        
        -- do clear
        s_clear <= '1';
        wait for 10 ns;
        s_clear <= '0';
        wait for 30 ns;
        
        -- show replacing signal signals
        -- trigger short signal
        s_input <= '1';
        wait for 30 ns;
        s_input <= '0';
        wait for 30 ns;
        
        -- trigger long signal
        s_input <= '1';
        wait for 60 ns;
        s_input <= '0';
        wait for 40 ns;
        
        -- trigger short signal
        s_input <= '1';
        wait for 30 ns;
        s_input <= '0';
        wait for 30 ns;
        
        -- do clear
        s_clear <= '1';
        wait for 10 ns;
        s_clear <= '0';
        wait for 30 ns;
        
        wait;
        
    end process;

end Behavioral;
