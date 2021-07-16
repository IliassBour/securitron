----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/03/2021 06:11:49 PM
-- Design Name: 
-- Module Name: traitement_temp_moy - Behavioral
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

entity traitement_temp_moy is
Port (
    i_clk                         : in    std_logic;
    i_strobe                      : in    std_logic;
    i_reset                       : in    std_logic;
    i_data_echantillon            : in    std_logic_vector(11 downto 0);
    o_data_temp_moy               : out   std_logic_vector(11 downto 0)
);
end traitement_temp_moy;

architecture Behavioral of traitement_temp_moy is

component reg_dec_donnees is
Port (
    i_clk       : in std_logic;      -- horloge
    i_reset     : in std_logic;      -- reinitialisation
    i_en        : in std_logic;      -- activation decalage
    i_data      : in std_logic_vector(7 downto 0);     -- entree serie
    o_data      : out  std_logic_vector(127 downto 0)   -- sortie parallele
);
end component;

    signal s_donnees_registre : std_logic_vector(127 downto 0) := (others => '0');
    signal s_somme            : std_logic_vector(11 downto 0) := (others => '0');  -- Detection d'overflow sur les msb
    signal s_moyenne          : std_logic_vector(7 downto 0) := (others => '0');
    signal s_mid              : std_logic_vector(11 downto 0) := (others => '0');
    signal j,n                : integer := 0;

begin
    
    registre : reg_dec_donnees
    port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_strobe,
        i_data => i_data_echantillon(11 downto 4),
        o_data => s_donnees_registre
    );

    process(i_clk, i_strobe, i_reset, s_donnees_registre)
    begin
        s_somme <= std_logic_vector(signed("0000" & s_donnees_registre(127 downto 120))
               + signed("0000" & s_donnees_registre(119 downto 112))
               + signed("0000" & s_donnees_registre(111 downto 104))
               + signed("0000" & s_donnees_registre(103 downto 96))
               + signed("0000" & s_donnees_registre(95 downto 88))
               + signed("0000" & s_donnees_registre(87 downto 80))
               + signed("0000" & s_donnees_registre(79 downto 72))
               + signed("0000" & s_donnees_registre(71 downto 64))
               + signed("0000" & s_donnees_registre(63 downto 56))
               + signed("0000" & s_donnees_registre(55 downto 48))
               + signed("0000" & s_donnees_registre(47 downto 40))
               + signed("0000" & s_donnees_registre(39 downto 32))
               + signed("0000" & s_donnees_registre(31 downto 24))
               + signed("0000" & s_donnees_registre(23 downto 16))
               + signed("0000" & s_donnees_registre(15 downto 8))
               + signed("0000" & s_donnees_registre(7 downto 0))
               );
               
        --équivalent à shift_right de 4 => diviser par 16   *Prend la donnée floor de la division
        s_moyenne <= s_somme(11 downto 4); 
    end process;
           
    o_data_temp_moy <= "0000" & s_moyenne;

end Behavioral;
