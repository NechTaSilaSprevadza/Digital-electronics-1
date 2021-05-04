library ieee;               
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

------------------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------------------
entity clock_enable_0 is
    generic(
        g_MAX : natural := 10      -- Number of clk pulses to generate 
                                   -- one enable signal period 
    );
     
    port(
        clk   : in  std_logic;     
        reset : in  std_logic;     
        ce_o  : out std_logic       
    );
end entity clock_enable_0;

------------------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------------------
architecture Behavioral of clock_enable_0 is

    -- Local counter
    signal s_cnt_local : natural;       --local counter

begin
    --------------------------------------------------------------------
    -- p_clk_ena:
    -- Generate clock enable signal. By default, enable signal is low 
    -- and generated pulse is always one clock long.
    --------------------------------------------------------------------
    p_clk_ena : process(clk)
    begin
        if rising_edge(clk) then       

            if (reset = '1') then       
                s_cnt_local <= 0;       -- Clear local counter
                ce_o        <= '0';     -- Set output to low

            elsif (s_cnt_local >= (g_MAX - 1)) then   
                s_cnt_local <= 0;       -- Clear local counter
                ce_o        <= '1';     -- Generate clock enable pulse

            else
                s_cnt_local <= s_cnt_local + 1;
                ce_o        <= '0';
            end if;
        end if;
    end process p_clk_ena;

end architecture Behavioral;
