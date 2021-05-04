----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 20:15:35
-- Design Name: 
-- Module Name: tb_control - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_control is
--  Port ( );
end tb_control;

architecture Behavioral of tb_control is
    signal clk      : std_logic;
    signal reset    : std_logic;
    signal speed    : std_logic_vector(10 - 1 downto 0);
    signal distance : std_logic_vector(19 - 1 downto 0);
    signal shortp   : std_logic;
    signal longp    : std_logic;
    signal clearp   : std_logic;
    
    signal state    : std_logic_vector(3 - 1 downto 0);
    signal data_0   : std_logic_vector(8 - 1 downto 0);
    signal data_1   : std_logic_vector(8 - 1 downto 0);
    signal data_2   : std_logic_vector(8 - 1 downto 0);
    signal data_3   : std_logic_vector(8 - 1 downto 0);
    
    signal speed_o  : unsigned(8 - 1 downto 0);
    signal dist_o   : unsigned(13 - 1 downto 0);
        signal s_WHEEL_CIRCUMFERENCE    : unsigned(9 - 1 downto 0);

    
begin
    
    uut_control : entity work.control
    port map (
        clk         => clk,
        reset_i     => reset,
        speed_i     => speed,
        distance_i      => distance,
        short_press_i   => shortp,
        long_press_i    => longp,
        state_o     => state,
        data_o_3    => data_3,
        data_o_2    => data_2,
        data_o_1    => data_1,
        data_o_0    => data_0,
        speed_o     => speed_o,
        distance_o  => dist_o,
        CIRCUMFERENCE_o => s_WHEEL_CIRCUMFERENCE
    );

    gen_clk : process 
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
        end loop;
        wait;
    end process;
    
    clear_press : process
    begin
        wait for 1 ns;
        while now < 1000 ns loop
            if (clearp = '1') then
                longp <= '0';
                shortp <= '0';
            end if;
            wait for 2 ns;
        end loop;
        wait;
    end process;
    
    tb_control : process
    begin
        reset <= '1';
        speed <= "0000000000";
        distance <= "0000000000000000000";
        longp <= '0';
        shortp <= '0';
        clearp <= '0';
        wait for 2 ns;
        reset <= '0';
        
--        while now < 1000 ns loop
--            shortp <= '1';
--            wait for 4 ns;
--        end loop;
        wait;
    end process;
    
    
end Behavioral;
