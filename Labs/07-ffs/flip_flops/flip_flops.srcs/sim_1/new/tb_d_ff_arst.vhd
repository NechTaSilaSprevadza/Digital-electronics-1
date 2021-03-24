
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_d_ff_arst is
end tb_d_ff_arst;

architecture Behavioral of tb_d_ff_arst is

    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    signal s_d       : std_logic;
    signal s_clk     : std_logic;
    signal s_arst    : std_logic;
    signal s_q       : std_logic;
    signal s_q_bar   : std_logic;

begin

    uut_d_ff_arst : entity work.d_ff_arst
        port map(
            d     => s_d,
            clk   => s_clk,
            arst  => s_arst,
            q     => s_q,
            q_bar => s_q_bar
        );

    p_clk_gen : process
    begin
        while now < 750 ns loop
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    p_reset_gen : process
    begin
        s_arst <= '0'; wait for 120 ns;
        s_arst <= '1'; wait for 100 ns;
        s_arst <= '0'; wait;
    end process p_reset_gen;

    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;
        s_d    <= '1'; wait for 20 ns;
        s_d    <= '0'; wait for 20 ns;

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end architecture Behavioral;
