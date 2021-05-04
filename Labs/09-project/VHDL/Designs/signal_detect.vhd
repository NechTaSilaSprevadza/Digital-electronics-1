
-- signal_detect --
-- author: Ondrej Dudasek
--- Description:
-- Detects input signals longer than time_short_i 
-- and time_long_i. Detected signals have separate
-- outputs, which are reseted via clear_i.   

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signal_detect is
    Generic (
        g_CNT_WIDTH  : natural := 4  -- internal buffer size in bits
    );
    Port (
        input       : in  std_logic;    -- input to detect on
        clk         : in  std_logic;    -- clock for sampling
        clear_i     : in  std_logic;    -- clear both outputs
        reset_i     : in  std_logic;    -- standard reset for init
        -- intervals for signals
        time_short_i    : std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        time_long_i     : std_logic_vector(g_CNT_WIDTH - 1 downto 0); 
        -- signal detection outputs
        short_signal_o   : out std_logic;
        long_signal_o    : out std_logic
        
    );
end signal_detect;

architecture Behavioral of signal_detect is
    signal s_counter  : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0');
    signal s_short_signal  : std_logic := '0';
    signal s_long_signal   : std_logic := '0';
begin
    p_signal_detect : process(clk, clear_i, reset_i)
    begin

    if rising_edge(clk) then
        if (input = '1') then 
            s_counter <= s_counter + 1; 
        else    -- end of signal
            if (s_counter>=TO_UNSIGNED(time_long_i, g_CNT_WIDTH)) then
                 -- long signal
                s_long_signal <= '1';
                s_short_signal <= '0';
            
            elsif (s_counter>=TO_UNSIGNED(time_short_i, g_CNT_WIDTH)) then
                 -- short signal
                s_long_signal <= '0';
                s_short_signal <= '1';
            end if;
            -- zero the counter
            s_counter <= (others=>'0');
        end if;
    end if;

    if (clear_i = '1') then -- clear outputs
        s_short_signal <= '0';
        s_long_signal <= '0';
    end if;

    if (reset_i = '1') then
        s_short_signal <= '0';
        s_long_signal <= '0';
        s_counter <= (others => '0');
    end if;

    short_signal_o <= s_short_signal;
    long_signal_o  <= s_long_signal;
    end process p_signal_detect;
end Behavioral;
