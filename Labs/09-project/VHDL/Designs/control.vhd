
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
        speed_i     : in std_logic_vector(9 downto 0);
        distance_i  : in std_logic_vector(18 downto 0);
        
        -- press_detect interface
        short_press_i   : in std_logic;
        long_press_i    : in std_logic;
        clear_press_o   : out std_logic;
        
        -- outputs
        state_o     : out std_logic_vector(3 - 1 downto 0);
        data_o_0    : out std_logic_vector(7 downto 0); -- display outputs
        data_o_1    : out std_logic_vector(7 downto 0);
        data_o_2    : out std_logic_vector(7 downto 0);
        data_o_3    : out std_logic_vector(7 downto 0);
        
        speed_o     : out unsigned(8 - 1 downto 0);
        distance_o  : out unsigned(13 - 1 downto 0);
        CIRCUMFERENCE_o    : out unsigned(9 - 1 downto 0)


    );
end control;

architecture Behavioral of control is
    --- fsm variables
    type t_state is (SET, DST, SPD);
    
    signal s_state      : t_state;
    
    -- clear press detect signals
    signal s_pd_clear   : std_logic;
    signal s_clear_wipe : std_logic;
    
    --- computational signals
    -- 9 multiplied by 9 bits is 18, without 6 is 12
    signal s_speed                  : unsigned(19 - 1 downto 0); -- max 256km/h
    -- 18 * 9 = 27
    signal s_distance               : unsigned(28 - 1 downto 0); -- 4 digits of distance
    signal s_data_o_0               : std_logic_vector(7 downto 0);
    signal s_data_o_1               : std_logic_vector(7 downto 0);
    signal s_data_o_2               : std_logic_vector(7 downto 0);
    signal s_data_o_3               : std_logic_vector(7 downto 0);
    signal s_WHEEL_CIRCUMFERENCE    : unsigned(9 - 1 downto 0);

    -- constants 
    constant c_TIMER_WIDTH          : natural := 8;

begin
    
    --- Finite state machine
    p_control_fsm : process(clk)
    begin
        if rising_edge(clk) then
            if (reset_i = '1') then -- reset
                s_state <= SET;
                s_pd_clear <= '1';
                s_clear_wipe <= '0';
                s_WHEEL_CIRCUMFERENCE <= TO_UNSIGNED(150, 9);

            -- wheel circumference set
            elsif s_state = SET then    
                if (long_press_i = '1') then
                    s_pd_clear <= '1';
                    s_state <= SPD;
                elsif (short_press_i = '1') then
                    s_pd_clear <= '1';
                    if (s_WHEEL_CIRCUMFERENCE = TO_UNSIGNED(400, 9)) then
                        s_WHEEL_CIRCUMFERENCE <= TO_UNSIGNED(150, 9);
                    else
                        s_WHEEL_CIRCUMFERENCE <= s_WHEEL_CIRCUMFERENCE + 1;
                    end if;
                end if;

        
            -- show distance
            elsif s_state = DST then
                if (long_press_i = '1') then
                    s_pd_clear <= '1';
                    s_state <= SET;
                elsif (short_press_i = '1') then
                    s_pd_clear <= '1';
                    s_state <= SPD;
                end if;
            
            
            -- show speed
            elsif s_state = SPD then        -- show speed
                if (long_press_i = '1') then
                    s_pd_clear <= '1';
                    s_state <= SET;
                elsif (short_press_i = '1') then
                    s_pd_clear <= '1';
                    s_state <= DST;
                end if;
            
            else    -- unknown state
                s_state <= SET;
            end if;
        end if;
    end process;

    p_output : process(clk)
    begin
        if rising_edge(clk) and (reset_i = '0') then
            s_distance <= resize(((unsigned(distance_i) * s_WHEEL_CIRCUMFERENCE)/100), 28);
            s_distance <= resize((s_distance - (s_distance/10000)*10000), 28);
            s_speed <= resize((unsigned(speed_i)*s_WHEEL_CIRCUMFERENCE)/360, 19);
            s_speed <= resize((s_speed - (s_distance/1000)*1000), 19);
            
            if (s_state = SET) then -- set circumference mode
                state_o <= "100";
                s_data_o_3 <= X"00";
                s_data_o_2 <= std_logic_vector(s_WHEEL_CIRCUMFERENCE/100);
                s_data_o_1 <= std_logic_vector((s_WHEEL_CIRCUMFERENCE
                    - unsigned(s_data_o_2))/10);
                s_data_o_0 <= std_logic_vector((s_WHEEL_CIRCUMFERENCE
                    - unsigned(s_data_o_2) - unsigned(s_data_o_1))/10);
                
            elsif (s_state = DST) then  -- display distance mode
                state_o <= "010";
                s_data_o_3 <= std_logic_vector((s_distance)/1000);
                s_data_o_2 <= std_logic_vector(
                    (s_distance - unsigned(s_data_o_3)*1000)/100);
                s_data_o_1 <= std_logic_vector(
                    (s_distance - unsigned(s_data_o_3)*1000
                     - unsigned(s_data_o_2)*100)/10);
                s_data_o_0 <= std_logic_vector(
                    s_distance - unsigned(s_data_o_3)*1000
                     - unsigned(s_data_o_2)*100 - unsigned(s_data_o_1)*10);
                     
            elsif (s_state = SPD) then  -- display speed mode
                state_o <= "001";
                s_data_o_3 <= std_logic_vector(s_speed/1000);
                s_data_o_2 <= std_logic_vector(
                    (s_speed - unsigned(s_data_o_3)*1000)/100);
                s_data_o_1 <= std_logic_vector(
                    (s_speed - unsigned(s_data_o_3)*1000
                     - unsigned(s_data_o_2)*100)/10);
                s_data_o_0 <= std_logic_vector(
                    s_speed - unsigned(s_data_o_3)*1000
                    - unsigned(s_data_o_2)*100 - unsigned(s_data_o_1)*10);
            else
                state_o <= "000";
            end if;
        end if;
    end process;

    --    Limit clear press detect to two clock cycles
    p_clean_wiper : process(clk)
    begin
        if rising_edge(clk) then
            if (s_pd_clear = '1') then
                if (s_clear_wipe = '1') then
                    s_pd_clear <= '0';
                    s_clear_wipe <= '0';
                else
                    s_clear_wipe <= '1';
                end if;
            end if;
        end if;
    end process;
    
    data_o_3 <= s_data_o_3;
    data_o_2 <= s_data_o_2;
    data_o_1 <= s_data_o_1;
    data_o_0 <= s_data_o_0; 
    clear_press_o <= s_pd_clear;
    distance_o  <= resize(s_distance, 13);
    speed_o     <= resize(s_speed, 8);
    CIRCUMFERENCE_o <= s_WHEEL_CIRCUMFERENCE;
end Behavioral;
