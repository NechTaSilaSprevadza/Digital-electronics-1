
    -- in_filter --
    -- author: Ondrej Dudasek
    -- inputs: input, clk
    -- outputs: output
    --- Description:
    -- Integrating synchronous filter. Samples input and 
    -- decreases or increases integer of size g_INT_SIZE.
    -- When integer reaches 0 or maximum value, changes output value.
    --- Useful for:
    -- Filtering slowly changing digital signals with 
    -- noise or possible multiple changes when single change is 
    -- supposed to happen, for example bouncing switches or 
    -- comparator output affected by noise. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity int_filter  is
    Generic (
        g_INT_SIZE  : natural := 4  -- internal buffer size in bits
    );
    Port (
        input       : in  std_logic;    -- input to filter
        clk         : in  std_logic;    -- clock for sampling
        output      : out std_logic     -- output
    );
end in_filter;

architecture Behavioral of in_filter is
    signal s_input_sum  : unsigned(g_INT_SIZE - 1 downto 0);
begin
    p_in_filter : process(clk_in)
    begin
    if rising_edge(clk_in) then
        if (input = '1') then 
            if (s_input_sum >= 2**g_INT_SIZE - 2) then
                output <= '1';
                s_input_sum <= (others => '1');
            else
                s_input_sum <= s_input_sum + 1;
            end if;
        else
            if ( s_input_sum <= 1) then
                output <= '0';
                s_input_sum <= (others => '0');
            else
                s_input_sum <= s_input_sum - 1;
            end if;
        end if;
    end if;
    end process p_in_filter;
end Behavioral;
