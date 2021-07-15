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

entity CTRL_DA1_tb is
--  Port ( );
end CTRL_DA1_tb;

architecture Behavioral of CTRL_DA1_tb is

component Ctrl_DA1
port ( 
    reset : in std_logic;
    clk_DAC : in std_logic;
    i_DAC_Strobe : in std_logic;
    o_DAC_SYNC : out std_logic;
    o_signal_analogique : out std_logic
);
end component;

signal sim_reset, sim_clk_DAC, sim_DAC_Strobe, sim_signal_analogique, sim_DAC_SYNC : std_logic;
constant period : time := 200ns;

begin

UUT : Ctrl_DA1
port map(
    reset => sim_reset,
    clk_DAC => sim_clk_DAC,
    o_DAC_SYNC => sim_DAC_SYNC,
    i_DAC_Strobe => sim_DAC_Strobe,
    o_signal_analogique => sim_signal_analogique
);

process
begin
    sim_clk_DAC <= '1';
    loop
        wait for period/2; sim_clk_DAC <= not sim_clk_DAC;
    end loop;
end process;

tb : process
begin
    sim_reset <= '1'; sim_DAC_Strobe <= '0';
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '0'; 
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '1';
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '0';
    
    wait for period *20; sim_reset <= '0'; sim_DAC_Strobe <= '1';
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '0';
    
    wait for period *20; sim_reset <= '0'; sim_DAC_Strobe <= '1';
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '0';
    
    wait for period *20; sim_reset <= '0'; sim_DAC_Strobe <= '1';
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '0';
    
    wait for period *20; sim_reset <= '0'; sim_DAC_Strobe <= '1';
    wait for period; sim_reset <= '0'; sim_DAC_Strobe <= '0';

    wait;
end process;

end Behavioral;
