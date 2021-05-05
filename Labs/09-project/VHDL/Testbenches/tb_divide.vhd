----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 23:35:38
-- Design Name: 
-- Module Name: tb_divide - Behavioral
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

entity tb_divide is
--  Port ( );
end tb_divide;

architecture Behavioral of tb_divide is
    signal input1   : std_logic_vector(8 - 1 downto 0);
    signal input2   : std_logic_vector(8 - 1 downto 0);
    signal clk      : std_logic;
    signal output   : std_logic_vector(8 - 1 downto 0);
    
begin
    uut_divide : entity work.divide
    port map(
        input_1 => input1,
        input_2 => input2,
        clk     => clk,
        output  => output
    );
    
    gen_clk : process
    begin
        while now < 750 ns loop         -- 75 periods of 100MHz clock
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
    
    p_tb_multiply : process
    begin
        input2 <= "00000101"; -- 5
        input1 <= "00001111"; -- 15
        wait for 20 ns;
        input1 <= "00011110"; -- 30
        wait for 10 ns;
        input2 <= "00001010"; -- 10
        wait for 10 ns;
        input2 <= "00000000"; -- 0


        wait; 
    end process;

end Behavioral;
