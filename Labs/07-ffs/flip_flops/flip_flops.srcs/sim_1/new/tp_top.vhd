
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tp_top is
end tp_top;

architecture Behavioral of tp_top is

    signal s_SW      : std_logic_vector(1 - 1 downto 0);
    signal s_BTNU    : std_logic;
    signal s_BTNC    : std_logic;
    signal s_LED     : std_logic_vector(4 - 1 downto 0);
    
begin

    uut_top : entity work.top
        port map(
            SW(0)  => s_SW(0),
            BTNU   => s_BTNU,
            BTNC   => s_BTNC,
            LED(0) => s_LED(0),
            LED(1) => s_LED(1),
            LED(2) => s_LED(2),
            LED(3) => s_LED(3)
        );
        
    p_clk_gen : process
    begin
        while now < 750 ns loop
            s_BTNU <= '0'; wait for 10 ns;
            s_BTNU <= '1'; wait for 10 ns;
        end loop;
        wait;
    end process p_clk_gen;

    p_reset_gen : process
    begin
        s_BTNC <= '1'; wait for 100 ns;
        s_BTNC <= '0'; wait for 200 ns;
        s_BTNC <= '1'; wait for 200 ns;
        s_BTNC <= '0'; wait;
    end process p_reset_gen;

    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;
        s_SW(0) <= '0'; wait for 20 ns;
        s_SW(0) <= '1'; wait for 20 ns;

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end Behavioral;
