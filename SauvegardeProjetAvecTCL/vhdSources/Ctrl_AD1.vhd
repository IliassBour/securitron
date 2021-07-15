--------------------------------------------------------------------------------
-- Controle du module pmod AD1
-- Ctrl_AD1.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity Ctrl_AD1 is
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
end Ctrl_AD1;

architecture Behavioral of Ctrl_AD1 is
    component AD7476_mef
    port ( 
            clk_ADC                 : in std_logic;
            reset			        : in std_logic;
            i_ADC_Strobe            : in std_logic;     --  cadence echantillonnage AD1    
            o_ADC_nCS		        : out std_logic;    -- Signal Chip select vers l'ADC  
            o_Decale			    : out std_logic;    -- Signal de décalage   
            o_FinSequence_Strobe    : out std_logic     -- Strobe de fin de séquence d'échantillonnage
    );
    end component;
    
    component reg_dec_12b is
      Port ( 
        i_clk       : in std_logic;      -- horloge
        i_reset     : in std_logic;      -- reinitialisation
        i_load      : in std_logic;      -- activation chargement parallele
        i_en        : in std_logic;      -- activation decalage
        i_dat_bit   : in std_logic;      -- entree serie
        i_dat_load  : in std_logic_vector(11 downto 0);    -- entree parallele
        o_dat       : out  std_logic_vector(11 downto 0)   -- sortie parallele
    );
    end component;  
  
    signal q_decale, q_ADC_nCS, q_FinSeq_str : std_logic;
    signal q_cpt_dat : std_logic_vector(3 downto 0);
    signal q_reg_sound : std_logic_vector(11 downto 0);
    signal q_reg_temp : std_logic_vector(11 downto 0);
    signal d_sortie_sound : std_logic_vector(11 downto 0) := "000000000000";
    signal d_sortie_temp : std_logic_vector(11 downto 0) := "000000000000";
    
begin
--  Machine a etats finis pour le controle du AD7476
    MEF : AD7476_mef
    port map (
        clk_ADC                 => clk_ADC,
        reset                   => reset,
        i_ADC_Strobe            => i_ADC_Strobe,
        o_ADC_nCS               => q_ADC_nCS,
        o_Decale                => q_decale,
        o_FinSequence_Strobe    => q_FinSeq_str
    );
    
    reg_dec_sound : reg_dec_12b
    port map (
            i_clk => clk_ADC,
            i_reset => reset,
            i_load => '0',
            i_en => q_decale,
            i_dat_bit => i_DO_sound,
            i_dat_load => "000000000000",
            o_dat => q_reg_sound
    );
    
    reg_dec_temp : reg_dec_12b
    port map (
            i_clk => clk_ADC,
            i_reset => reset,
            i_load => '0',
            i_en => q_decale,
            i_dat_bit => i_DO_temp,
            i_dat_load => "000000000000",
            o_dat => q_reg_temp
    );
  
    o_echantillon_pret_strobe <= q_FinSeq_str;
    o_ADC_nCS <= q_ADC_nCS;
  
    with q_FinSeq_str select
        d_sortie_sound <= q_reg_sound when '1',
                    d_sortie_sound when others;
                    
    with q_FinSeq_str select
        d_sortie_temp <= q_reg_temp when '1',
                    d_sortie_temp when others;                
                
    o_echantillon_sound <= d_sortie_sound;
    o_echantillon_temp <= d_sortie_temp;
end Behavioral;
