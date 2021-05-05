----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 23:08:06
-- Design Name: 
-- Module Name: decimal_to_bcd - Behavioral
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

entity decimal_to_bcd is
    Port (
        input       : in  std_logic_vector(14 - 1 downto 0); -- log2(9999)
        clk         : in  std_logic;
        output_0    : out std_logic_vector(4 - 1 downto 0);
        output_1    : out std_logic_vector(4 - 1 downto 0);
        output_2    : out std_logic_vector(4 - 1 downto 0);
        output_3    : out std_logic_vector(4 - 1 downto 0)
    );
end decimal_to_bcd;

architecture Behavioral of decimal_to_bcd is
begin
    decimal_to_bcd : process (clk)
    begin
        if rising_edge(clk) then
            output_0 <= std_logic_vector(resize(
                (unsigned(input) - 10*(unsigned(input)/10)), 4));
            output_1 <= std_logic_vector(resize(
                ((unsigned(input) - 100*(unsigned(input)/100))/10), 4));
            output_2 <= std_logic_vector(resize(
                ((unsigned(input) - 1000*(unsigned(input)/1000))/100), 4));
            output_3 <= std_logic_vector(resize(
                ((unsigned(input) - 10000*(unsigned(input)/10000))/1000), 4));
        end if;
    end process;
end Behavioral;
