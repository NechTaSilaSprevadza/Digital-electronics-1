
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jk_ff_rst is
    Port ( 
        clk   : in STD_LOGIC;
        j     : in STD_LOGIC;
        k     : in STD_LOGIC;
        rst   : in STD_LOGIC;
        q     : out STD_LOGIC;
        q_bar : out STD_LOGIC
        );
end jk_ff_rst;

architecture Behavioral of jk_ff_rst is
    signal s_q     : std_logic;
    signal s_q_bar : std_logic;
begin
    p_jk_ff_rst : process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                s_q     <= '0';
                s_q_bar <= '1';
            else
                if (j = '0' and k = '0') then
                    s_q     <= s_q;
                    s_q_bar <= s_q_bar;
                elsif (j = '0' and k = '1') then
                    s_q     <= '0';
                    s_q_bar <= '1';
                elsif (j = '1' and k = '0') then
                    s_q     <= '1';
                    s_q_bar <= '0';
                else
                    s_q     <= not s_q;
                    s_q_bar <= not s_q_bar;
                end if;
            end if;
        end if;
    end process p_jk_ff_rst;
    q     <= s_q;
    q_bar <= s_q_bar;
end Behavioral;
