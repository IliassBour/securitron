----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2021 04:57:19 PM
-- Design Name: 
-- Module Name: MEF_DA1 - Behavioral
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

entity MEF_DA1 is
    Port (
        clk_DAC                 : in std_logic;
        reset                    : in std_logic;
        i_DAC_Strobe            : in std_logic;     --  cadence echantillonnage AD1
        i_DAC_data_sound              : in std_logic_vector(11 downto 0);
        i_DAC_data_temp              : in std_logic_vector(11 downto 0);
        o_DAC_data_sound              : out std_logic;
        o_DAC_data_temp              : out std_logic;
        o_DAC_SYNC              : out std_logic
    );
end MEF_DA1;

architecture Behavioral of MEF_DA1 is

    type State_type is (Init, w0, w1, w2, w3, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11);
    signal etat_courant, etat_suivant : State_type;

begin

clock : process (clk_DAC, reset)
begin
    if reset = '1' then
        etat_courant <= Init;
    end if;
    if rising_edge(clk_DAC) then
        etat_courant <= etat_suivant;
    end if;
end process;

etat : process (etat_courant, i_DAC_Strobe)
begin
    case etat_courant is
    when Init =>
        if (i_DAC_Strobe = '1') then 
            etat_suivant <= w0;
        end if;
    when w0 =>
        etat_suivant <= w1;
    when w1 =>
        etat_suivant <= w2;
    when w2 =>
        etat_suivant <= w3;
    when w3 =>
        etat_suivant <= t0;
    when t0 =>
        etat_suivant <= t1;        
    when t1 =>
        etat_suivant <= t2;
    when t2 =>
        etat_suivant <= t3;              
    when t3 =>
        etat_suivant <= t4;           
    when t4 =>
        etat_suivant <= t5;           
    when t5 =>
        etat_suivant <= t6;           
    when t6 =>
        etat_suivant <= t7;           
    when t7 =>
        etat_suivant <= t8;           
    when t8 =>
        etat_suivant <= t9;           
    when t9 =>
        etat_suivant <= t10;           
    when t10 =>
        etat_suivant <= t11;           
    when t11 =>
        etat_suivant <= Init;          
    when others =>
        etat_suivant <= Init;
    end case;
end process;

sortie : process (etat_courant)
begin
    case etat_courant is
    when Init =>
        o_DAC_data_sound <= '0';
        o_DAC_data_temp <= '0';
        o_DAC_SYNC <= '1';
    when w0 =>
        o_DAC_data_sound <= '0';
        o_DAC_data_temp <= '0';
        o_DAC_SYNC <= '0';  
    when w1 =>
        o_DAC_data_sound <= '0';
        o_DAC_data_temp <= '0';
        o_DAC_SYNC <= '0'; 
    when w2 =>
        o_DAC_data_sound <= '0';
        o_DAC_data_temp <= '0';
        o_DAC_SYNC <= '0'; 
    when w3 =>
        o_DAC_data_sound <= '0';
        o_DAC_data_temp <= '0';
        o_DAC_SYNC <= '0'; 
    when t0 =>
        o_DAC_data_sound <= i_DAC_data_sound(11);
        o_DAC_data_temp <= i_DAC_data_temp(11);
        o_DAC_SYNC <= '0';        
    when t1 =>
        o_DAC_data_sound <= i_DAC_data_sound(10);
        o_DAC_data_temp <= i_DAC_data_temp(10);
        o_DAC_SYNC <= '0'; 
    when t2 =>
        o_DAC_data_sound <= i_DAC_data_sound(9);
        o_DAC_data_temp <= i_DAC_data_temp(9);
        o_DAC_SYNC <= '0';           
    when t3 =>
        o_DAC_data_sound <= i_DAC_data_sound(8);
        o_DAC_data_temp <= i_DAC_data_temp(8);
        o_DAC_SYNC <= '0';      
    when t4 =>
        o_DAC_data_sound <= i_DAC_data_sound(7);
        o_DAC_data_temp <= i_DAC_data_temp(7);
        o_DAC_SYNC <= '0';     
    when t5 =>
        o_DAC_data_sound <= i_DAC_data_sound(6);
        o_DAC_data_temp <= i_DAC_data_temp(6);
        o_DAC_SYNC <= '0';   
    when t6 =>
        o_DAC_data_sound <= i_DAC_data_sound(5);
        o_DAC_data_temp <= i_DAC_data_temp(5);
        o_DAC_SYNC <= '0';         
    when t7 =>
        o_DAC_data_sound <= i_DAC_data_sound(4);
        o_DAC_data_temp <= i_DAC_data_temp(4);
        o_DAC_SYNC <= '0';            
    when t8 =>
        o_DAC_data_sound <= i_DAC_data_sound(3);
        o_DAC_data_temp <= i_DAC_data_temp(3);
        o_DAC_SYNC <= '0';     
    when t9 =>
        o_DAC_data_sound <= i_DAC_data_sound(2);
        o_DAC_data_temp <= i_DAC_data_temp(2);
        o_DAC_SYNC <= '0';        
    when t10 =>
        o_DAC_data_sound <= i_DAC_data_sound(1);
        o_DAC_data_temp <= i_DAC_data_temp(1);
        o_DAC_SYNC <= '0';
    when t11 =>
        o_DAC_data_sound <= i_DAC_data_sound(0);
        o_DAC_data_temp <= i_DAC_data_temp(0);
        o_DAC_SYNC <= '0'; 
    end case;
end process;

end Behavioral;