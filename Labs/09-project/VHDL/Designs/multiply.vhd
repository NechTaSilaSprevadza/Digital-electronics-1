

--- multiply input 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiply is 
    Generic (
        g_WIDTH : natural := 8
    );
    Port(
        input_1     : in  std_logic_vector(g_WIDTH - 1 downto 0);
        input_2     : in  std_logic_vector(g_WIDTH - 1 downto 0);
        clk         : in  std_logic;
        output      : out std_logic_vector(g_WIDTH - 1 downto 0)
    );
end entity;

architecture Behavioral of multiply is

begin

    p_multiply  : process(clk)
    begin
        if rising_edge(clk) then
            output <= std_logic_vector(
                resize(
                    unsigned(input_1) * unsigned(input_2), g_WIDTH)
                );
        end if;
    end process;
end architecture;