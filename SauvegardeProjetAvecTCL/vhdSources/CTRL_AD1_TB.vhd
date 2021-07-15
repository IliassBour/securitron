----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2021 04:17:23 PM
-- Design Name: 
-- Module Name: CTRL_AD1_TB - Behavioral
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

entity CTRL_AD1_TB is
--  Port ( );
end CTRL_AD1_TB;

architecture Behavioral of CTRL_AD1_TB is

component Ctrl_AD1
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
    i_DO_sound                        : in    std_logic;                -- Bit de donnée en provenance de l'ADC pour le son
    i_DO_temp                        : in    std_logic;                -- Bit de donnée en provenance de l'ADC pour la température    
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
    o_echantillon_sound               : out   std_logic_vector (11 downto 0); -- valeur de l'échantillon reçu son
    o_echantillon_temp               : out   std_logic_vector (11 downto 0) -- valeur de l'échantillon reçu température
);
end component;

signal sim_reset, sim_clk_ADC, sim_DO_sound, sim_DO_temp, sim_ADC_nCS, sim_ADC_Strobe, sim_echantillon_pret_strobe : std_logic;
signal sim_echantillon_sound : std_logic_vector (11 downto 0);
signal sim_echantillon_temp : std_logic_vector (11 downto 0);
constant period : time := 200ns;

begin

UUT : Ctrl_AD1
port map(
    reset => sim_reset,
    clk_ADC => sim_clk_ADC,
    i_DO_sound => sim_DO_sound,
    i_DO_temp => sim_DO_temp,
    o_ADC_nCS => sim_ADC_nCS,
    i_ADC_Strobe => sim_ADC_Strobe,
    o_echantillon_pret_strobe => sim_echantillon_pret_strobe,
    o_echantillon_sound => sim_echantillon_sound,
    o_echantillon_temp => sim_echantillon_temp
);

process
begin
    sim_clk_ADC <= '1';
    loop
        wait for period/2; sim_clk_ADC <= not sim_clk_ADC;
    end loop;
end process;

tb : process
begin
    sim_reset <= '1';
    wait for period; sim_reset <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '1';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '1'; sim_ADC_Strobe <= '0';
    
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '1';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    wait for period; sim_DO_sound <= '0'; sim_ADC_Strobe <= '0';
    
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '1'; sim_ADC_Strobe <= '0';
    
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
--    wait for period; sim_DO <= '0'; sim_ADC_Strobe <= '0';
    
    wait;
end process;

end Behavioral;
