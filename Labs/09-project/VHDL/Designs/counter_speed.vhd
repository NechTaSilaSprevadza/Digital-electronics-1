library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity counter_speed is
generic(
        g_CNT_WIDTH : natural := 10       -- Number of bits for counter
    );
port(
        clk      : in std_logic;          -- Main clock
        reset    : in std_logic;          -- Synchronous reset
        en_i     : in std_logic;          -- Enable input   
        hall_i   : in std_logic;          -- Direction of the counter
        spd_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end counter_speed;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------ 
architecture Behavioral of counter_speed is

    -- Local counter 
    signal s_spd_local : unsigned(g_CNT_WIDTH - 1 downto 0);
    signal s_cnt : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
    --------------------------------------------------------------------
    -- p_counter_speed:
    -- Clocked process with synchronous reset which implements n-bit 
    -- up/down counter and out of counter.
    --------------------------------------------------------------------
    p_counter_speed : process(clk,hall_i,reset)
    begin
       if rising_edge(hall_i) then
          if (en_i = '1') then                    -- counting enabled
             if (s_cnt >= 2**g_CNT_WIDTH - 1) then
                s_cnt <= (others => '1');
             else
                s_cnt <= s_cnt + 1;
             end if;
          end if;
       end if;  
 
       if rising_edge(clk) then
          s_spd_local <= s_cnt;
          s_cnt <= (others => '0');
       end if;
 
       if (reset = '1') then            -- clear counters and output on reset
          s_spd_local <= (others => '0');
          s_cnt <= (others => '0');
       end if;

       if (en_i = '0') then             -- zero speed output if disabled
          s_spd_local <= (others => '0');
       end if;
      
    end process p_counter_speed;
 
    spd_o <= std_logic_vector(s_spd_local);
    cnt_o <= std_logic_vector(s_cnt);
end Behavioral;


