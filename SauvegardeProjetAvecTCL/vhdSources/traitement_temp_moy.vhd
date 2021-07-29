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
    o_s_1                         : out   std_logic_vector(7 downto 0);
    o_s_2                         : out   std_logic_vector(7 downto 0);
    o_s_3                         : out   std_logic_vector(7 downto 0);
    o_s_4                         : out   std_logic_vector(7 downto 0);
    o_s_5                         : out   std_logic_vector(7 downto 0);
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

    signal s_donnees                            : std_logic_vector(39 downto 0) := (others => '0');    -- 5*8 bits
    signal s_somme                              : unsigned(11 downto 0) := (others => '0');  -- Detection d'overflow sur les msb
    signal s_premiere_valeur                    : std_logic := '1';
    signal s_moyenne                            : unsigned(11 downto 0);
    signal s_temp                               : std_logic_vector(7 downto 0);

begin
--    registre : reg_dec_donnees
--    port map (
--        i_clk => i_clk,
--        i_reset => i_reset,
--        i_en => i_strobe,
--        i_data => i_data_echantillon(11 downto 4),
--        o_data => s_donnees
--    );

    calc : process(i_strobe)
    begin
        if(i_reset = '1') then
            s_donnees <= (others => '0');
        elsif (i_strobe = '1' and (s_donnees(7 downto 0) /= i_data_echantillon(11 downto 4))) then
            s_donnees <= s_donnees(31 downto 0) & i_data_echantillon(11 downto 4);
--            s_donnees(39 downto 8) <= s_donnees(31 downto 0);
--            s_donnees(7 downto 0) <= i_data_echantillon(11 downto 4);
        end if;
    end process;
    s_somme <=  (RESIZE(unsigned(s_donnees(39 downto 32)),12)) +
                (RESIZE(unsigned(s_donnees(31 downto 24)),12)) +
                (RESIZE(unsigned(s_donnees(23 downto 16)),12)) +
                (RESIZE(unsigned(s_donnees(15 downto 8)), 12)) +
                (RESIZE(unsigned(s_donnees(7 downto 0)),  12));
    s_moyenne <= s_somme / 5;
    
    o_data_temp_moy <= std_logic_vector(s_moyenne(7 downto 0)) & x"0";
    
    o_s_1 <= s_donnees(39 downto 32);
    o_s_2 <= s_donnees(31 downto 24);
    o_s_3 <= s_donnees(23 downto 16);
    o_s_4 <= s_donnees(15 downto 8);
    o_s_5 <= s_donnees(7 downto 0);
end Behavioral;
