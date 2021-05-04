----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2021 13:11:11
-- Design Name: 
-- Module Name: tb_cnt_distance - Behavioral
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
use ieee.numeric_std.all;

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

entity tb_cnt_distance is
-- Entity of testbench is always empty
end tb_cnt_distance;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------

architecture testbench of tb_cnt_distance is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 10;
    constant c_hall_PERIOD       : time    := 10 ms;

    --Local signals
    signal s_hall_i            : std_logic;
    signal s_reset             : std_logic;
    signal s_distance_o        : std_logic_vector(c_CNT_WIDTH - 1 downto 0);
    
begin
 -- Connecting testbench signals with cnt_distance entity
    -- (Unit Under Test)
    uut_cnt : entity work.cnt_distance
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            hall_i      => s_hall_i,
            reset       => s_reset,
            distance_o  => s_distance_o
        );

    --------------------------------------------------------------------
    -- Hall impuls generation process
    --------------------------------------------------------------------
    p_hall_i_gen : process
    begin
        while now < 100 ms loop 
            s_hall_i <= '1';
            wait for c_hall_PERIOD/2;
            s_hall_i <= '0';
            wait for c_hall_PERIOD/2;
        end loop;
        
        while now < 200 ms loop         -- 75 periods of hall impuls
            s_hall_i <= '1';
            wait for c_hall_PERIOD;
            s_hall_i <= '0';
            wait for c_hall_PERIOD;
        end loop;
        
        while now < 400 ms loop         -- 75 periods of hall impuls
            s_hall_i <= '1';
            wait for c_hall_PERIOD*2;
            s_hall_i <= '0';
            wait for c_hall_PERIOD*2;
        end loop;
        
        while now < 550 ms loop 
            s_hall_i <= '1';
            wait for c_hall_PERIOD/2;
            s_hall_i <= '0';
            wait for c_hall_PERIOD/2;
        end loop;
        wait;
    end process p_hall_i_gen;

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 150 ms;
        
        -- Reset activated
        s_reset <= '1';
        wait for 15 ms;

        s_reset <= '0';
        wait for 100 ms;
        
        -- Reset activated
        s_reset <= '1';
        wait for 15 ms;
        
        s_reset <= '0';
        wait;
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end testbench;
