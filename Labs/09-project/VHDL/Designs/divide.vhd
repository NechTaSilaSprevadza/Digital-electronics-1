----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 23:32:46
-- Design Name: 
-- Module Name: divide - Behavioral
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

entity divide is
    Generic (
        g_WIDTH : natural := 8
    );
    Port(
        input_1     : in  std_logic_vector(g_WIDTH - 1 downto 0);
        input_2     : in  std_logic_vector(g_WIDTH - 1 downto 0);
        clk         : in  std_logic;
        output      : out std_logic_vector(g_WIDTH - 1 downto 0)
        
    );
end divide;

architecture Behavioral of divide is

begin
    p_multiply  : process(clk)
    begin
        if rising_edge(clk) and (unsigned(input_2) > 0) then
            output <= std_logic_vector(resize(
                unsigned(input_1) / unsigned(input_2), g_WIDTH)
                );
        end if;
    end process;

end Behavioral;
