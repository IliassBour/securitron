----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/01/2021 03:49:25 PM
-- Design Name: 
-- Module Name: Top_tb - Behavioral
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

entity Top_tb is
--  Port ( );
end Top_tb;

architecture Behavioral of Top_tb is

--component Top is
--port (
--    sys_clock       : in std_logic;
--    o_leds          : out std_logic_vector ( 3 downto 0 );
--    i_sw            : in std_logic_vector ( 3 downto 0 );
--    i_btn           : in std_logic_vector ( 3 downto 0 );
--    o_ledtemoin_b   : out std_logic;
    
----    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JD
----    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
--    -- Pmod_AD1 - port_JC haut
--    o_ADC_NCS       : out std_logic;  
--    i_ADC_D0        : in std_logic;
--    i_ADC_D1        : in std_logic;
--    o_ADC_CLK       : out std_logic;
    
--    -- Pmod_DA2 - port_JD haut 
--    o_DAC_NCS       : out std_logic;  
--    o_DAC_D0        : out std_logic;
--    o_DAC_D1        : out std_logic;
--    o_DAC_CLK       : out std_logic
    
----    --Design wrapper
----    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
----    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
----    DDR_cas_n : inout STD_LOGIC;
----    DDR_ck_n : inout STD_LOGIC;
----    DDR_ck_p : inout STD_LOGIC;
----    DDR_cke : inout STD_LOGIC;
----    DDR_cs_n : inout STD_LOGIC;
----    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
----    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
----    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
----    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
----    DDR_odt : inout STD_LOGIC;
----    DDR_ras_n : inout STD_LOGIC;
----    DDR_reset_n : inout STD_LOGIC;
----    DDR_we_n : inout STD_LOGIC;
----    FIXED_IO_ddr_vrn : inout STD_LOGIC;
----    FIXED_IO_ddr_vrp : inout STD_LOGIC;
----    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
----    FIXED_IO_ps_clk : inout STD_LOGIC;
----    FIXED_IO_ps_porb : inout STD_LOGIC;
----    FIXED_IO_ps_srstb : inout STD_LOGIC 
--);
--end component;

--signal sim_sys_clock, sim_o_ledtemoin_b, sim_o_ADC_NCS, sim_i_ADC_D0, sim_i_ADC_D1, sim_o_ADC_CLK, sim_o_DAC_NCS, sim_o_DAC_D0, sim_o_DAC_D1, sim_o_DAC_CLK: std_logic;
--signal sim_o_leds, sim_i_sw, sim_i_btn : std_logic_vector(3 downto 0);

    constant freq_sys_MHz: integer := 125;  -- MHz

    component Ctrl_AD1 is
    port ( 
        reset                       : in    std_logic;
        
        clk_ADC                     : in    std_logic;                      -- Horloge fourni � l'ADC
        i_DO_sound                        : in    std_logic;                -- Bit de donn�e en provenance de l'ADC pour le son
        i_DO_temp                        : in    std_logic;          
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- synchronisation: d�clencheur de la s�quence d'�chantillonnage  
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une r�ception compl�te d'un �chantillon  
        o_echantillon_sound               : out   std_logic_vector (11 downto 0); -- valeur de l'�chantillon re�u son
        o_echantillon_temp               : out   std_logic_vector (11 downto 0) -- valeur de l'�chantillon re�u temp�rature
    );
    end  component;
    
    component Ctrl_DA1 is
    port (
         reset : in std_logic;
         clk_DAC : in std_logic;
         o_DAC_SYNC : out std_logic;
         i_DAC_Strobe : in std_logic;
         o_signal_analogique_sound : out std_logic;
         o_signal_analogique_temp : out std_logic
    );
    end component;
    
    component traitement_temp_moy is
    Port (
        i_clk                         : in    std_logic;
        i_strobe                      : in    std_logic;
        i_reset                       : in    std_logic;
        i_data_echantillon            : in    std_logic_vector(11 downto 0);
        o_data_temp_moy               : out   std_logic_vector(11 downto 0)
    );
    end component;

   
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entr�e  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component; 

    constant period : time := 20ns;
    signal sys_clock : std_logic;
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    
    signal reset                        : std_logic; 
    
    signal d_echantillon_pret_strobe    : std_logic;
    signal d_ADC_Dselect                : std_logic; 
    signal d_echantillon                : std_logic_vector (11 downto 0); 

    signal compteur_en               : std_logic := '0';  -- cadence echantillonnage AD1
    signal compteur_reset                        : std_logic;
    signal compteur_val              : integer := 0;
    signal strobe_ADC                : std_logic := '0';
    
    signal strobe_1Hz : std_logic;
    
    --signal tempClockDAC_ADC : std_logic;
    
    signal lecture : std_logic := '0';
    signal strobe_DAC : std_logic;
    signal d_S_1Hz_minus_1 : std_logic;
    
        -- Pmod_AD1 - port_JC haut
    signal o_ADC_NCS       : std_logic;  
    signal i_ADC_D0        : std_logic;
    signal i_ADC_D1        : std_logic;
    signal o_ADC_CLK       : std_logic;
    
    -- Pmod_DA2 - port_JD haut 
    signal o_DAC_NCS       : std_logic;  
    signal o_DAC_D0        : std_logic;
    signal o_DAC_D1        : std_logic;
    signal o_DAC_CLK       : std_logic;
    
    --Temp
    signal d_temp_moy : std_logic_vector (11 downto 0);
begin

process
begin
    sys_clock <= '1';
    loop
        wait for period/2; sys_clock <= not sys_clock;
    end loop;
end process;

    --reset <= '0';

    Controleur_ADC :  Ctrl_AD1 
    port map(
        reset                       => reset,
        
        clk_ADC                     => clk_5MHz,                    -- pour horloge externe de l'ADC 
        i_DO_sound                        => i_ADC_D0,               -- bit de donn�es provenant de l'ADC (via um mux)       
        i_DO_temp => i_ADC_D1,
        o_ADC_nCS                   => o_ADC_NCS,                   -- chip select pour le convertisseur (ADC )
        
        i_ADC_Strobe                => strobe_DAC, --strobe_ADC,              -- synchronisation: d�clencheur de la s�quence d'�chantillonnage 
        o_echantillon_pret_strobe   => d_echantillon_pret_strobe,   -- strobe indicateur d'une r�ception compl�te d'un �chantillon 
        o_echantillon_sound               => open,                -- valeur de l'�chantillon re�u (12 bits)
        o_echantillon_temp => d_echantillon
    );
    
    i_ADC_D0 <= o_DAC_D0;
    i_ADC_D1 <= o_DAC_D1;
    
    Controleur_DAC :  Ctrl_DA1
    port map(
        reset => reset,
        clk_DAC => clk_5MHz,
        o_DAC_SYNC => o_DAC_NCS,
        i_DAC_Strobe => strobe_DAC,
        o_signal_analogique_sound => o_DAC_D0,
        o_signal_analogique_temp => o_DAC_D1
    );
    
    temp_moy: traitement_temp_moy 
        Port map (
        i_clk => clk_5MHz,
        i_strobe => d_echantillon_pret_strobe,
        i_reset => reset,
        i_data_echantillon => d_echantillon,
        o_data_temp_moy => d_temp_moy
    );
      
   Synchronisation : Synchro_Horloges
    port map (
           clkm         =>  sys_clock,
           o_S_5MHz     =>  open,
           o_CLK_5MHz   => clk_5MHz,
           o_S_100Hz    => open,
           o_stb_100Hz  => d_strobe_100Hz,
           o_S_1Hz      => strobe_1Hz
    );
    
    o_ADC_CLK <= clk_5MHz;
    o_DAC_CLK <= clk_5MHz;
    
    syncroV2 : process (clk_5MHz)
    begin
        if(rising_edge(clk_5MHz)) then
            strobe_ADC <= '0';
            if(strobe_DAC = '1') then
                lecture <= '1';
            end if;
            if(lecture = '1') then    
                compteur_val <= compteur_val + 1;
            end if;
            if(compteur_val = 1000) then -- 1000 coups
                strobe_ADC <= '1';
                compteur_val <= 0;
                lecture <= '0';
            end if;
        end if;
    end process;
    
    process(clk_5MHz)
    begin
        if (rising_edge(clk_5MHz)) then
            d_S_1Hz_minus_1 <= d_strobe_100Hz;
        end if;
    end process;
    
    strobe_DAC <= d_strobe_100Hz and (not d_S_1Hz_minus_1);

--UUT : Top
--port map(
--    sys_clock => sim_sys_clock,
--    o_leds => sim_o_leds,
--    i_sw => sim_i_sw,
--    i_btn => sim_i_btn,
--    o_ledtemoin_b => sim_o_ledtemoin_b,
--    o_ADC_NCS => sim_o_ADC_NCS,
--    i_ADC_D0 => sim_i_ADC_D0,
--    i_ADC_D1 => sim_i_ADC_D1,
--    o_ADC_CLK => sim_o_ADC_CLK,
--    o_DAC_NCS => sim_o_DAC_NCS,
--    o_DAC_D0 => sim_o_DAC_D0,
--    o_DAC_D1 => sim_o_DAC_D1,
--    o_DAC_CLK => sim_o_DAC_CLK
--);

--process
--begin
--    sim_sys_clock <= '1';
--    loop
--        wait for period/2; sim_sys_clock <= not sim_sys_clock;
--    end loop;
--end process;

tb : process
begin
    
    wait for period; reset <= '0';
    wait for period; reset <= '1';
    wait for period; reset <= '0';
    wait for period; reset <= '0';

    wait;
end process;

end Behavioral;
