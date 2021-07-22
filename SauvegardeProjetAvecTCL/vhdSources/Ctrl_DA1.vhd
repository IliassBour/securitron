----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2021 04:03:57 PM
-- Design Name: 
-- Module Name: Ctrl_DA1 - Behavioral
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

entity Ctrl_DA1 is
    port (
        reset : in std_logic;
        clk_DAC : in std_logic;
        i_DAC_Strobe : in std_logic;
        o_signal_analogique_sound : out std_logic;
        o_signal_analogique_temp : out std_logic;
        o_DAC_SYNC  : out std_logic
    );
end Ctrl_DA1;

architecture Behavioral of Ctrl_DA1 is

constant nbEchantillonMemoire : integer := 24;

type table_forme is array (integer range 0 to nbEchantillonMemoire-1) of std_logic_vector(11 downto 0);
constant mem_sound : table_forme := (
-- forme d'une onde carrée
-- ** Mettre un 8 en LSB pour lerreur du bruit (+/- 8) pour pas modifier nos valeurs
-- et modifier la taille du vecteur -> nbEchantillonMemoire
x"308",
x"318",
x"328",
x"338",
x"348",
x"358",
x"368",
x"378",
x"388",
x"398",
x"3A8",
x"3B8",
x"3C8",
x"3D8",
x"3E8",
x"3F8",
x"408",
x"418",
x"428",
x"418",
x"408",
x"3F8",
x"3E8",
x"3D8"
);

constant mem_temperature : table_forme := (
-- forme d'une onde carrée
-- ** Mettre un 8 en LSB pour lerreur du bruit (+/- 8) pour pas modifier nos valeurs
-- et modifier la taille du vecteur -> nbEchantillonMemoire
x"6e8", -- 110 oC
x"608",
x"5e8",
x"508",
x"4e8",
x"408",
x"3e8",
x"308",
x"2e8",
x"208",
x"1e8",
x"108",
x"0e8",
x"008",
x"ff8",
x"f08",
x"da8",
x"ef8",
x"e08",
x"df8",
x"0a8",
x"d88", -- -40 oC
x"d88",
x"6e8"
);

component MEF_DA1 is 
    port (
        clk_DAC                 : in std_logic;
        reset                    : in std_logic;
        i_DAC_Strobe            : in std_logic;     --  cadence echantillonnage AD1
        i_DAC_data_sound              : in std_logic_vector(11 downto 0);
        i_DAC_data_temp              : in std_logic_vector(11 downto 0);
        o_DAC_data_sound              : out std_logic;
        o_DAC_data_temp              : out std_logic;
        o_DAC_SYNC              : out std_logic
    );
end component;

signal d_compteur_echantillon_sound : unsigned(7 downto 0);
signal d_echantillon_sound : std_logic_vector(11 downto 0);
signal q_iteration_sound : unsigned(4 downto 0);

signal d_compteur_echantillon_temperature : unsigned(7 downto 0);
signal d_echantillon_temperature : std_logic_vector(11 downto 0);
signal q_iteration_temperature : unsigned(4 downto 0);

signal d_DAC_SYNC : std_logic;

constant c_NbIterations       : integer := 100; -- nombre de fois qu'on veut parcourir le tableau-m�moire

begin

LireSon : process(reset, clk_DAC)
begin
    if(reset = '1') then 
        d_compteur_echantillon_sound <= x"00";
        d_echantillon_sound <= X"000";
        q_iteration_sound <= (others => '0');
    else
        if(rising_edge(clk_DAC)) then
            if(i_DAC_Strobe = '1') then
                d_echantillon_sound <= mem_sound(to_integer(d_compteur_echantillon_sound));
                if(to_integer(q_iteration_sound) < c_NbIterations) then 
                    if(d_compteur_echantillon_sound = mem_sound'length - 1) then
                        d_compteur_echantillon_sound <= x"00";
                        q_iteration_sound <= q_iteration_sound + 1;
                    else
                        d_compteur_echantillon_sound <= d_compteur_echantillon_sound + 1;
                    end if;
                end if;
            end if;
        end if;
    end if;
end process;
    
LireTemperature : process(reset, clk_DAC)
begin
    if(reset = '1') then 
        d_compteur_echantillon_temperature <= x"00";
        d_echantillon_temperature <= X"000";
        q_iteration_temperature <= (others => '0');
    else
        if(rising_edge(clk_DAC)) then
            if(i_DAC_Strobe = '1') then
                d_echantillon_temperature <= mem_temperature(to_integer(d_compteur_echantillon_temperature));
                if(to_integer(q_iteration_temperature) < c_NbIterations) then 
                    if(d_compteur_echantillon_temperature = mem_temperature'length - 1) then
                        d_compteur_echantillon_temperature <= x"00";
                        q_iteration_temperature <= q_iteration_temperature + 1;
                    else
                        d_compteur_echantillon_temperature <= d_compteur_echantillon_temperature + 1;
                    end if;
                end if;
            end if;
        end if;
    end if;
end process;    

MEF : MEF_DA1
    port map (
        clk_DAC => clk_DAC,
        reset => reset,
        i_DAC_Strobe => i_DAC_Strobe,
        i_DAC_data_sound => d_echantillon_sound,
        i_DAC_data_temp => d_echantillon_temperature,
        o_DAC_data_sound => o_signal_analogique_sound,
        o_DAC_data_temp => o_signal_analogique_temp,
        o_DAC_SYNC => d_DAC_SYNC
    );
o_DAC_SYNC <= d_DAC_SYNC;
end Behavioral;
