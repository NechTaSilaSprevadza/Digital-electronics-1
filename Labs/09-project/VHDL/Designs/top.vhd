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
        SW         : in STD_LOGIC_VECTOR (1-1 downto 0);
        SW0         : in STD_LOGIC_VECTOR (1-1 downto 0);
        LED         : out STD_LOGIC_VECTOR (4-1 downto 0);
        CA          : out STD_LOGIC;
        CB          : out STD_LOGIC;
        CC          : out STD_LOGIC;
        CD          : out STD_LOGIC;
        CE          : out STD_LOGIC;
        CF          : out STD_LOGIC;
        CG          : out STD_LOGIC;
        AN          : out STD_LOGIC_VECTOR (8-1 downto 0);
        JB          : out STD_LOGIC_VECTOR (7-1 downto 0);
        JB7         : out STD_LOGIC;
        JC          : out STD_LOGIC_VECTOR (4-1 downto 0);
        JC4         : out STD_LOGIC
    );
end top;

architecture Behavioral of top is
    -- Internal clock enable
    signal s_en  : std_logic;
    signal s_ce  : std_logic;
    -- Internal counter
    signal s_cnt : std_logic_vector(3 - 1 downto 0);
    signal s_spd : std_logic_vector(11 - 1 downto 0);
    signal s_dis : std_logic_vector(20 - 1 downto 0);
    --PMOD Hall
    signal s_hall  : std_logic;
    
    signal s_short :std_logic;
    signal s_long :std_logic;
    signal s_sd_clear :std_logic;
begin

    -- Instance (copy) of driver_7seg_4digits entity
    driver_seg_4 : entity work.driver_7seg_4digits
        port map(
            clk        => CLK100MHZ,
            reset      => BTN0,
            
            data_i_1    => "0000",
            data_i_2    => "0000",
            data_i_3    => "0000",
            data_i_0(0) => SW(0),
            data_i_0(1) => SW(1),
            data_i_0(2) => SW(2),
            data_i_0(3) => SW(3),
            
            dig_o      => JC(4-1 downto 0),
            
            seg_o(0)   => CA,
            seg_o(1)   => CB,
            seg_o(2)   => CC,
            seg_o(3)   => CD,
            seg_o(4)   => CE,
            seg_o(5)   => CF,
            seg_o(6)   => CG,
            
            dp_i  => "1101",
            dp_o  => JB7, --DP
            dig_c => JC4

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

    -- Instance (copy) of hex_7seg entity
    hex2seg : entity work.hex_7seg
        port map(
            hex_i    => s_cnt,
            seg_o(6) => CA,
            seg_o(5) => CB,
            seg_o(4) => CC,
            seg_o(3) => CD,
            seg_o(2) => CE,
            seg_o(1) => CF,
            seg_o(0) => CG
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
        
        g_CNT_WIDTH => 4

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
            distance_i  =>s_dis,
             
            -- press_detect interface
            short_press_i  => s_short, 
            long_press_i   => s_long,
            clear_press_o  => s_sd_clear
                     
        );

    p_btn : entity work.in_filter
        port map(
        
            input     => s_inp,
            clk       => CLK100MHZ,
            output    => BTN1

        );
                  
end Behavioral;
