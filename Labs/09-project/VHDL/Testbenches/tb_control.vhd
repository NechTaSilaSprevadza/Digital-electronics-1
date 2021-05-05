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
    signal speed    : std_logic_vector(11 - 1 downto 0);
    signal distance : std_logic_vector(23 - 1 downto 0);
    signal shortp   : std_logic;
    signal longp    : std_logic;
    signal clearp   : std_logic;
    
    signal state    : std_logic_vector(3 - 1 downto 0);
    signal data_0   : std_logic_vector(4 - 1 downto 0);
    signal data_1   : std_logic_vector(4 - 1 downto 0);
    signal data_2   : std_logic_vector(4 - 1 downto 0);
    signal data_3   : std_logic_vector(4 - 1 downto 0);

    
begin
    
    uut_control : entity work.control
    port map (
        clk         => clk,
        reset_i     => reset,
        speed_i     => speed,
        distance_i      => distance,
        short_press_i   => shortp,
        long_press_i    => longp,
        clear_press_o   => clearp,
        state_o     => state,
        data_o_3    => data_3,
        data_o_2    => data_2,
        data_o_1    => data_1,
        data_o_0    => data_0
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
    
    
    
    tb_control : process
    begin
        reset <= '1';
        speed <= "00000000100";
        distance <= "00000000000001111101000";
        longp <= '0';
        shortp <= '0';
        wait for 2 ns;
        reset <= '0';
        longp <= '0';
        shortp <= '0';

        -- show set circumference
        while now < 50 ns loop
            shortp <= '1';
            wait for 2 ns;
            shortp <= '0';
            wait for 3 ns;
        end loop;
        longp <= '1';
        wait for 2 ns;
        longp <= '0';
        wait for 3 ns;
        
        -- switch modes
        shortp <= '1';
        wait for 2 ns;
        shortp <= '0';
        wait for 3 ns;
        
        --switch modes back
        shortp <= '1';
        wait for 2 ns;
        shortp <= '0';
        wait for 3 ns;
        
        -- goto setmode
        longp <= '1';
        wait for 2 ns;
        longp <= '0';
        wait for 3 ns;
        wait;
    end process;
    
    
    
    
    
end Behavioral;
