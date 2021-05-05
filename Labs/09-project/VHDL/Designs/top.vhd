----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 19:51:12
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port 
    ( 
        CLK100MHZ   : in STD_LOGIC;
        BTN0        : in STD_LOGIC;
        BTN1        : in STD_LOGIC;
        PMOD_hall   : in STD_LOGIC;
--        SW1         : in STD_LOGIC;
--        SW0         : in STD_LOGIC;
        LED         : out STD_LOGIC_VECTOR (4-1 downto 0);
        AN          : out STD_LOGIC_VECTOR (8-1 downto 0);
        JB          : out STD_LOGIC_VECTOR (8-1 downto 0);
        JC          : out STD_LOGIC_VECTOR (8-1 downto 0);
        LED0_R      : out STD_LOGIC;
        LED0_G      : out STD_LOGIC;
        LED0_B      : out STD_LOGIC
    );
end top;

architecture Behavioral of top is
    -- Internal clock enable
    signal s_en  : std_logic;
    signal s_ce  : std_logic;
    -- Internal counter
    signal s_cnt : std_logic_vector(2 - 1 downto 0);
    signal s_spd : std_logic_vector(10 - 1 downto 0);
    signal s_dis : std_logic_vector(23 - 1 downto 0);
    --PMOD Hall
    signal s_hall  : std_logic;
    
    -- button input signal
    signal s_inp    : std_logic;
    
    
    signal s_short :std_logic;
    signal s_long :std_logic;
    signal s_sd_clear :std_logic;
    
    signal s_data_0 : std_logic_vector(4 - 1 downto 0);
    signal s_data_1 : std_logic_vector(4 - 1 downto 0);
    signal s_data_2 : std_logic_vector(4 - 1 downto 0);
    signal s_data_3 : std_logic_vector(4 - 1 downto 0);
begin

    -- Instance (copy) of driver_7seg_4digits entity
    driver_seg_4 : entity work.driver_7seg_4digits
        port map(
            clk        => CLK100MHZ,
            reset      => BTN0,
            
            data_i_0    => s_data_0,
            data_i_1    => s_data_1,
            data_i_2    => s_data_2,
            data_i_3    => s_data_3,
            
            
            dig_o      => JC(4-1 downto 0),
            
            seg_o      => JB(6 downto 0),
            
            dp_i  => "1111", -- dot point
            dp_o  => JB(7), --DP
            dig_c => JC(7)

        );

    -- Instance (copy) of clock_enable_1 entity
    clk_en0 : entity work.clock_enable_0
        generic map(
        
        g_MAX => 400000
        
        )
        port map(
        
           clk     =>   CLK100MHZ,
           reset   =>   BTN0,
           ce_o    =>   s_en

        );

    -- Instance (copy) of cnt_up_down entity
    bin_cnt0 : entity work.cnt_up_down_0
        generic map(
        
        g_CNT_WIDTH => 2

        )
        port map(
        
        clk        =>   CLK100MHZ,
        reset      =>   BTN0,
        en_i       =>   s_en,
        cnt_up_i   =>   '1',
        cnt_o      =>   s_cnt
        
        );



    -- Instance (copy) of clock_enable_1 entity
    clk_en1 : entity work.clock_enable_1
        generic map(
        
        g_MAX => 100000
        
        )
        port map(
        
           clk     =>   CLK100MHZ,
           reset   =>   BTN0,
           ce_1    =>   s_ce

        );
        
    -- Instance (copy) of counter_speed entity
    bin_cnt_speed : entity work.counter_speed
        generic map(
        
        g_CNT_WIDTH => 10

        )
        port map(
        
        clk        =>   CLK100MHZ,
        reset      =>   BTN0,
        en_i       =>   s_ce,
        hall_i     =>   s_hall,
        spd_o      =>   s_spd
        
        );
                
    -- Instance (copy) of counter_distance entity
    bin_cnt_distance : entity work.cnt_distance
        generic map(
        
        g_CNT_WIDTH => 23

        )
        port map(
        
        reset      =>   BTN0,
        hall_i     =>   s_hall,
        distance_o =>   s_dis
        
        );

    -- Instance (copy) of p_control
    p_control : entity work.control
        port map(

            speed_i     => s_spd,
            clk         => CLK100MHZ,
            reset_i     => BTN0,
            distance_i  => s_dis,
             
            -- press_detect interface
            short_press_i  => s_short, 
            long_press_i   => s_long,
            clear_press_o  => s_sd_clear,
            
            -- outputs
            data_o_0       => s_data_0,
            data_o_1       => s_data_1,
            data_o_2       => s_data_2,
            data_o_3       => s_data_3,
            state_o(2)     => LED0_R,
            state_o(1)     => LED0_G,
            state_o(0)     => LED0_B
        );

    p_btn : entity work.in_filter
        port map(
            input     => BTN1,
            clk       => s_ce,
            output    => s_inp

        );
    
    p_press_detect  : entity work.signal_detect
    generic map(
        g_CNT_WIDTH     => 10
        )
    port map(
        input           => s_inp,
        clk             => CLK100MHZ,
        clear_i         => s_sd_clear,
        reset_i         => BTN0,
        time_short_i    => "0001010000", -- 80ms
        time_long_i     => "0100101100", -- 300ms
        short_signal_o  => s_short,
        long_signal_o   => s_long
    );
    JC(6 downto 4) <= (others => '0');              
end Behavioral;
