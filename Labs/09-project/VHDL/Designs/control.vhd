
--- control ---
-- author: Petr Dockalik, Ondrej Dudasek, 

--- Description:
-- Controller process for bicycle computer. 
-- switches between three screens: speed, distance and set.
-- Calculates speed and distance from inputs and internal signal s_circumference
-- changeable via set screen. Turns off screen when no activity is detected in 60 seconds.
-- Works with 1

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity control is
    Port (
        -- clock inputs (delete additional later)
        clk       : in std_logic;
        -- inputs
        reset_i     : in std_logic;
        speed_i     : in std_logic_vector(10 - 1 downto 0);
        distance_i  : in std_logic_vector(23 - 1 downto 0);
        
        -- press_detect interface
        short_press_i   : in std_logic;
        long_press_i    : in std_logic;
        clear_press_o   : out std_logic;
        
        -- outputs
        state_o     : out std_logic_vector(3 - 1 downto 0);
        data_o_0    : out std_logic_vector(3 downto 0); -- display outputs
        data_o_1    : out std_logic_vector(3 downto 0);
        data_o_2    : out std_logic_vector(3 downto 0);
        data_o_3    : out std_logic_vector(3 downto 0)
        
    );
end control;

architecture Behavioral of control is
    --- fsm variables
    type t_state is (SET, DST, SPD);
    
    signal s_state      : t_state;
    
    -- clear press detect signals
    signal s_clear         : std_logic;
    signal s_clear_wipe2   : std_logic;
    
    --- computational signals
    -- 9 multiplied by 9 bits is 18, without 6 is 12
    signal s_speed_cms      : std_logic_vector(20 - 1 downto 0);
    signal s_speed_mh       : std_logic_vector(25 - 1 downto 0);
    signal s_speed_kmh      : std_logic_vector(25 - 1 downto 0);
    -- 18 * 9 = 27
    signal s_distance_cm    : std_logic_vector(30 - 1 downto 0);
    signal s_distance_km    : std_logic_vector(30 - 1 downto 0);
    
    
    
    signal s_data_o_0               : std_logic_vector(3 downto 0);
    signal s_data_o_1               : std_logic_vector(3 downto 0);
    signal s_data_o_2               : std_logic_vector(3 downto 0);
    signal s_data_o_3               : std_logic_vector(3 downto 0);
    
    signal s_speed_o_0               : std_logic_vector(3 downto 0);
    signal s_speed_o_1               : std_logic_vector(3 downto 0);
    signal s_speed_o_2               : std_logic_vector(3 downto 0);
    signal s_speed_o_3               : std_logic_vector(3 downto 0);
    
    signal s_set_o_0               : std_logic_vector(3 downto 0);
    signal s_set_o_1               : std_logic_vector(3 downto 0);
    signal s_set_o_2               : std_logic_vector(3 downto 0);
    signal s_set_o_3               : std_logic_vector(3 downto 0);
    
    signal s_dist_o_0               : std_logic_vector(3 downto 0);
    signal s_dist_o_1               : std_logic_vector(3 downto 0);
    signal s_dist_o_2               : std_logic_vector(3 downto 0);
    signal s_dist_o_3               : std_logic_vector(3 downto 0);
    
    signal s_WHEEL_CIRCUMFERENCE    : unsigned(9 - 1 downto 0);

    -- constants 
    constant c_TIMER_WIDTH          : natural := 8;

begin
    
    -- conversion processes
    -- multiply wheel impulses with wheel circumference
    dist_circumference_multiply : entity work.multiply
    generic map(
        g_WIDTH => 30
    ) 
    port map (
        input_1(23 - 1 downto 0)    => distance_i,
        input_1(30 - 1 downto 23)   => (others => '0'), 
        input_2(9 - 1  downto 0)    => std_logic_vector(s_WHEEL_CIRCUMFERENCE),
        input_2(30 - 1 downto 9)    => (others => '0'),
        clk                         => clk,
        output                      => s_distance_cm
    );
    
    -- convert distance from cm to km
    dist_km_divide  : entity work.divide
    generic map(
        g_WIDTH => 30
    ) 
    port map (
        input_1     => s_distance_cm,
        input_2     => std_logic_vector(TO_UNSIGNED(100000, 30)),
        clk         => clk,
        output      => s_distance_km
    );
    
    dist_to_bcd : entity work.decimal_to_bcd
    port map(
        input       => s_distance_km(14 - 1 downto 0),
        clk         => clk,
        output_0    => s_dist_o_0,
        output_1    => s_dist_o_1,
        output_2    => s_dist_o_2,
        output_3    => s_dist_o_3
    );
    
    
    --- speed
    speed_circumference_multiply : entity work.multiply
    generic map(
        g_WIDTH => 20
    ) 
    port map (
        input_1(10 - 1 downto 0)    => speed_i,
        input_1(20 - 1 downto 10)   => (others => '0'), 
        input_2(9  - 1 downto 0)    => std_logic_vector(s_WHEEL_CIRCUMFERENCE),
        input_2(20 - 1 downto 9)    => (others => '0'),
        clk                         => clk,
        output                      => s_speed_cms
    );
    
    speed_hour_multiply : entity work.multiply
    generic map(
        g_WIDTH => 25
    ) 
    port map (
        input_1(20 - 1 downto 0)    => s_speed_cms,
        input_1(25 - 1 downto 20)   => (others => '0'), 
        input_2(25 - 1 downto 0)    => std_logic_vector(TO_UNSIGNED(36, 25)),
        clk                         => clk,
        output                      => s_speed_mh
    );
    
    speed_1000_divide : entity work.divide
    generic map(
        g_WIDTH => 25
    )
    port map(
        input_1      => s_speed_mh,
        input_2      => std_logic_vector(TO_UNSIGNED(1000, 25)),
        clk          => clk,
        output       => s_speed_kmh
    );
    
    speed_to_bcd : entity work.decimal_to_bcd
    port map(
        input       => s_speed_kmh(14 - 1 downto 0),
        clk         => clk,
        output_0    => s_speed_o_0,
        output_1    => s_speed_o_1,
        output_2    => s_speed_o_2,
        output_3    => s_speed_o_3
    );
    
    circumference_to_bcd : entity work.decimal_to_bcd
    port map(
        input(9 - 1 downto 0)   => std_logic_vector(s_WHEEL_CIRCUMFERENCE),
        input(14 - 1 downto 9)  => (others => '0'),
        clk                     => clk,
        output_0                => s_set_o_0,
        output_1                => s_set_o_1,
        output_2                => s_set_o_2,
        output_3                => s_set_o_3
    );
    
    
    --- Finite state machine
    p_control_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset_i = '1') then -- reset
                s_state <= SET;
                s_clear <= '1';
                s_clear_wipe2 <= '0';
                s_WHEEL_CIRCUMFERENCE <= TO_UNSIGNED(150, 9);

            -- wheel circumference set
            elsif s_state = SET then    
                if (long_press_i = '1') then
                    s_clear <= '1';
                    s_state <= SPD;
                elsif (short_press_i = '1') then
                    s_clear <= '1';
                    if (s_WHEEL_CIRCUMFERENCE = TO_UNSIGNED(400, 9)) then
                        s_WHEEL_CIRCUMFERENCE <= TO_UNSIGNED(150, 9);
                    else
                        s_WHEEL_CIRCUMFERENCE <= s_WHEEL_CIRCUMFERENCE + 1;
                    end if;
                end if;

        
            -- show distance
            elsif s_state = DST then
                if (long_press_i = '1') then
                    s_clear <= '1';
                    s_state <= SET;
                elsif (short_press_i = '1') then
                    s_clear <= '1';
                    s_state <= SPD;
                end if;
            
            
            -- show speed
            elsif s_state = SPD then        -- show speed
                if (long_press_i = '1') then
                    s_clear <= '1';
                    s_state <= SET;
                elsif (short_press_i = '1') then
                    s_clear <= '1';
                    s_state <= DST;
                end if;
            
            else    -- unknown state
                s_state <= SET;
            end if;
            
            -- clear bit wipe in next clock
            if (s_clear = '1') then
                s_clear <= '0';
--                if (s_clear_wipe2 = '1') then
--                    clear_press_o <= '0';
--                    s_clear <= '0';
--                    s_clear_wipe2 <= '0';
--                else
--                    s_clear_wipe2 <= '1';
--                end if;
            end if;
        end if;
    end process;
    
    
    p_output : process(clk)
    begin
        if rising_edge(clk) and (reset_i = '0') then
            if (s_state = SET) then -- set circumference mode
                state_o <= "100";
                s_data_o_3 <= s_set_o_3;
                s_data_o_2 <= s_set_o_2;
                s_data_o_1 <= s_set_o_1;
                s_data_o_0 <= s_set_o_0;
    
            elsif (s_state = DST) then 
                state_o <= "010";
                s_data_o_3 <= s_dist_o_3;
                s_data_o_2 <= s_dist_o_2;
                s_data_o_1 <= s_dist_o_1;
                s_data_o_0 <= s_dist_o_0;
    
             elsif (s_state = SPD) then 
                state_o <= "001";
                s_data_o_3 <= s_speed_o_3;
                s_data_o_2 <= s_speed_o_2;
                s_data_o_1 <= s_speed_o_1;
                s_data_o_0 <= s_speed_o_0;
             else
                state_o <= "000";
             end if;
        end if;
    end process;
    
    clear_press_o <= s_clear;
    data_o_0      <= s_data_o_0;
    data_o_1      <= s_data_o_1;
    data_o_2      <= s_data_o_2;
    data_o_3      <= s_data_o_3;
    
end Behavioral;