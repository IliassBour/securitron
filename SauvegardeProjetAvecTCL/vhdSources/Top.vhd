----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 Génie informatique - H21
-- Larissa Njejimana
-- v.3 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Top is
port (
    sys_clock       : in std_logic;
    o_leds          : out std_logic_vector ( 3 downto 0 );
    i_sw            : in std_logic_vector ( 3 downto 0 );
    i_btn           : in std_logic_vector ( 3 downto 0 );
    o_ledtemoin_b   : out std_logic;
    
    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JD
    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
    -- Pmod_AD1 - port_JC haut
    o_ADC_NCS       : out std_logic;  
    i_ADC_D0        : in std_logic;
    i_ADC_D1        : in std_logic;
    o_ADC_CLK       : out std_logic;
    
    -- Pmod_DA2 - port_JD haut 
    o_DAC_NCS       : out std_logic;  
    o_DAC_D0        : out std_logic;
    o_DAC_D1        : out std_logic;
    o_DAC_CLK       : out std_logic;
    
    --Design wrapper
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC 
);
end Top;

architecture Behavioral of Top is

    constant freq_sys_MHz: integer := 125;  -- MHz

    component Ctrl_AD1 is
    port ( 
        reset                       : in    std_logic;  
        clk_ADC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
        i_DO_sound                  : in    std_logic;                -- Bit de donnée en provenance de l'ADC pour le son
        i_DO_temp                   : in    std_logic;                -- Bit de donnée en provenance de l'ADC pour la température    
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception    
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
        o_echantillon_sound         : out   std_logic_vector (11 downto 0); -- valeur de l'échantillon reçu son
        o_echantillon_temp          : out   std_logic_vector (11 downto 0) -- valeur de l'échantillon reçu température
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
   
   component traitement_son_moy is
      port (
        i_clk                         : in    std_logic;
        i_strobe                      : in    std_logic;
        i_reset                       : in    std_logic;
        i_data_echantillon            : in    std_logic_vector(11 downto 0);
        o_data_son_moy                : out   std_logic_vector(11 downto 0)
      );
    end component;
    
    component traitement_temp_moy is
      port (
        i_clk                         : in    std_logic;
        i_strobe                      : in    std_logic;
        i_reset                       : in    std_logic;
        i_data_echantillon            : in    std_logic_vector(11 downto 0);
        o_data_temp_moy               : out   std_logic_vector(11 downto 0)
      );
    end component;
    
    component traitement_temp_min_max is
      port (
        i_clk                         : in    std_logic;
        i_strobe                      : in    std_logic;
        i_reset                       : in    std_logic;
        i_data_echantillon            : in    std_logic_vector(11 downto 0);
        o_data_temp_min               : out   std_logic_vector(11 downto 0);
        o_data_temp_max               : out   std_logic_vector(11 downto 0)
      );
    end component;
   
    component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component; 
    
    component Synchro_DAC_ADC is
    Port ( clk_5MHz : in std_logic;
           d_strobe_100Hz : in std_logic;
           reset : in std_logic;
           o_strobe_ADC : out std_logic
          );
    end component;
    
    component compteur_nbits is
    generic (nbits : integer := 6);
       port ( clk             : in    std_logic; 
              i_en            : in    std_logic; 
              reset           : in    std_logic; 
              o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
              );
    end component;
    
    component design_1_wrapper is
      port (
        DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
        DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
        DDR_cas_n : inout STD_LOGIC;
        DDR_ck_n : inout STD_LOGIC;
        DDR_ck_p : inout STD_LOGIC;
        DDR_cke : inout STD_LOGIC;
        DDR_cs_n : inout STD_LOGIC;
        DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
        DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_odt : inout STD_LOGIC;
        DDR_ras_n : inout STD_LOGIC;
        DDR_reset_n : inout STD_LOGIC;
        DDR_we_n : inout STD_LOGIC;
        FIXED_IO_ddr_vrn : inout STD_LOGIC;
        FIXED_IO_ddr_vrp : inout STD_LOGIC;
        FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
        FIXED_IO_ps_clk : inout STD_LOGIC;
        FIXED_IO_ps_porb : inout STD_LOGIC;
        FIXED_IO_ps_srstb : inout STD_LOGIC;
        Pmod_OLED_pin10_io : inout STD_LOGIC;
        Pmod_OLED_pin1_io : inout STD_LOGIC;
        Pmod_OLED_pin2_io : inout STD_LOGIC;
        Pmod_OLED_pin3_io : inout STD_LOGIC;
        Pmod_OLED_pin4_io : inout STD_LOGIC;
        Pmod_OLED_pin7_io : inout STD_LOGIC;
        Pmod_OLED_pin8_io : inout STD_LOGIC;
        Pmod_OLED_pin9_io : inout STD_LOGIC;
        i_data_son : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_data_temp : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_son_max : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_son_min : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_son_moy : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
        i_temp_max : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_temp_min : in STD_LOGIC_VECTOR ( 11 downto 0 );
        i_temp_moy : in STD_LOGIC_VECTOR ( 11 downto 0 );
        o_data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
        o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 )
      );
    end component;
    
    component Pblaze_uCtrler
    port (
    clk                     : in std_logic;
    i_ADC_echantillon       : in std_logic_vector (11 downto 0); 
    i_ADC_echantillon_pret  : in std_logic;
    o_compteur              : out std_logic_vector(3 downto 0);
    o_echantillon_out       : out std_logic_vector(7 downto 0);
    o_echantillon_outMax    : out std_logic_vector(7 downto 0)
   
  );
  end component;
    
    --signaux 
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    
    signal reset                        : std_logic; 
    
    signal d_echantillon_pret_strobe    : std_logic;
--    signal d_ADC_Dselect                : std_logic; 
    signal d_echantillon_son            : std_logic_vector (11 downto 0);
    signal d_son_moy                    : std_logic_vector (11 downto 0);
    signal d_son_min                    : std_logic_vector (11 downto 0);
    signal d_son_max                    : std_logic_vector (11 downto 0);
    signal d_echantillon_temp           : std_logic_vector (11 downto 0);
    signal d_temp_moy                   : std_logic_vector (11 downto 0);
    signal d_temp_min                   : std_logic_vector (11 downto 0);
    signal d_temp_max                   : std_logic_vector (11 downto 0);

    signal compteur_en               : std_logic := '0';  -- cadence echantillonnage AD1
    signal compteur_reset                        : std_logic;
    signal compteur_val              : integer := 0;
    signal strobe_ADC                : std_logic := '0';
    
    signal strobe_1Hz : std_logic;
    
    signal compteur_1min : integer := 0;
    signal reset_1min : std_logic;
    signal d_reset : std_logic;
    
    signal lecture : std_logic := '0';
    signal strobe_DAC : std_logic;
    signal d_S_1Hz_minus_1 : std_logic;
begin
    reset    <= i_btn(0);
    d_reset <= reset or reset_1min;
        
--     mux_select_Entree_AD1 : process (i_btn(3), i_ADC_D0, i_ADC_D1)
--     begin
--          if (i_btn(3) ='0') then 
--            d_ADC_Dselect <= i_ADC_D0;
--          else
--            d_ADC_Dselect <= i_ADC_D1;
--          end if;
--     end process;
     
    Controleur_ADC :  Ctrl_AD1 
    port map(
        reset                       => reset,
        
        clk_ADC                     => clk_5MHz,                    -- pour horloge externe de l'ADC 
        i_DO_sound                  => i_ADC_D0,               -- bit de données du son     
        i_DO_temp                  => i_ADC_D1,               -- bit de données de la température      
        o_ADC_nCS                   => o_ADC_NCS,                   -- chip select pour le convertisseur (ADC )
        
        i_ADC_Strobe                => strobe_ADC,              -- synchronisation: déclencheur de la séquence d'échantillonnage 
        o_echantillon_pret_strobe   => d_echantillon_pret_strobe,   -- strobe indicateur d'une réception complète d'un échantillon 
        o_echantillon_sound         => d_echantillon_son,                -- valeur de l'échantillon reçu (12 bits)
        o_echantillon_temp          => d_echantillon_temp
    );

    Controleur_DAC :  Ctrl_DA1
    port map(
        reset => reset,
        clk_DAC => clk_5MHz,
        o_DAC_SYNC => o_DAC_NCS,
        i_DAC_Strobe => strobe_DAC,
        o_signal_analogique_sound => o_DAC_D0,
        o_signal_analogique_temp => o_DAC_D1
    );
    
    Son_moy : traitement_son_moy
    port map(
        i_clk => clk_5MHz,
        i_strobe => d_echantillon_pret_strobe,
        i_reset => reset,
        i_data_echantillon => d_echantillon_son,
        o_data_son_moy => d_son_moy
    );
    
    Temp_moy : traitement_temp_moy
    port map(
        i_clk => clk_5MHz,
        i_strobe => d_echantillon_pret_strobe,
        i_reset => reset,
        i_data_echantillon => d_echantillon_temp,
        o_data_temp_moy => d_temp_moy
    );
      
    Temp_min_max : traitement_temp_min_max
    port map(
        i_clk => clk_5MHz,
        i_strobe => d_echantillon_pret_strobe,
        i_reset => d_reset,
        i_data_echantillon => d_echantillon_temp,
        o_data_temp_min => d_temp_min,
        o_data_temp_max => d_temp_max
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
    
    process(d_echantillon_pret_strobe)
    begin
        reset_1min <= '0';
        if(d_echantillon_pret_strobe = '1') then
            compteur_1min <= compteur_1min + 1;
        end if;
        if(compteur_1min = 60) then
            reset_1min <= '1';
            compteur_1min <= 0;
        end if;
    end process;
    
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
            d_S_1Hz_minus_1 <= strobe_1Hz;
        end if;
    end process;
    
    strobe_DAC <= strobe_1Hz and (not d_S_1Hz_minus_1);
    
    o_ledtemoin_b <= strobe_1Hz;
--    o_leds <= d_echantillon (3 downto 0);
--    Pmod_8LD <= d_echantillon (11 downto 4);
    
    BlockDesign : design_1_wrapper
    port map(
        DDR_addr => DDR_addr,
        DDR_ba => DDR_ba,
        DDR_cas_n => DDR_cas_n,
        DDR_ck_n => DDR_ck_n,
        DDR_ck_p => DDR_ck_p,
        DDR_cke => DDR_cke,
        DDR_cs_n => DDR_cs_n,
        DDR_dm => DDR_dm,
        DDR_dq => DDR_dq,
        DDR_dqs_n => DDR_dqs_n,
        DDR_dqs_p => DDR_dqs_p,
        DDR_odt => DDR_odt,
        DDR_ras_n => DDR_ras_n,
        DDR_reset_n => DDR_reset_n,
        DDR_we_n => DDR_we_n,
        FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
        FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
        FIXED_IO_mio =>FIXED_IO_mio ,
        FIXED_IO_ps_clk => FIXED_IO_ps_clk,
        FIXED_IO_ps_porb => FIXED_IO_ps_porb,
        FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
        Pmod_OLED_pin1_io => Pmod_OLED(0),
        Pmod_OLED_pin2_io => Pmod_OLED(1),
        Pmod_OLED_pin3_io => Pmod_OLED(2),
        Pmod_OLED_pin4_io => Pmod_OLED(3),
        Pmod_OLED_pin7_io => Pmod_OLED(4),
        Pmod_OLED_pin8_io => Pmod_OLED(5),
        Pmod_OLED_pin9_io => Pmod_OLED(6),
        Pmod_OLED_pin10_io => Pmod_OLED(7),
        i_data_son => d_echantillon_son,
        i_data_temp => d_echantillon_temp,
        i_son_max => d_son_max,
        i_son_min => d_son_min,
        i_son_moy => d_son_moy,
        i_temp_max => d_temp_max,
        i_temp_min => d_temp_min,
        i_temp_moy => d_temp_moy,
        i_sw_tri_i => i_sw,
        o_data_out => open,
        o_leds_tri_o => o_leds
    );

    PblazeMin: Pblaze_uCtrler
    port map(
        clk                     => clk_5MHz,
        i_ADC_echantillon       => d_echantillon_son,
        i_ADC_echantillon_pret  =>d_echantillon_pret_strobe,
        o_compteur              => open,
        o_echantillon_out       => d_son_min(7 downto 0),
        o_echantillon_outMax    => d_son_max(7 downto 0)
    );

end Behavioral;

