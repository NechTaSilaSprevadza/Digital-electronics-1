
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_d_latch is
end tb_d_latch;

architecture Behavioral of tb_d_latch is

    signal s_d       : std_logic;
    signal s_en      : std_logic;
    signal s_arst    : std_logic;
    signal s_q       : std_logic;
    signal s_q_bar   : std_logic;

begin

    uut_d_latch : entity work.d_latch
        port map(
            d     => s_d,
            en    => s_en,
            arst  => s_arst,
            q     => s_q,
            q_bar => s_q_bar
        );

    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        s_en   <= '0'; s_d <= '0'; s_arst <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        
        -- Test enable
        s_en   <= '1'; s_d <= '0'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_en   <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        
        -- Test async-reset
        s_en   <= '1'; s_d <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_arst <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_arst <= '0'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_en   <= '0'; wait for 20 ns;

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture Behavioral;
