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
    o_data_temp_moy               : out   std_logic_vector(11 downto 0);
    --Test
    o_data_prev : out std_logic_vector(11 downto 0);  -- dernière donnée du registre
    o_data : out std_logic_vector(11 downto 0);
    o_data_resize : out std_logic_vector(11 downto 0);
    o_somme : out std_logic_vector(11 downto 0)
);
end traitement_temp_moy;

architecture Behavioral of traitement_temp_moy is

component reg_dec_donnees is
Port (
    i_clk       : in std_logic;      -- horloge
    i_reset     : in std_logic;      -- reinitialisation
    i_en        : in std_logic;      -- activation decalage
    i_data      : in std_logic_vector(7 downto 0);     -- entree serie
    o_data      : out  std_logic_vector(127 downto 0);   -- sortie parallele
    o_data_prev : out std_logic_vector(7 downto 0)  -- dernière donnée du registre
);
end component;

    signal s_donnees_registre      : std_logic_vector(127 downto 0) := (others => '0');
    signal s_somme, s_somme_copy, s_somme_prev   : unsigned(11 downto 0) := (others => '0');  -- Detection d'overflow sur les msb
    signal s_data_echantillon_copy : unsigned(11 downto 0) := (others => '0');
    signal s_moyenne               : std_logic_vector(7 downto 0) := (others => '0');
    signal s_data_prev             : std_logic_vector(7 downto 0) := x"00";
    signal compteur                : integer := 0;
begin
    
    registre : reg_dec_donnees
    port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_strobe,
        i_data => i_data_echantillon(11 downto 4),
        o_data => s_donnees_registre,
        o_data_prev => s_data_prev
    );  
    
--    process(i_strobe, i_clk, i_reset)
--    begin
--        if(i_strobe = '1' and compteur = 0) then
--            compteur <= 1;
--        elsif(rising_edge(i_clk)) then
--            if(compteur < 2 and compteur > 0) then
--                compteur <= compteur + 1;
--            else
--                compteur <= 0;
--            end if;
--        end if;
--    end process;
    
    process(i_reset, i_clk, i_strobe)
    begin
        if(i_reset = '1') then
            s_somme <= x"000";
            s_somme_prev <= x"000";
            s_somme_copy <= x"000";
            s_data_echantillon_copy <= x"000";
        elsif rising_edge(i_clk) then 
            if (i_strobe = '1') then
                s_data_echantillon_copy <= RESIZE(unsigned(i_data_echantillon(11 downto 4) & '0'), 12);
                s_somme_prev <= s_somme;  
                o_somme <= std_logic_vector(s_somme_prev);  
                compteur <= 1;
            end if;
            
            if(compteur = 1) then
                 s_somme_copy <= s_somme_prev + s_data_echantillon_copy; 
                 o_data_resize <= std_logic_vector(s_data_echantillon_copy);
                 o_data <= std_logic_vector(s_somme_copy);
                 o_data_prev <= std_logic_vector(s_somme_prev);
                 compteur <= 2;         
            elsif compteur = 2 then
                 s_somme <= s_somme_copy - RESIZE(unsigned(s_data_prev), 12);
                 compteur <= 3;
            elsif compteur = 3 then
                s_moyenne <= std_logic_vector(s_somme(11 downto 4));
                compteur <= 0;
            end if;
        end if;
    end process;
    
    o_data_temp_moy <= s_moyenne & x"0";--s_donnees_registre(7 downto 0) & x"0";--

end Behavioral;
