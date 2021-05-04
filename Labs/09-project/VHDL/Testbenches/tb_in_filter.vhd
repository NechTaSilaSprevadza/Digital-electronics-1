----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 15:29:48
-- Design Name: 
-- Module Name: tb_in_filter - Behavioral
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

entity tb_in_filter is
--  Port ( );
end tb_in_filter;

architecture Behavioral of tb_in_filter is
    signal input    : std_logic;
    signal clk      : std_logic;
    signal output   : std_logic;
    signal reset      : std_logic;

begin
    uut_in_filter : entity work.in_filter
    generic map (
        g_INT_SIZE => 2
        )
    port map (
        input   => input,
        clk     => clk,
        reset   => reset,
        output  => output
        );
    
    clk_gen : process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    
    p_testbench : process
    begin
        reset <= '1';
        input <= '0';
        wait for 10 ns;
        reset <= '0';
        -- simulate switch bouncing
        input <= '1';
        wait for 10 ns;
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 20 ns;
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 30 ns;
        
        -- down slope bouncing
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 20 ns;
        input <= '0';
        wait for 10 ns;
        input <= '1';
        wait for 10 ns;
        input <= '0';
        wait for 40 ns;
        
        
        
        
    
        wait;
    end process;
end Behavioral;
