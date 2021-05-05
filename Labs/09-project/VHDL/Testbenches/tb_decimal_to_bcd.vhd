----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2021 00:49:16
-- Design Name: 
-- Module Name: tb_decimal_to_bcd - Behavioral
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

entity tb_decimal_to_bcd is
--  Port ( );
end tb_decimal_to_bcd;

architecture Behavioral of tb_decimal_to_bcd is
    signal input    : std_logic_vector(14 - 1 downto 0);
    signal clk      : std_logic;
    signal output0  : std_logic_vector(4 - 1 downto 0);
    signal output1  : std_logic_vector(4 - 1 downto 0);
    signal output2  : std_logic_vector(4 - 1 downto 0);
    signal output3  : std_logic_vector(4 - 1 downto 0);
begin

    uut_decimal_to_bcd  : entity work.decimal_to_bcd
    port map(
        input       => input,
        clk         => clk,
        output_0    => output0,
        output_1    => output1,
        output_2    => output2,
        output_3    => output3
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
        input <= "00100110100100"; -- 2468
        wait for 10 ns;
        input <= "00000000000000"; -- 0
        wait for 10 ns;
        input <= (others => '1');  -- full one
        wait for 10 ns;
        input <= "10011000011001"; -- 9753
        wait; 
    end process;
    

end Behavioral;
