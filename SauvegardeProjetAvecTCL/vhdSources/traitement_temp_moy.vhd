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
    o_data      : out  std_logic_vector(39 downto 0)   -- sortie parallele
);
end component;

    signal s_donnees_registre      : std_logic_vector(39 downto 0) := (others => '0');
    signal s_somme, s_somme_copy   : signed(11 downto 0) := (others => '0');  -- Detection d'overflow sur les msb
    signal s_moyenne                            : std_logic_vector(7 downto 0);

begin
    registre : reg_dec_donnees
    port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_strobe,
        i_data => i_data_echantillon(11 downto 4),
        o_data => s_donnees_registre
    );

    process(i_reset, i_strobe, i_clk)
    begin
        if falling_edge(i_strobe) then
            s_somme_copy <= s_somme;
        end if;
    end process;
    s_somme <= (resize(signed(s_donnees_registre(39 downto 32)), 12)) +
               (resize(signed(s_donnees_registre(31 downto 24)), 12)) +
               (resize(signed(s_donnees_registre(23 downto 16)), 12)) +
               (resize(signed(s_donnees_registre(15 downto 8)), 12)) +
               (resize(signed(s_donnees_registre(7 downto 0)), 12));
                      
    s_moyenne <= std_logic_vector(resize((s_somme / 5), 8));       
    o_data_temp_moy <= s_moyenne & x"0" ;
end Behavioral;
