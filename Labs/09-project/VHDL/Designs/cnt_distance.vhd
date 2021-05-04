------------------------------------------------------------------------
--
-- N-bit binary counter distance.
-- Arty A7-100T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2019-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity cnt_distance is
    generic(
        g_CNT_WIDTH : natural := 4      -- Number of bits for counter
    );
    port(
        hall_i      : in  std_logic;       -- Hall sond impuls
        reset       : in  std_logic;          -- Synchronous reset
        distance_o  : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end entity cnt_distance;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of cnt_distance is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0');

begin
    --------------------------------------------------------------------
    -- p_cnt_distance:
    -- process with synchronous reset which implements n-bit 
    --------------------------------------------------------------------
    p_cnt_distance : process(hall_i,reset)
    begin
        if (reset = '0') then                       -- Reset s_cnt_local and distance_o too
            if rising_edge(hall_i) then
                s_cnt_local <= s_cnt_local + 1;     --Logic one in cnt_distance
            end if;
        else 
            s_cnt_local <= (others => '0');         -- Clear all bits     
            
        end if;
    end process p_cnt_distance;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    distance_o <= std_logic_vector(s_cnt_local);

end architecture behavioral;

