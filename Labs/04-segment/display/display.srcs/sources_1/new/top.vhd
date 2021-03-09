------------------------------------------------------------------------
--
-- Copyright (c) 2020-2021 Adam Budac - student
-- Copyright (c) 2019-2020 Tomas Fryza - teacher
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity top is
    port(
        SW         : in   std_logic_vector(4 - 1 downto 0);
        LED        : out  std_logic_vector(8 - 1 downto 0);
        CA         : out  std_logic;
        CB         : out  std_logic;
        CC         : out  std_logic;
        CD         : out  std_logic;
        CE         : out  std_logic;
        CF         : out  std_logic;
        CG         : out  std_logic;
        AN         : out  std_logic_vector(8 - 1 downto 0)
    );
end top;

------------------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------------------
architecture behavioral of top is
begin

    --------------------------------------------------------------------
    -- Instance (copy) of hex_7seg entity
    hex2seg : entity work.hex_7seg
        port map(
            hex_i    => SW,
            seg_o(6) => CA,
            seg_o(5) => CB,
            seg_o(4) => CC,
            seg_o(3) => CD,
            seg_o(2) => CE,
            seg_o(1) => CF,
            seg_o(0) => CG
        );

    -- Connect one common anode to 3.3V
    AN <= b"1111_0111";

    -- Display input value
    LED(3 downto 0) <= SW;

    -- Turn LED(4) on if input value is equal to 0, ie "0000"
    LED(4) <= '1' when (SW = "0000") else '0';

    -- Turn LED(5) on if input value is greater than 9
    LED(5) <= '1' when (SW > "1001") else '0';

    -- Turn LED(6) on if input value is odd, ie 1, 3, 5, ...
    LED(6) <= '1' when ((SW = "0001") or (SW = "0011") or (SW = "0101") or (SW = "0111") or (SW = "1001") or (SW = "1011") or (SW = "1101") or (SW = "1111")) else '0';

    -- Turn LED(7) on if input value is a power of two, ie 1, 2, 4, or 8
    LED(7) <= '1' when ((SW = "0001") or (SW = "0010") or (SW = "0100") or (SW = "1000")) else '0';

end architecture behavioral;