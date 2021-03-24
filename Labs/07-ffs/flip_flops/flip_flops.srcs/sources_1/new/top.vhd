
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        BTNU      : in  STD_LOGIC;
        BTNC      : in  STD_LOGIC;
        SW        : in  STD_LOGIC_VECTOR (1 - 1 downto 0);
        LED       : out STD_LOGIC_VECTOR (4 - 1 downto 0)
         );
end top;

------------------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------------------
architecture Behavioral of top is

    -- Internal signals between flip-flops
    -- WRITE YOUR CODE HERE
    signal s_LED0 : std_logic;
    signal s_LED1 : std_logic;
    signal s_LED2 : std_logic;
    signal s_LED3 : std_logic;

begin

    --------------------------------------------------------------------
    -- Four instances (copies) of D type FF entity
    d_ff_0 : entity work.d_ff_rst
        port map(
            clk   => BTNU,
            rst   => BTNC,
            -- WRITE YOUR CODE HERE
            d => SW(0),
            q => s_LED0
            );

    d_ff_1 : entity work.d_ff_rst
        port map(
            clk   => BTNU,
            rst   => BTNC,
            -- WRITE YOUR CODE HERE
            d => s_LED0,
            q => s_LED1
            );

    -- WRITE YOUR CODE HERE
    d_ff_2 : entity work.d_ff_rst
        port map(
            clk   => BTNU,
            rst   => BTNC,
            -- WRITE YOUR CODE HERE
            d => s_LED1,
            q => s_LED2
            );

    d_ff_3 : entity work.d_ff_rst
        port map(
            clk   => BTNU,
            rst   => BTNC,
            -- WRITE YOUR CODE HERE
            d => s_LED2,
            q => s_LED3
            );

    LED(0) <= s_LED0;
    LED(1) <= s_LED1;
    LED(2) <= s_LED2;
    LED(3) <= s_LED3;

end architecture Behavioral;