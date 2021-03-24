
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_jk_ff_rst is
end tb_jk_ff_rst;

architecture Behavioral of tb_jk_ff_rst is

    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    signal s_j       : std_logic;
    signal s_k       : std_logic;
    signal s_clk     : std_logic;
    signal s_rst     : std_logic;
    signal s_q       : std_logic;
    signal s_q_bar   : std_logic;
    
begin

    uut_jk_ff_rst : entity work.jk_ff_rst
        port map(
            j     => s_j,
            k     => s_k,
            clk   => s_clk,
            rst   => s_rst,
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
        s_rst <= '1'; wait for 10 ns;
        s_rst <= '0'; wait for 100 ns;
        s_rst <= '1'; wait for 100 ns;
        s_rst <= '0'; wait;
    end process p_reset_gen;

    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        s_j <= '0'; s_k <= '0'; wait for 20 ns;
        s_j <= '0'; s_k <= '1'; wait for 20 ns;
        s_j <= '1'; s_k <= '0'; wait for 20 ns;
        s_j <= '1'; s_k <= '1'; wait for 20 ns;
        s_j <= '0'; s_k <= '0'; wait for 20 ns;
        s_j <= '0'; s_k <= '1'; wait for 20 ns;
        s_j <= '1'; s_k <= '0'; wait for 20 ns;
        s_j <= '1'; s_k <= '1'; wait for 20 ns;
        s_j <= '0'; s_k <= '0'; wait for 20 ns;
        s_j <= '0'; s_k <= '1'; wait for 20 ns;
        s_j <= '1'; s_k <= '0'; wait for 20 ns;
        s_j <= '1'; s_k <= '1'; wait for 20 ns;
        s_j <= '0'; s_k <= '0'; wait for 20 ns;
        s_j <= '0'; s_k <= '1'; wait for 20 ns;
        s_j <= '1'; s_k <= '0'; wait for 20 ns;
        s_j <= '1'; s_k <= '1'; wait for 20 ns;
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end Behavioral;
