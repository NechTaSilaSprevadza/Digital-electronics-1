----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2021 14:51:30
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
           CLK100MHZ    : in STD_LOGIC;
           BTN0         : in STD_LOGIC;
           SW           : in STD_LOGIC_VECTOR  (16-1 downto 0);
           CA           : out STD_LOGIC;
           CB           : out STD_LOGIC;
           CC           : out STD_LOGIC;
           CD           : out STD_LOGIC;
           CE           : out STD_LOGIC;
           CF           : out STD_LOGIC;
           CG           : out STD_LOGIC;
           DP           : out STD_LOGIC;
           AN           : out STD_LOGIC_VECTOR (8-1 downto 0)
     );
end top;

architecture Behavioral of top is

begin

    driver_seg_4 : entity work.driver_7seg_4digits
        port map(
            clk        => CLK100MHZ,
            reset      => BTN0,
            
            data1_i    => "0000",
            data2_i    => "0000",
            data3_i    => "0000",
            data0_i(3) => SW(3),
            data0_i(2) => SW(2),
            data0_i(1) => SW(1),
            data0_i(0) => SW(0),

            data0_i(3) => SW(7),
            data0_i(2) => SW(6),
            data0_i(1) => SW(5),
            data0_i(0) => SW(4),
            
            data0_i(3) => SW(11),
            data0_i(2) => SW(10),
            data0_i(1) => SW(9),
            data0_i(0) => SW(8),
            
            data0_i(3) => SW(15),
            data0_i(2) => SW(14),
            data0_i(1) => SW(13),
            data0_i(0) => SW(12),
            
            dig_o      => AN(4-1 downto 0),
            
            seg_o(0)   => CA,
            seg_o(1)   => CB,
            seg_o(2)   => CC,
            seg_o(3)   => CD,
            seg_o(4)   => CE,
            seg_o(5)   => CF,
            seg_o(6)   => CG,
            
            dp_i => "0111",
            dp_o => DP
        );

    AN(7 downto 4) <= b"1111";

end architecture Behavioral;
