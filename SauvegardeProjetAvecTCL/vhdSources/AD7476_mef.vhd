--------------------------------------------------------------------------------
-- MEF de controle du convertisseur AD7476  
-- AD7476_mef.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 
---------------------------------------------------------------------------------------------
--	Librairy and Package Declarations
---------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

---------------------------------------------------------------------------------------------
--	Entity Declaration
---------------------------------------------------------------------------------------------
entity AD7476_mef is
port(
    clk_ADC                 : in std_logic;
    reset			        : in std_logic;
    i_ADC_Strobe            : in std_logic;     --  cadence echantillonnage AD1    
    o_ADC_nCS		        : out std_logic;    -- Signal Chip select vers l'ADC  
    o_Decale			    : out std_logic;    -- Signal de décalage   
    o_FinSequence_Strobe    : out std_logic     -- Strobe de fin de séquence d'échantillonnage
);
end AD7476_mef;
 
---------------------------------------------------------------------------------------------
--	Object declarations
---------------------------------------------------------------------------------------------
architecture Behavioral of AD7476_mef is 
    type State_type is (Init, w0, w1, w2, w3, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, Send);
    signal etat_courant, etat_suivant : State_type;

begin

clock : process (clk_ADC, reset)
begin
    if reset = '1' then
        etat_courant <= Init;
    end if;
    if falling_edge(clk_ADC) then
        etat_courant <= etat_suivant;
    end if;
end process;

etat : process (etat_courant, i_ADC_Strobe)
begin
    case etat_courant is
    when Init =>
        if (i_ADC_Strobe = '1') then 
            etat_suivant <= w0;
        else
            etat_suivant <= Init;
        end if;
    when w0 =>
            etat_suivant <= w1;
    when w1 =>
            etat_suivant <= w2;
    when w2 =>
            etat_suivant <= w3;
    when w3 =>
            etat_suivant <= s0;
    when s0 =>
            etat_suivant <= s1;
    when s1 =>
            etat_suivant <= s2;
    when s2 =>
            etat_suivant <= s3;
    when s3 =>
            etat_suivant <= s4;
    when s4 =>
            etat_suivant <= s5;
    when s5 =>
            etat_suivant <= s6;
    when s6 =>
            etat_suivant <= s7;
    when s7 =>
            etat_suivant <= s8;
    when s8 =>
            etat_suivant <= s9;
    when s9 =>
            etat_suivant <= s10;
    when s10 =>
            etat_suivant <= s11;
    when s11 =>
            etat_suivant <= Send;       
    when Send =>
        etat_suivant <= Init;
    when others =>
        etat_suivant <= Init;
    end case;

end process;

process (etat_courant)
begin
    case etat_courant is
    when Init =>
        o_ADC_nCS <= '1';
        o_Decale <= '0';
        o_FinSequence_Strobe <= '0';
    when w0 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when w1 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when w2 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when w3 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s0 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s1 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s2 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s3 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s4 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s5 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s6 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s7 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s8 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s9 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s10 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when s11 =>
            o_ADC_nCS <= '0';
            o_Decale <= '1';
            o_FinSequence_Strobe <= '0';
    when Send =>
        o_ADC_nCS <= '1';
        o_Decale <= '0';
        o_FinSequence_Strobe <= '1';
    end case;
end process;

end Behavioral;
