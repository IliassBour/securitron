----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/03/2021 06:18:40 PM
-- Design Name: 
-- Module Name: reg_dec_donnees - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

entity reg_dec_donnees is
  Port ( 
    i_clk       : in std_logic;      -- horloge
    i_reset     : in std_logic;      -- reinitialisation
    i_en        : in std_logic;      -- activation decalage
    i_data      : in std_logic_vector(7 downto 0);     -- entree serie
    o_data      : out  std_logic_vector(39 downto 0)   -- sortie parallele
);
end reg_dec_donnees;

architecture Behavioral of reg_dec_donnees is
    signal   q_shift_reg   : std_logic_vector(39 downto 0) := (others =>'0');   -- registre
    
  begin 
  -- registre a décalage,  MSB arrive premier, entre par la droite, decalage a gauche  
  reg_dec: process (i_clk, i_reset)
     begin    
       if (i_reset = '1')  then
          q_shift_reg  <= (others =>'0');
      elsif falling_edge(i_clk) then  
                if (i_en = '1') then
                   q_shift_reg <= q_shift_reg(31 downto 0) & i_data;
                end if;
       end if;
     end process;
 
     o_data   <=  q_shift_reg;     
end Behavioral;
