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

entity traitement_temp_min_max is
Port (
    i_clk                         : in    std_logic;
    i_strobe                      : in    std_logic;
    i_reset                       : in    std_logic;
    i_data_echantillon            : in    std_logic_vector(11 downto 0);
    o_data_temp_min               : out   std_logic_vector(11 downto 0);
    o_data_temp_max               : out   std_logic_vector(11 downto 0)
);
end traitement_temp_min_max;

architecture Behavioral of traitement_temp_min_max is
    signal q_temp_min, q_temp_max : std_logic_vector(7 downto 0);
    signal reset_wait             : std_logic := '0';
begin

    process(i_reset, i_data_echantillon)
    begin
        if(i_reset = '1') then
            reset_wait <= '1';
        elsif (i_data_echantillon(11 downto 4) /= x"00") then
            reset_wait <= '0';
        end if;
    end process;

    process(i_clk, i_strobe, i_reset)
    begin
     if(i_reset = '1') then
        q_temp_min <= x"7f"; -- 127
        q_temp_max <= x"d8"; -- -40
     elsif rising_edge(i_clk) and i_strobe='1' and reset_wait='0' then      
       if(i_data_echantillon(11) = '0') then
            if(signed(i_data_echantillon(11 downto 4)) > -41) then
                if(q_temp_min(7) = '0' and (unsigned(q_temp_min(7 downto 0)) > unsigned(i_data_echantillon(11 downto 4)))) then
                    q_temp_min <= i_data_echantillon(10 downto 4) & "0";
                end if;
            end if;
            
            if(signed(i_data_echantillon(11 downto 4)) < 111) then
                if(q_temp_max(7) = '1' or (unsigned(q_temp_max) < unsigned(i_data_echantillon(11 downto 4)))) then
                    q_temp_max <= i_data_echantillon(11 downto 4);
                end if;
            end if;
        else 
            if(signed(i_data_echantillon(11 downto 4)) > -41) then
                if(q_temp_min(7) = '0' or (unsigned(q_temp_min) > unsigned(i_data_echantillon(11 downto 4)))) then
                    q_temp_min <= i_data_echantillon(11 downto 4);
                end if;
            end if;
            
            if(signed(i_data_echantillon(11 downto 4)) < 111) then
                if(q_temp_max(7) = '1' and unsigned(q_temp_max) < unsigned(i_data_echantillon(11 downto 4))) then
                    q_temp_max <= i_data_echantillon(11 downto 4);
                end if;
            end if;
        end if;
     end if;
    end process;
           
    o_data_temp_min <= q_temp_min & "0000";
    o_data_temp_max <= q_temp_max & "0000";

end Behavioral;
