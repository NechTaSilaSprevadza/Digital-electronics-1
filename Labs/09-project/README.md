# Konzola pre rotoped/bicykel, hallova sonda, meranie a zobrazenie rýchlosti a prejdenej vzdialenosti

### Členovia týmu

Adam Budáč, Petr Dočkalík, Ladislav Drápal, Ondřej Dudášek

* [Link na GitHub adresár s projektom](https://github.com/NechTaSilaSprevadza/Digital-electronics-1/tree/main/Labs/09-project)

### Ciele projektu

Tvorba cyklocomputeru, ktorý meria a zobrazuje rýchlosť a prejdenú vzdialenosť pomocou hallovej sondy.

## Popis hardwaru

1. Použitý hardware

[Arty Artix-7](https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board/) - Vývojová doska Arty A7, možnosť použiť čipy A7-35T alebo A7-100T. Tlačidlom BNT0 je vykonaný synchrónny reset cyklocomputera, prepínačom SW0 sa prepína medzi zobrazením aktuálnej rýchlosti a celkovej prejdenej vzdialenosti.

![Arty-A7](Images/Arty-A7.png)

![Arty-A7](Images/Arty-A7-schema1.png)

![Arty-A7](Images/Arty-A7-schema2.png)

[Pmod 4x7seg](http://fpga.fm4dd.com/?pmod/7seg4) - 4-digit 7-segmentovka so spoločnou anódou. Segmentovka je zapojená na vysokorýchlostných Pmod JB a Pmod JC konektoroch bez ochranných rezistorov. Doska 7-segmentovky obsahuje vlastné ochranné rezistory. Multiplexovanie jednotlivých segmentoviek je každých 4 ms, čo pri 4 segmentovkách robí snímkovú frekvenciu 60 FPS a zabraňuje to blikaniu. Rýchlosť je zobrazená v km/h s maximálnou rýchlosťou 999,9 km/h a prejdená vzdialenosť v km s maximálnym nájazdom 999,9 km.

![4x7seg](Images/4x7seg.jpg)

![4x7seg](Images/4x7seg-schema.png)

[Pmod Hallova sonda](https://www.amazon.com/Sensor-Linear-Effect-Sensitivity-Detection/dp/B00W029QYC) - Hallova sonda 49E s komparátorom LM393. Obsahuje analógový a digitálny výstup. Má nastaviteľnú prahovú hodnotu komparačného napätia. Doska sondy je zapojená na štandardných Pmod JD konektoroch s ochrannými rezistormi, ktoré sa hodia ako ochrana pri použití na priame prepojenie s analógovým výstupom sondy (AOUT) alebo digitálnym výstupom komparátora (DOUT). Využitý je len DOUT ako indikácia otáčania kolesa bicykla.

![Hall](Images/Hall.jpg)

![Hall](Images/Hall-schema.jpg)

2. Zapojenie

Funkcie tlačidiel

   | **Vstup** | **Funkcia** |
   | :-: | :-: |
   | BTN0 | Reset |
   | SW0 | Zobrazenie aktuálnej rýchlosti a celkovej prejdenej vzdialenosti |

Zapojenie 7-segmentovy

   | **Konektor** | **Pin** | **Názov pinu** | **Funkcia pinu** |
   | :-: | :-: | :-: | :-: |
   | Pmod JB | 1 | E15 | segment A |
   | Pmod JB | 2 | E16 | segment B |
   | Pmod JB | 3 | D15 | segment C |
   | Pmod JB | 4 | C15 | segment D |
   | Pmod JB | 5 | GND | GND |
   | Pmod JB | 6 | VCC | 3V3 |
   | Pmod JB | 7 | J17 | segment E |
   | Pmod JB | 8 | J18 | segment F |
   | Pmod JB | 9 | K15 | segment G |
   | Pmod JB | 10 | J15 | segment DP |
   | Pmod JB | 11 | GND | GND |
   | Pmod JB | 12 | VCC | 3V3 |
   | Pmod JC | 1 | U12 | anóda digit 1 |
   | Pmod JC | 2 | V12 | anóda digit 2 |
   | Pmod JC | 3 | V10 | anóda digit 3 |
   | Pmod JC | 4 | V11 | anóda digit 4 |
   | Pmod JC | 5 | GND | GND |
   | Pmod JC | 6 | VCC | 3V3 |
   | Pmod JC | 10 | U13 | anóda dvojbodka |
   | Pmod JC | 11 | GND | GND |
   | Pmod JC | 12 | VCC | 3V3 |

Zapojenie Hallovej sondy

   | **Konektor** | **Pin** | **Názov pinu** | **Funkcia pinu** |
   | :-: | :-: | :-: | :-: |
   | Pmod JD | 3 | F4 | DOUT |
   | Pmod JD | 4 | F3 | AOUT |
   | Pmod JD | 5 | GND | GND |
   | Pmod JD | 6 | VCC | 3V3 |



## Popis a simulácie VHDL modulov



### clock_enable_1

Modul [clock_enable_1](VHDL/Designs/clock_enable_1.vhd) 

```vhdl
library ieee;               
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

------------------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------------------
entity clock_enable_1 is
    generic(
        g_MAX : natural := 100000    -- Number of clk pulses to generate                                
    );  
        
    port(
        clk   : in  std_logic;      
        reset : in  std_logic;      
        ce_1  : out std_logic      
    );
end entity clock_enable_1;

------------------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------------------
architecture Behavioral of clock_enable_1 is

    signal s_cnt_local : natural; -- Local counter
    
begin
    p_clk_ena : process(clk)
    begin
        if rising_edge(clk) then       

            if (reset = '1') then       
                s_cnt_local <= 0;      
                ce_1        <= '0';    
                 
            -- Test number of clock periods        
            elsif (s_cnt_local >= (g_MAX - 1)) then   
                s_cnt_local <= 0;       
                ce_1        <= '1';     

            else
                s_cnt_local <= s_cnt_local + 1;
                ce_1        <= '0';
            end if;
        end if;
    end process p_clk_ena;

end architecture Behavioral;
```

![min](Images/clock_enable_1.png)



### cnt_distance

Modul [cnt_distance](VHDL/Designs/cnt_distance.vhd) je jednoduchý čítač, který jsme používali v laboratorních úlohách. V našem projektu Console for bike používáme jako hodiny příchozí impulzy z Hallovy sondy, umístěné blízko kola. Vlivem neustálé změny rychlosti točení se taktéž mění délka mezi jednotlivými impulzy a proto nebylo dobré řídit se hodinami, ale řídil jsem se resetem, aby se mi nemohlo stát, že reset skončí v sestupné hraně hodinového impulzu, kde by nevynuloval proměnnou čítače.

První okno simulace simuluje rychlou jízdu a čítání impulzů z Hallovy sondy.

![and_gates](Images/1-1.PNG)

Druhé okno simulace simuluje zpomalení a příchozí reset z nadřazené logiky, který vynulovává čítač.

![and_gates](Images/1-2.PNG)

Ještě větší zpomalení.

![and_gates](Images/1-3.PNG)

Příchozí druhý reset.

![and_gates](Images/1-4.PNG)

Zrychlení jízdy.

![and_gates](Images/1-5.PNG)

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity cnt_distance is
    generic(
        g_CNT_WIDTH : natural := 4      -- Number of bits for counter
    );
    port(
        hall_i      : in  std_logic;       -- Hall sond impuls
        reset       : in  std_logic;          -- Synchronous reset
        distance_o  : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end entity cnt_distance;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of cnt_distance is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0');

begin
    --------------------------------------------------------------------
    -- p_cnt_distance:
    -- process with synchronous reset which implements n-bit 
    --------------------------------------------------------------------
    p_cnt_distance : process(hall_i,reset)
    begin
        if (reset = '0') then                       -- Reset s_cnt_local and distance_o too
            if rising_edge(hall_i) then
                s_cnt_local <= s_cnt_local + 1;     --Logic one in cnt_distance
            end if;
        else 
            s_cnt_local <= (others => '0');         -- Clear all bits     
            
        end if;
    end process p_cnt_distance;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    distance_o <= std_logic_vector(s_cnt_local);

end architecture behavioral;
```



### counter_speed

Hallova sonda je v kódu demonstrována jako hodiny, tj. počet opakujících se period. Modul [counter_speed](VHDL/Designs/counter_speed.vhd) je čítač, který čítá impulzy z Hallové sondy. Výstup čítače je závislý na hodinách. Hodiny znázorňují otáčku kola za 1 sekundu. Náběžnou hranou z hodin nulujeme čítač. Funkcí reset jsme schopni nulovat čítač i výstup z čítače. 

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity counter_speed is
generic(
        g_CNT_WIDTH : natural := 10       -- Number of bits for counter
    );
port(
        clk      : in std_logic;          -- Main clock
        reset    : in std_logic;          -- Synchronous reset
        en_i     : in std_logic;          -- Enable input   
        hall_i   : in std_logic;          -- Direction of the counter
        spd_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0);
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end counter_speed;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------ 
architecture Behavioral of counter_speed is

    -- Local counter 
    signal s_spd_local : unsigned(g_CNT_WIDTH - 1 downto 0);
    signal s_cnt : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
    --------------------------------------------------------------------
    -- p_counter_speed:
    -- Clocked process with synchronous reset which implements n-bit 
    -- up/down counter and out of counter.
    --------------------------------------------------------------------
    p_counter_speed : process(clk,hall_i,reset)
    begin
       if rising_edge(hall_i) then
          if (en_i = '1') then                    -- counting enabled
             if (s_cnt >= 2**g_CNT_WIDTH - 1) then
                s_cnt <= (others => '1');
             else
                s_cnt <= s_cnt + 1;
             end if;
          end if;
       end if;  
 
       if rising_edge(clk) then
          s_spd_local <= s_cnt;
          s_cnt <= (others => '0');
       end if;
 
       if (reset = '1') then            -- clear counters and output on reset
          s_spd_local <= (others => '0');
          s_cnt <= (others => '0');
       end if;

       if (en_i = '0') then             -- zero speed output if disabled
          s_spd_local <= (others => '0');
       end if;
      
    end process p_counter_speed;
 
    spd_o <= std_logic_vector(s_spd_local);
    cnt_o <= std_logic_vector(s_cnt);
end Behavioral;
```

![min](Images/pict1.png)

![min](Images/pict2.png)

![min](Images/pict3.png)



### process p_control



```vhdl

```



### clock_enable_0

Modul [clock_enable_0](VHDL/Designs/clock_enable_0.vhd) vytvára enable pulzy každé 4 milisekundy. To je dosiahnuté napočítaním 400000 impulzov 100 MHz interného hodinového signálu. Tieto 4 milisekundy sú potrebné pre časové multiplexovanie 7-segmentového displeja.

```vhdl
library ieee;               
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

------------------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------------------
entity clock_enable_0 is
    generic(
        g_MAX : natural := 10      -- Number of clk pulses to generate 
                                   -- one enable signal period 
    );
     
    port(
        clk   : in  std_logic;     
        reset : in  std_logic;     
        ce_o  : out std_logic       
    );
end entity clock_enable_0;

------------------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------------------
architecture Behavioral of clock_enable_0 is

    -- Local counter
    signal s_cnt_local : natural;       --local counter

begin
    --------------------------------------------------------------------
    -- p_clk_ena:
    -- Generate clock enable signal. By default, enable signal is low 
    -- and generated pulse is always one clock long.
    --------------------------------------------------------------------
    p_clk_ena : process(clk)
    begin
        if rising_edge(clk) then       

            if (reset = '1') then       
                s_cnt_local <= 0;       -- Clear local counter
                ce_o        <= '0';     -- Set output to low

            elsif (s_cnt_local >= (g_MAX - 1)) then   
                s_cnt_local <= 0;       -- Clear local counter
                ce_o        <= '1';     -- Generate clock enable pulse

            else
                s_cnt_local <= s_cnt_local + 1;
                ce_o        <= '0';
            end if;
        end if;
    end process p_clk_ena;

end architecture Behavioral;
```



### cnt_up_down

Modul [cnt_up_down](VHDL/Designs/cnt_up_down.vhd) je obojsmerný čítač. Je tu použitý ako čítač smerom hore. Jeho výstupom je informácia o tom, ktorá zo 7 segmentoviek má byť v danom čase rozsvietená. Je riadený pulzmi z modulu clock_enable_0, teda mení svoju hodnotu každé 4 milisekundy.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity cnt_up_down_0 is
    generic(
        g_CNT_WIDTH : natural := 2    -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;     
        reset    : in  std_logic;       
        en_i     : in  std_logic;       
        cnt_up_i : in  std_logic;       
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end entity cnt_up_down_0;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of cnt_up_down_0 is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);  

begin
    --------------------------------------------------------------------
    -- p_cnt_up_down:
    -- Clocked process with synchronous reset which implements n-bit 
    -- up/down counter.
    --------------------------------------------------------------------
    p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then
        
            if (reset = '1') then     
                s_cnt_local <= (others => '0'); 

            elsif (en_i = '1') then       
                s_cnt_local <= s_cnt_local + 1;
            end if;
        end if;
    end process p_cnt_up_down;

    cnt_o <= std_logic_vector(s_cnt_local);
end architecture behavioral;
```



### driver_7seg_4digits

Modul [driver_7seg_4digits](VHDL/Designs/driver_7seg_4digits.vhd) sa stará o výpis informácie na displej tvorený 4 7-segmentovkami. Tento displej je časovo multiplexovaný, každá 7-segmentovka svieti 4 milisekundy, čo robí dokopy 16 milisekúnd pre celú jednu obsluhu displeja. Týmto je dosiahnutá obnovovacia frekvencia displeja 60 Hz, čo umožňuje aby bol pozorovaný obraz plynulý. Proces `process p_mux` je multiplexer, ktorého vstup tvoria informácie o tom, ktorá 7-segmentovka má v danom čase svietiť, akú hodnotu má zobrazovať a na ktorom mieste sa nachádza desatinná bodka. Jeho funkcia je riadenie 7-segmentového displeja a prepínanie jednotlivých 7-segmentoviek. Taktiež nastavuje pozíciu desatinnej bodky.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------------------
entity driver_7seg_4digits is
    port(
        clk     : in  std_logic;        
        reset   : in  std_logic;    
        -- 4-bit input values for individual digits    
        data_i_0 : in  std_logic_vector(4 - 1 downto 0);
        data_i_1 : in  std_logic_vector(4 - 1 downto 0);
        data_i_2 : in  std_logic_vector(4 - 1 downto 0);
        data_i_3 : in  std_logic_vector(4 - 1 downto 0);
        -- 4-bit input value for decimal points
        dp_i    : in  std_logic_vector(4 - 1 downto 0);
        -- Decimal point for specific digit
        dp_o    : out std_logic;
        -- Cathode values for individual segments
        seg_o   : out std_logic_vector(7 - 1 downto 0);
        -- Common anode signals to individual displays
        dig_o   : out std_logic_vector(4 - 1 downto 0);
        -- Colon point for specific digit 
        dig_c   : out std_logic
    );
end entity driver_7seg_4digits;

------------------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------------------
architecture Behavioral of driver_7seg_4digits is
    -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(2 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);

begin
    --------------------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates an enable pulse
    -- every 4 ms
    --------------------------------------------------------------------    
    clk_en0 : entity work.clock_enable_0
        generic map(
        g_MAX  => 4
        )
        port map(
        clk    => clk,
        reset  => reset,
        ce_o   => s_en
        );
        
    --------------------------------------------------------------------
    -- Instance (copy) of cnt_up_down entity performs a 2-bit down
    -- counter
    --------------------------------------------------------------------    
    bin_cnt0 : entity work.cnt_up_down_0
        generic map(
        g_CNT_WIDTH  => 2
        )
        port map(
        clk       =>   clk,
        reset     =>   reset,
        en_i      =>   s_en,
        cnt_up_i  =>   '1',
        cnt_o     =>   s_cnt
        );

    --------------------------------------------------------------------
    -- Instance (copy) of hex_7seg entity performs a 7-segment display
    -- decoder
    --------------------------------------------------------------------    
    hex2seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => seg_o
        );

    --------------------------------------------------------------------
    -- p_mux:
    -- A combinational process that implements a multiplexer for
    -- selecting data for a single digit, a decimal point signal, 
    -- a colon point signal, and switches the common anodes of each 
    -- display.
    --------------------------------------------------------------------
    p_mux : process(s_cnt, data_i_0, data_i_1, data_i_2, data_i_3, dp_i)
    begin
        case s_cnt is
            when "11" =>
                s_hex <= data_i_3;
                dp_o  <= dp_i(3);
                dig_o <= "0111";
                dig_c <= '1';

            when "10" =>
                s_hex <= data_i_2;
                dp_o  <= dp_i(2);
                dig_o <= "1011";
                dig_c <= '1';

            when "01" =>
                s_hex <= data_i_1;
                dp_o  <= dp_i(1);
                dig_o <= "1101";
                dig_c <= '1';

            when others =>
                s_hex <= data_i_0;
                dp_o  <= dp_i(0);
                dig_o <= "1110";
                dig_c <= '1';
        end case;
    end process p_mux;
end architecture Behavioral;
```



### hex_7_seg

Modul [hex_7_seg](VHDL/Designs/hex_7_seg.vhd) prekladá 4-bitovú informáciu na 7-bitovú, priamo na jednotlivé bity, ktorá už určujú, ktoré zo 7 segmentov budú svietiť.

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hex_7seg is
  Port 
  ( 
      hex_i  :   in	 std_logic_vector (4 - 1 downto 0); --input binary data
      seg_o  :	out	 std_logic_vector (7 - 1 downto 0)  --cathode values in the order A, B, C, D, E, F
  );
end hex_7seg;

------------------------------------------------------------------------
-- Architecture body for hex_7seg
------------------------------------------------------------------------
architecture Behavioral of hex_7seg is

begin
--------------------------------------------------------------------
    -- p_7seg_decoder:
    -- A combinational process for 7-segment display decoder. 
--------------------------------------------------------------------    
    p_7seg_decoder : process(hex_i)
    
    begin
        case hex_i is
            when "0000" =>
                seg_o <= "0000001";     -- 0
                
            when "0001" =>
                seg_o <= "1001111";     -- 1
                
            when "0010" =>
                seg_o <= "0010010";     -- 2 
                   
            when "0011" =>
                seg_o <= "0000110";     -- 3
                
            when "0100" =>
                seg_o <= "1001100";     -- 4 
                
            when "0101" =>
                seg_o <= "0100100";     -- 5    
                
            when "0110" =>
                seg_o <= "0100000";     -- 6   
                 
            when "0111" =>
                seg_o <= "0001111";     -- 7 
                   
            when "1000" =>
                seg_o <= "0000000";     -- 8  
                     
            when "1001" =>
                seg_o <= "0000100";     -- 9
             
            when "1010" =>
                seg_o <= "0001000";     -- A    
    
            when "1011" =>
                seg_o <= "1100000";     -- B      
    
            when "1100" =>
                seg_o <= "0110001";     -- C
                
            when "1101" =>
                seg_o <= "1000010";     -- D
                                
            when "1110" =>
                seg_o <= "0110000";     -- E                
                
            when others =>
                seg_o <= "0111000";     -- F
        end case;
    end process p_7seg_decoder;
end Behavioral;
```

![min](Images/pict11_driver.png)



## Popis a simulácia TOP modulu

V [top](VHDL/Designs/top.vhd) module je zobrazené celkové zapojenie cyklocomputera.

![TOP](Images/TOP.svg)

```vhdl

```



## Výsledky




## Video

[Video](https: google drive)

## Referencie

   1. [Arty A7 Reference Manual](https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual)
   2. [7SEG4 PMOD](http://fpga.fm4dd.com/?pmod/7seg4)
   3. [Linear Hall Effect Sensor Module](https://protosupplies.com/product/linear-hall-effect-sensor-module/)

