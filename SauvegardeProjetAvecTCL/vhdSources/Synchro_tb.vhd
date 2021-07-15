----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2021 03:18:53 PM
-- Design Name: 
-- Module Name: Synchro_tb - Behavioral
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

entity Synchro_tb is
--  Port ( );
end Synchro_tb;

architecture Behavioral of Synchro_tb is
    component Synchro_DAC_ADC is
    Port ( clk_5MHz : in std_logic;
           d_strobe_100Hz : in std_logic;
           reset : in std_logic;
           o_strobe_ADC : out std_logic
          );
    end component;

signal clk_5MHz, d_strobe_100Hz, strobe_ADC: std_logic := '0';
signal reset: std_logic := '0';
constant period : time := 200ns;

begin
    synchro : Synchro_DAC_ADC
    Port map ( clk_5MHz => clk_5MHz,
           d_strobe_100Hz => d_strobe_100Hz,
           reset => reset,
           o_strobe_ADC => strobe_ADC
          );

process
begin
    clk_5MHz <= '1';
    loop
        wait for period/2; clk_5MHz <= not clk_5MHz;
    end loop;
end process;

tb : process
begin
    wait for period; d_strobe_100Hz <= '1';
    wait for period; d_strobe_100Hz <= '0';   
    wait for period*63;
    wait for period; d_strobe_100Hz <= '1';
    wait for period; d_strobe_100Hz <= '0';    
    wait;
end process;

end Behavioral;
